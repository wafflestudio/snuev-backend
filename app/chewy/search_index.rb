class SearchIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      name: {
        tokenizer: 'standard',
        filter: ["lowercase"]
      }
    }
  }

  define_type Course do
    field :name, analyzer: 'name'
  end

  define_type Lecture.includes(:course, :professor) do
    field :course do
      field :name, analyzer: 'name'
    end
    field :professor do
      field :name, analyzer: 'name'
    end
  end
end
