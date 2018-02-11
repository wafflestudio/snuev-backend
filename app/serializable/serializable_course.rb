class SerializableCourse < JSONAPI::Serializable::Resource
  type 'courses'
  attribute :name
  attribute :category
  attribute :target_grade
  attribute :total_unit
  attribute :lecture_unit
  attribute :lab_unit
  attribute :created_at
  attribute :updated_at
  belongs_to :department
  has_many :lectures
end
