class AddVotesCountsToEvaluations < ActiveRecord::Migration[5.1]
  def change
    add_column :evaluations, :upvotes_count, :integer, default: 0
    add_column :evaluations, :downvotes_count, :integer, default: 0
  end
end
