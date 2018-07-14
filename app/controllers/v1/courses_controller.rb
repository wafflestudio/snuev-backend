class V1::CoursesController < V1::BaseController
  skip_before_action :authorize_request

  def index
    @courses = Course.includes(:department).page(params[:page])
    render jsonapi: @courses,
           include: [:department]
  end

  def search
    # TODO 'query'
    # 1. empty string or too short query
    # 2. unknown character

    query = params[:q].to_s.downcase
    page = params[:page].to_i || 0

    @courses = CoursesIndex::Course
               .load(scope: -> { includes(:department) })
               .query(match: { name: query })
               .page(page)
               .objects

    render jsonapi: @courses,
           include: [:department]
  end
end
