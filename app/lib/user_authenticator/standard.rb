class UserAuthenticator::Standard < UserAuthenticator
  AuthenticationError = Class.new(StandardError)

  attr_reader :user

  def initialize(login, password)
    @login = login
    @password = password
  end

  def perform
    raise AuthenticationError if login.blank? || password.blank? 

    user = User.find_by(login: login) # Rather than calling exists? and find_by, reduce queries by finding and checking against nil
    raise AuthenticationError if user.nil?
    raise AuthenticationError unless user.password == password

    @user = user
  end

  private
  attr_reader :login, :password
end