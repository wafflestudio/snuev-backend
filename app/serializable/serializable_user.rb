class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attribute :nickname
  attribute :username
  attribute :created_at
  attribute :updated_at
  attribute :email
end
