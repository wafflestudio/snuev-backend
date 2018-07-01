class LecturesIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      korean: {
        type: 'custom',
        tokenizer: ['seunjeon_default_tokenizer']
      }
    },
    tokenizer: {
      seunjeon_default_tokenizer: {
        type: 'seunjeon_tokenizer',
      }
    }
  }

  define_type Lecture.includes(:course, :professor) do
    field :course do
      field :name, analyzer: 'korean'
    end
    field :professor do
      field :name, analyzer: 'korean'
    end
  end
end
