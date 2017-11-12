class V1::CoursesController < V1::BaseController
  def index
   	@courses = SearchIndex::Course.query(match: {name: params[:q]}).objects
    render jsonapi: @courses
  end
end
