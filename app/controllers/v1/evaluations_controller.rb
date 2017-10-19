class V1::EvaluationsController < V1::BaseController
  before_action :find_lecture

  def index
    @evaluations = @lecture.evaluations
  end

  private

  def find_lecture
    @lecture = Lecture.find(params[:lecture_id])
  end
end
