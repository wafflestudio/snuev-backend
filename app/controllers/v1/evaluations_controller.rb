class V1::EvaluationsController < V1::BaseController
  before_action :find_lecture, except: :mine
  before_action :find_evaluation, only: [:update, :destroy]

  def index
    authorize! :read, Evaluation
    @evaluations = @lecture.evaluations.includes(:semester).page(params[:page])
    render jsonapi: @evaluations, include: [:semester]
  end

  def mine
    authorize! :read, Evaluation
    @evaluations = current_user.evaluations.includes(:semester).page(params[:page])
    render jsonapi: @evaluations, include: [:semester]
  end

  def create
    authorize! :create, Evaluation
    @evaluation = Evaluation.new(evaluation_params.merge(user: current_user, lecture: @lecture))
    if @evaluation.save
      render jsonapi: @evaluation, include: [:semester]
    else
      render jsonapi_errors: @evaluation.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @evaluation
    @evaluation.update!(evaluation_params)
    render jsonapi: @evaluation, include: [:semester]
  end

  def destroy
    authorize! :destroy, @evaluation
    @evaluation.destroy
    render jsonapi: @evaluation, include: [:semester]
  end

  private

  def find_lecture
    @lecture = Lecture.find(params[:lecture_id])
  end

  def find_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def evaluation_params
    params.require(:evaluation).permit(:comment, :score, :easiness, :grading, :semester_id)
  end
end
