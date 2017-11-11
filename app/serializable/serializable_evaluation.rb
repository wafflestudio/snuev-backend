class SerializableEvaluation < JSONAPI::Serializable::Resource
  type 'evaluations'
  attribute :comment
  attribute :score
  attribute :easiness
  attribute :grading
  attribute :created_at
  attribute :updated_at

  attribute :can_update do
    @current_ability.can? :update, @object
  end

  attribute :can_destroy do
    @current_ability.can? :destroy, @object
  end
end
