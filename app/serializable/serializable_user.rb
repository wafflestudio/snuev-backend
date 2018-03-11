class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attribute :nickname
  attribute :username
  attribute :created_at
  attribute :updated_at
  attribute :email

  attribute :is_confirmed do
    @object.confirmed?
  end

  belongs_to :department
end
