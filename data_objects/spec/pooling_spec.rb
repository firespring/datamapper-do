require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'timeout'

describe 'DataObjects::Pooling' do
  before do
    Object.send(:remove_const, :Person) if defined?(Person)
    class ::Person
      include DataObjects::Pooling

      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def dispose
        @name = nil
      end
    end

    Object.send(:remove_const, :Overwriter) if defined?(Overwriter)
    class ::Overwriter
      def self.new(*args)
        instance = allocate
        instance.send(:initialize, *args)
        instance.overwritten = true
        instance
      end

      include DataObjects::Pooling

      attr_accessor :name

      def initialize(name)
        @name = name
        @overwritten = false
      end

      def overwritten?
        @overwritten
      end

      attr_writer :overwritten

      class << self
        remove_method :pool_size if instance_methods(false).any? { |m| m.to_sym == :pool_size }
        def pool_size
          if RUBY_PLATFORM =~ /java/
            20
          else
            2
          end
        end
      end

      def dispose
        @name = nil
      end
    end
  end

  after :each do
    DataObjects::Pooling.lock.synchronize do
      DataObjects::Pooling.pools.each do |pool|
        pool.lock.synchronize do
          pool.dispose
        end
      end
    end
  end

  it 'maintains a size of 1' do
    bob = Person.new('Bob')
    fred = Person.new('Fred')
    ted = Person.new('Ted')

    Person.__pools.each_value do |pool|
      pool.size.should eq 1
    end

    bob.release
    fred.release
    ted.release

    Person.__pools.each_value do |pool|
      pool.size.should eq 1
    end
  end

  it 'tracks the initialized pools' do
    bob = Person.new('Bob') # Ensure the pool is "primed"
    bob.name.should eq 'Bob'
    bob.instance_variable_get(:@__pool).should_not be_nil
    Person.__pools.size.should eq 1
    bob.release
    Person.__pools.size.should eq 1

    DataObjects::Pooling.pools.should_not be_empty

    sleep(1.2)

    # NOTE: This assertion is commented out, as our MockConnection objects are
    #       currently in the pool.
    # DataObjects::Pooling::pools.should be_empty
    bob.name.should be_nil
  end

  it 'allows you to overwrite Class#new' do
    bob = Overwriter.new('Bob')
    bob.should be_overwritten
    bob.release
  end

  it 'allows multiple threads to access the pool' do
    t1 = Thread.new do
      bob = Person.new('Bob')
      sleep(1)
      bob.release
    end

    lambda do
      bob = Person.new('Bob')
      t1.join
      bob.release
    end.should_not raise_error(DataObjects::Pooling::InvalidResourceError)
  end

  it 'allows you to flush a pool' do
    bob = Overwriter.new('Bob')
    Overwriter.new('Bob').release
    bob.release

    bob.name.should eq 'Bob'

    Overwriter.__pools[['Bob']].size.should eq 2
    Overwriter.__pools[['Bob']].flush!
    Overwriter.__pools[['Bob']].size.should eq 0

    bob.name.should be_nil
  end

  it 'wakes up the scavenger thread when exiting' do
    bob = Person.new('Bob')
    bob.release
    DataObjects.exiting = true
    sleep(1)
    DataObjects::Pooling.scavenger?.should be false
  end

  it 'detaches an instance from the pool' do
    bob = Person.new('Bob')
    Person.__pools[['Bob']].size.should eq 1
    bob.detach
    Person.__pools[['Bob']].size.should eq 0
  end
end
