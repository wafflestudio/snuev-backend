class SerializableLecture < JSONAPI::Serializable::Resource
  type 'lectures'
  id { @object.friendly_id }
  attribute :score
  attribute :easiness
  attribute :grading
  attribute :created_at
  attribute :updated_at
  attribute :name
  attribute :evaluations_count
  attribute :evaluated
  attribute :bookmarked
  has_one :course
  has_one :professor
  has_many :semesters
end
