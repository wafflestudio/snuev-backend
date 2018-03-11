class V1::DepartmentsController < V1::BaseController
  skip_before_action :authorize_request

  def index
    @departments = Department.all
    render jsonapi: @departments
  end
end
