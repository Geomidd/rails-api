class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  AuthorizationError = Class.new(StandardError)

  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
    "ActiveRecord::RecordInvalid" => "JsonapiErrorsHandler::Errors::Invalid",
    "ApplicationController::AuthorizationError" => "JsonapiErrorsHandler::Errors::Forbidden",
  })
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
  rescue_from ActiveRecord::RecordInvalid, with: lambda { |e| handle_validation_error(e) }
  rescue_from UserAuthenticator::Standard::AuthenticationError, with: lambda { authentication_standard_error }
  rescue_from UserAuthenticator::Oauth::AuthenticationError, with: lambda { authentication_oauth_error }

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

  def authentication_oauth_error
    error = {
      :status => 401,
      :source => { :pointer => "code" },
      :title => "Authentication code is invalid",
      :detail => "You must provide valid code in order to exchange it for token."
    }
    render json: { :errors => [error] }, status: 401
  end

  def authentication_standard_error
    error = {
      :status => 401,
      :source => { :pointer => "/data/attributes/password" },
      :title => "Invalid login or password",
      :detail => "You must provide valid credentials in order to exchange them for token."
    }
    render json: { :errors => [error] }, status: 401
  end
end
