class V1::BookmarksController < V1::BaseController
  before_action :find_lecture

  def create
    authorize! :create, Bookmark
    current_user.bookmarks.find_or_create_by!(lecture: @lecture)
    render jsonapi: nil, status: :created
  end

  def destroy
    if (bookmark = current_user.bookmarks.find_by(lecture: @lecture))
      authorize! :destroy, bookmark
      bookmark.destroy
    end
    render jsonapi: nil, status: :accepted
  end

  private

  def find_lecture
    @lecture = Lecture.find(params[:lecture_id])
  end
end
