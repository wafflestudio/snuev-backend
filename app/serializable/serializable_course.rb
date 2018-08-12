class SerializableCourse < JSONAPI::Serializable::Resource
  type 'courses'
  attribute :id
  attribute :name
  attribute :category
  attribute :target_grade do
    I18n.t(:"target_grade.#{@object.target_grade || 0}", scope: [:activerecord, :attributes, :course])
  end
  attribute :total_unit
  attribute :lecture_unit
  attribute :lab_unit
  attribute :created_at
  attribute :updated_at
  belongs_to :department
  has_many :lectures
end
