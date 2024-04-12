module DataObjects
  module Spec
    module PendingHelpers
      def pending_if(message, boolean, &)
        if boolean
          pending(message, &)
        else
          yield
        end
      end
    end
  end
end
