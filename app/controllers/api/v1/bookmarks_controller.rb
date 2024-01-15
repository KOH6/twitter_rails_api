class Api::V1::BookmarksController < ApplicationController
  def index
    bookmarks = User.first.bookmarking_posts
    render json: { data: bookmarks }
  end

  def create
    bookmark = User.first.bookmarks.create(post_id: params[:tweet_id])
    render json: { data: bookmark }
  end

  def destroy
    bookmark = User.first.bookmarks.find_by(post_id: params[:tweet_id])
    bookmark.destroy
    render json: { data: bookmark }
  end
end
