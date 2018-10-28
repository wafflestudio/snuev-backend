class SerializableLectureSession < JSONAPI::Serializable::Resource
  type 'lecture_sessions'
  belongs_to :semester
  belongs_to :department
end
