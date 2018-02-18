class SerializableDepartment < JSONAPI::Serializable::Resource
  type 'departments'
  attribute :name
end
