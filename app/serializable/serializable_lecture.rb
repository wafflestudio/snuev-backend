class SerializableLecture < JSONAPI::Serializable::Resource
  type 'lectures'
  attribute :score
  attribute :easiness
  attribute :grading
  attribute :created_at
  attribute :updated_at
  attribute :name
  has_one :course
  has_one :professor
end
