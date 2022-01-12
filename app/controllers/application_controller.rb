class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
    'UserAuthenticator::AuthenticationError' => 'JsonapiErrorsHandler::Errors::Unauthorized'
  })
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
end
