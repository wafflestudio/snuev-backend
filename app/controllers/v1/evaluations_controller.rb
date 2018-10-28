class V1::EvaluationsController < V1::BaseController
  before_action :find_lecture, except: :latest
  before_action :find_evaluation, only: [:update, :destroy]
  skip_before_action :authorize_request, only: [:latest, :most_liked]

  def index
    authorize! :read, Evaluation
    @evaluations = @lecture.evaluations.decorated(current_user).includes(:semester).page(params[:page])
    render jsonapi: @evaluations, include: [:semester]
  end

  def latest
    @evaluations = Evaluation.decorated(current_user).order(id: :desc).includes(:semester, lecture: :course, lecture_session: :department).page(params[:page])
    render jsonapi: @evaluations, include: [:semester, lecture: :course, lecture_session: :department]
  end

  def most_liked
    @evaluations = Evaluation
                   .decorated(current_user)
                   .order(upvotes_count: :desc)
                   .where('evaluations.created_at > ?', Date.today.ago(3.months))
                   .includes(:semester, lecture: :course, lecture_session: :department).page(params[:page])
    render jsonapi: @evaluations, include: [:semester, lecture: :course, lecture_session: :department]
  end

  def mine
    authorize! :read, Evaluation
    @evaluations = if @lecture
                     @lecture.evaluations.where(user: current_user)
                   else
                     current_user.evaluations
                   end
    @evaluations = @evaluations.decorated(current_user).includes(:semester, lecture: { course: :department }).page(params[:page])

    render jsonapi: @evaluations, include: [:lecture, :semester]
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
    @lecture = Lecture.find(params[:lecture_id]) if params[:lecture_id]
  end

  def find_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def evaluation_params
    params.require(:evaluation).permit(:comment, :score, :easiness, :grading, :semester_id)
  end
end
