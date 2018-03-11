class Vote < ApplicationRecord
  belongs_to :user
  validates :votable_id, uniqueness: { scope: :user }

  class Upvote < Vote
    belongs_to :votable, polymorphic: true, counter_cache: :upvotes_count,
               inverse_of: :upvotes, optional: true
  end

  class Downvote < Vote
    belongs_to :votable, polymorphic: true, counter_cache: :downvotes_count,
               inverse_of: :downvotes, optional: true
  end
end
