require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe DataObjects::URI do
  subject { described_class.parse(uri) }

  context 'parsing parts' do
    let(:uri) { 'mock://username:password@localhost:12345/path?encoding=utf8#fragment' }

    its(:scheme)    { should eq 'mock'      }
    its(:user)      { should eq 'username'  }
    its(:password)  { should eq 'password'  }
    its(:host)      { should eq 'localhost' }
    its(:port)      { should eq 12_345 }
    its(:path)      { should eq '/path' }
    its(:query)     { should eq({ 'encoding' => 'utf8' }) }
    its(:fragment)  { should eq 'fragment' }

    it 'should provide a correct string representation' do
      subject.to_s.should == 'mock://username@localhost:12345/path?encoding=utf8#fragment'
    end
  end

  context 'parsing JDBC URL parts' do
    let(:uri) { 'jdbc:mock://username:password@localhost:12345/path?encoding=utf8#fragment' }

    its(:scheme)    { should eq 'jdbc'      }
    its(:subscheme) { should eq 'mock'      }
    its(:user)      { should eq 'username'  }
    its(:password)  { should eq 'password'  }
    its(:host)      { should eq 'localhost' }
    its(:port)      { should eq 12_345 }
    its(:path)      { should eq '/path' }
    its(:query)     { should eq({ 'encoding' => 'utf8' }) }
    its(:fragment)  { should eq 'fragment' }

    it 'should provide a correct string representation' do
      subject.to_s.should eq 'jdbc:mock://username@localhost:12345/path?encoding=utf8#fragment'
    end
  end

  context 'parsing parts' do
    let(:uri) { 'java:comp/env/jdbc/TestDataSource' }

    its(:scheme)    { should eq 'java' }
    its(:path)      { should eq 'comp/env/jdbc/TestDataSource' }

    it 'should provide a correct string representation' do
      subject.to_s.should eq 'java:comp/env/jdbc/TestDataSource'
    end
  end
end
