class V1::EvaluationsController < V1::BaseController
  before_action :find_lecture
  before_action :find_evaluation, only: [:update, :destroy]

  def index
    authorize! :read, Evaluation
    @evaluations = @lecture.evaluations.page params[:page]
    render jsonapi: @evaluations
  end

  def create
    @evaluation = Evaluation.create!(evaluation_params.merge(user: current_user, lecture: @lecture))
    render jsonapi: @evaluation
  end

  def update
    authorize! :update, @evaluation
    @evaluation.update!(evaluation_params)
    render jsonapi: @evaluation
  end

  def destroy
    authorize! :destroy, @evaluation
    @evaluation.destroy
    render jsonapi: @evaluation
  end

  private

  def find_lecture
    @lecture = Lecture.find(params[:lecture_id])
  end

  def find_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def evaluation_params
    params.require(:evaluation).permit(:comment, :score, :easiness, :grading)
  end
end
