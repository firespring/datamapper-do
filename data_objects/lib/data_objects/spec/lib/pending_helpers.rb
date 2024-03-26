module DataObjects
  module Spec
    module PendingHelpers
      def pending_if(message, boolean, &block)
        if boolean
          pending(message, &block)
        else
          yield
        end
      end
    end
  end
end
