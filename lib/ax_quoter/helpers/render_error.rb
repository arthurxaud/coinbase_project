module AxQuoter
  module Helpers
    class RenderError
      def self.json(error, status, message)
        {
          status: status,
          error: error,
          message: message
        }.as_json
      end
    end
  end
end
