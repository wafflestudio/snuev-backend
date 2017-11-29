class LecturesIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      name: {
        tokenizer: 'standard',
        filter: ["lowercase"]
      }
    }
  }

  define_type Lecture.includes(:course, :professor) do
    field :course do
      field :name, analyzer: 'name'
    end
    field :professor do
      field :name, analyzer: 'name'
    end
  end
end
