class V1::LecturesController < V1::BaseController
  def show
    @lecture = Lecture.find(params[:id])
  end
end
