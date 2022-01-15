class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
    'UserAuthenticator::AuthenticationError' => 'JsonapiErrorsHandler::Errors::Unauthorized',
    "ActiveRecord::RecordInvalid" => "JsonapiErrorsHandler::Errors::Invalid",
  })
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
  rescue_from ActiveRecord::RecordInvalid, with: lambda { |e| handle_validation_error(e) }

  before_action :authorize!

  private

  def authorize!
    raise Errors::Forbidden unless current_user
  end

  def access_token
    provided_token = request.authorization&.gsub(/\ABearer\s/, "")
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user
  end

  def handle_validation_error(error)
    error_model = error.try(:model) || error.try(:record)
    errors = error_model.errors.reduce([]) do |r, e|
      r << {
        source: { pointer: "/data/attributes/#{e.attribute}" },
        detail: e.message,
        status: 422,
        title: "Invalid request"
      }
    end
    render json: { errors: errors }, status: 422
  end
end
