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
    query = params[:q].to_s.downcase
    page = params[:page].to_i || 0

    @lectures = lectures_query(query, search_params)
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

  def lectures_query(query, params)
    q = LecturesIndex::Lecture.query(match: { 'course.name' => query })
    q = q.filter(terms: { 'course.department_id' => params[:department_ids] }) if params[:department_ids]
    q = q.filter(terms: { 'course.target_grade' => params[:target_grades] }) if params[:target_grades]
    q = q.filter(terms: { 'course.total_unit' => params[:total_units] }) if params[:total_units]
    q = q.filter(terms: { 'course.category' => params[:categories] }) if params[:categories]
    q
  end

  def search_params
    params.permit(department_ids: [], target_grades: [], total_units: [], categories: [])
  end
end
