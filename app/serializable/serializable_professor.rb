class SerializableProfessor < JSONAPI::Serializable::Resource
  type 'professors'
  id { @object.friendly_id }
  attribute :name
  attribute :created_at
  attribute :updated_at
end
