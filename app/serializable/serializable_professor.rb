class SerializableProfessor < JSONAPI::Serializable::Resource
  type 'professors'
  attribute :id
  attribute :name
  attribute :created_at
  attribute :updated_at
end
