class V1::VotesController < V1::BaseController
  before_action :find_evaluation

  def create
    authorize! :create, Vote
    if downvote?
      ActiveRecord::Base.transaction do
        @evaluation.upvotes.where(user: current_user).destroy_all
        @evaluation.downvotes.find_or_create_by!(user: current_user)
      end
    else
      ActiveRecord::Base.transaction do
        @evaluation.downvotes.where(user: current_user).destroy_all
        @evaluation.upvotes.find_or_create_by!(user: current_user)
      end
    end
    render jsonapi: nil, status: :created
  end

  def destroy
    ActiveRecord::Base.transaction do
      @evaluation.upvotes.where(user: current_user).destroy_all
      @evaluation.downvotes.where(user: current_user).destroy_all
    end
    render jsonapi: nil, status: :accepted
  end

  protected

  def downvote?
    direction = params.dig(:vote, :direction)
    direction.to_s.in?(%w[-1 f false])
  end

  def find_evaluation
    @evaluation = Evaluation.find params[:evaluation_id]
  end
end
