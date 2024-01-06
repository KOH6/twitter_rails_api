# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController

      def show
        user = User.find_by(user_name: params[:user_name])

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
        tweets = user.posts.map { |post|
          image_paths = post.images.map { |image| url_for(image) }
          post.as_json.merge(image_paths:)
        }
        user.image_merged_json.as_json.merge(tweets:)
      end
    end
  end
end
