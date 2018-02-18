class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.confirmed?
      can [:read, :create], Evaluation
    end
    can [:update, :destroy], Evaluation, user_id: user.id

    can [:create], Bookmark
    can [:destroy], Bookmark, user_id: user.id
  end
end
