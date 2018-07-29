class LecturesIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      ngram: {
        tokenizer: 'ngram'
      }
    }
  }

  define_type Lecture.includes(:course, :professor) do
    field :course do
      field :name, analyzer: 'ngram'
      field :code, type: 'keyword'
      field :target_grade, type: 'integer'
      field :total_unit, type: 'integer'
      field :lecture_unit, type: 'integer'
      field :lab_unit, type: 'integer'
      field :department_id, type: 'integer'
      field :category, type: 'integer'
    end
    field :professor do
      field :name, analyzer: 'ngram'
    end
    field :score, type: 'float'
    field :easiness, type: 'float'
    field :grading, type: 'float'
    field :evaluations_count, type: 'integer'
    field :quota, type: 'integer'
  end
end
