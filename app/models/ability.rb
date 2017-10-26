class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:read, :create], Evaluation
    can [:update, :destroy], Evaluation, user_id: user.id
  end
end
