module DataObjects
  # Abstract base class for adapter-specific Command subclasses
  class Command
    # The Connection on which the command will be run
    attr_reader :connection

    # Create a new Command object on the specified connection
    def initialize(connection, text)
      raise ArgumentError, '+connection+ must be a DataObjects::Connection' unless connection.is_a?(DataObjects::Connection)

      @connection = connection
      @text = text
    end

    # Execute this command and return no dataset
    def execute_non_query(*_args)
      raise NotImplementedError
    end

    # Execute this command and return a DataObjects::Reader for a dataset
    def execute_reader(*_args)
      raise NotImplementedError
    end

    # Assign an array of types for the columns to be returned by this command
    def set_types(_column_types)
      raise NotImplementedError
    end

    # Display the command text
    def to_s
      @text
    end

    # Escape a string of SQL with a set of arguments.
    # The first argument is assumed to be the SQL to escape,
    # the remaining arguments (if any) are assumed to be
    # values to escape and interpolate.
    #
    # ==== Examples
    #   escape_sql("SELECT * FROM zoos")
    #   # => "SELECT * FROM zoos"
    #
    #   escape_sql("SELECT * FROM zoos WHERE name = ?", "Dallas")
    #   # => "SELECT * FROM zoos WHERE name = `Dallas`"
    #
    #   escape_sql("SELECT * FROM zoos WHERE name = ? AND acreage > ?", "Dallas", 40)
    #   # => "SELECT * FROM zoos WHERE name = `Dallas` AND acreage > 40"
    #
    # ==== Warning
    # This method is meant mostly for adapters that don't support
    # bind-parameters.
    private def escape_sql(args)
      return @text if args.empty?

      sql = @text.dup
      vars = args.dup

      replacements = 0
      mismatch     = false

      sql.gsub!(/'[^']*'|"[^"]*"|`[^`]*`|\?/) do |x|
        next x unless x == '?'

        replacements += 1
        if vars.empty?
          mismatch = true
        else
          var = vars.shift
          connection.quote_value(var)
        end
      end

      raise ArgumentError, "Binding mismatch: #{args.size} for #{replacements}" if !vars.empty? || mismatch

      sql
    end
  end
end
