class V1::LecturesController < V1::BaseController
  skip_before_action :authorize_request

  def index
    @lectures = Lecture.includes(:professor, course: :department).page(params[:page])
    render jsonapi: @lectures,
           include: [{ course: [:department] }, :professor]
  end

  def show
    @lecture = Lecture.find(params[:id])
    render jsonapi: @lecture,
           include: [{ course: [:department] }, :professor]
  end

  def search
    # TODO 'query'
    # 1. empty string or too short query
    # 2. unknown character

    query = params[:q].to_s.downcase
    page = params[:page].to_i || 0

    @lectures = LecturesIndex::Lecture
                .load(scope: -> { includes(:professor, course: :department) })
                .query(wildcard: { _all: { value: "*#{query}*" } })
                .page(page)
                .objects

    render jsonapi: @lectures,
           include: [{ course: [:department] }, :professor]
  end
end
