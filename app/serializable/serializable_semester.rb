class SerializableSemester < JSONAPI::Serializable::Resource
  type 'semesters'
  attribute :year
  attribute :season
end
