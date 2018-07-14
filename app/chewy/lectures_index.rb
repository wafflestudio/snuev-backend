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
    end
    field :professor do
      field :name, analyzer: 'ngram'
    end
  end
end
