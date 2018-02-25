class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.confirmed?
      can [:read, :create], Evaluation
      can [:create], Vote
      can [:destroy], Vote, user_id: user.id
    end
    can [:update, :destroy], Evaluation, user_id: user.id
  end
end
