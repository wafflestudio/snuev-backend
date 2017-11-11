class V1::CoursesController < ApplicationController
#class V1::CoursesController < V1::BaseController
  def index

   	@courses = SearchIndex::Course.query(match: {name: params[:q]}).objects
  end
end
