class V1::LecturesController < V1::BaseController
  def index
    # TODO: Search lectures instead of listing.
    @lectures = Lecture.includes(:course, :professor).page params[:page]
    render jsonapi: @lectures,
           include: [:course, :professor]
  end

  def show
    @lecture = Lecture.find(params[:id])
    render jsonapi: @lecture,
           include: [:course, :professor]
  end
end
