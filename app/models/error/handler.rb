module Error
  module Handler
    def self.included(klass)
      klass.class_eval do
        include RenderErrorHelper
        rescue_from StandardError do |_e|
          respond(:standard_error, 500, '')
        end
        rescue_from AmountExceeded do |e|
          respond(:amount_exceeded_error, 500, e.to_s)
        end
        rescue_from ObjectNotFound do |e|
          respond(:object_not_found, 404, e.to_s)
        end
        rescue_from Validation do |e|
          respond(:validation_error, 422, e.to_s)
        end
      end
    end

    private

    def respond(error, status, message)
      render json: json(error, status, message), status: status
    end
  end
end
