module RenderErrorHelper
  def json(error, status, message)
    {
      status: status,
      error: error,
      message: message
    }.as_json
  end
end
