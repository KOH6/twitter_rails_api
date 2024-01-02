# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController

      def show
        user = User.find_by(id: params[:id])

        if user
          data = merge_posts_and_image_path(user)
          render json: data
        else
          # 該当idのuserがない場合、status_code:404で返す
          render json: { message: 'ユーザが見つかりませんでした。' }, status: :not_found
        end
      end

      private

      def merge_posts_and_image_path(user)
        profile_image_path = user.profile_image.attached? ? url_for(user.profile_image) : ""
        header_image_path = user.header_image.attached? ? url_for(user.header_image) : ""
        tweets = user.posts.map { |post|
          image_paths = post.images.map { |image| url_for(image) }
          post.as_json.merge(image_paths:)
        }
        user.as_json.merge(profile_image_path:, header_image_path:, tweets:)
      end
    end
  end
end
