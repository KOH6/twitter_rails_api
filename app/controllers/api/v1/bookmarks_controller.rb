# frozen_string_literal: true

module Api
  module V1
    class BookmarksController < ApplicationController
      def index
        bookmarks = User.first.bookmarking_posts.map(&:merge_user_and_image_as_json)
        render json: bookmarks
      end

      def create
        bookmark = User.first.bookmarks.create(post_id: params[:tweet_id])
        render json: bookmark
      end

      def destroy
        bookmark = User.first.bookmarks.find_by(post_id: params[:tweet_id])
        bookmark.destroy
        render json: bookmark
      end
    end
  end
end
