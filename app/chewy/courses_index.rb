class CoursesIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      name: {
        tokenizer: 'standard',
        filter: ['lowercase']
      }
    }
  }

  define_type Course do
    field :name, analyzer: 'name'
    field :tokenized_name, type: 'keyword'
  end
end
