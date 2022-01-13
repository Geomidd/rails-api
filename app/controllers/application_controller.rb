class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
    'UserAuthenticator::AuthenticationError' => 'JsonapiErrorsHandler::Errors::Unauthorized'
  })
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

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
end
