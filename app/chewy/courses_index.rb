class CoursesIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      ngram: {
        tokenizer: 'ngram'
      }
    }
  }

  define_type Course do
    field :name, analyzer: 'ngram'
  end
end
