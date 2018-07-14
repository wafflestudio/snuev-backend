class V1::LecturesController < V1::BaseController
  skip_before_action :authorize_request, except: :bookmarked

  def index
    @lectures = lecture_scope.page(params[:page])
    render jsonapi: @lectures,
           include: [{ course: [:department] }, :semesters, :professor]
  end

  def most_evaluated
    @lectures = lecture_scope.order(evaluations_count: :desc).page(params[:page])
    render jsonapi: @lectures,
           include: [{ course: [:department] }, :semesters, :professor]
  end

  def top_rated
    @lectures = lecture_scope.where('lectures.evaluations_count >= ?', 10).order(score: :desc).page(params[:page])
    render jsonapi: @lectures,
           include: [{ course: [:department] }, :semesters, :professor]
  end

  def bookmarked
    @lectures = lecture_scope.where(id: current_user.bookmarks.select(:lecture_id)).page(params[:page])
    render jsonapi: @lectures,
           include: [{ course: [:department] }, :semesters, :professor]
  end

  def show
    @lecture = lecture_scope.find(params[:id])
    impressionist(@lecture)
    render jsonapi: @lecture,
           include: [{ course: [:department] }, :semesters, :professor]
  end

  def search
    # TODO 'query'
    # 1. empty string or too short query
    # 2. unknown character

    query = params[:q].to_s.downcase
    page = params[:page].to_i || 0

    @lectures = LecturesIndex::Lecture
                .query(match: { 'course.name' => query })
                .load(scope: lecture_scope)
                .page(page)
                .objects

    render jsonapi: @lectures,
           include: [{ course: [:department] }, :semesters, :professor]
  end

  protected

  def lecture_scope
    Lecture.decorated(current_user).includes(:semesters, :professor, course: :department)
  end
end
