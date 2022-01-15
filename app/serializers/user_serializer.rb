class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :login, :name, :avatar_url, :url
end