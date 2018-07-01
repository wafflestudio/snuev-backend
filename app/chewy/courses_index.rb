class CoursesIndex < Chewy::Index
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

  define_type Course do
    field :name, analyzer: 'korean'
  end
end
