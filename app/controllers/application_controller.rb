class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_json_request

  def ensure_json_request
    return if json_request?
    render json: { error: 'not acceptable', status: 406,
                   message: 'format not accepable' }.to_json, status: 406
  end

  protected

  def json_request?
    request.format.json?
  end
end
