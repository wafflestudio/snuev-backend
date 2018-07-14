class SerializableLecture < JSONAPI::Serializable::Resource
  type 'lectures'
  attribute :id
  attribute :score
  attribute :easiness
  attribute :grading
  attribute :created_at
  attribute :updated_at
  attribute :name
  attribute :evaluations_count
  attribute :evaluated
  attribute :bookmarked
  attribute :view_count do
    @object.impressions_count
  end
  has_one :course
  has_one :professor
  has_many :semesters
end
