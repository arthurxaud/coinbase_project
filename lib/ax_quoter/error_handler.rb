module AxQuoter
  module ErrorHandler
    def self.included(klass)
      klass.class_eval do
        rescue_from StandardError do |e|
          respond(:standard_error, 500, '')
        end
        rescue_from AxQuoter::AmountExceededError do |e|
          respond(:amount_exceeded_error, 500, e.to_s)
        end
        rescue_from ActiveRecord::RecordNotFound do |e|
          respond(:record_not_found, 404, e.to_s)
        end
        rescue_from ActionController::ParameterMissing do |e|
          respond(:parameter_missing, 400, e.to_s)
        end
      end
    end

    private

    def respond(error, status, message)
      json = Helpers::RenderError.json(error, status, message)
      render json: json, status: status
    end
  end
end
