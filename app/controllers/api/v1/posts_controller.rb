module Api
  module V1
    class PostsController < ApplicationController

      def create
        post = Post.new(post_params)
        post.user = current_api_v1_user
        # post.user = User.first
        if post.save
          render json: {data: post}
        else
          #422番で返す
          render json: {message: "error"}, status: :unprocessable_entity
        end
      end

      def create_image
        render json: {message: "create_image_success"}
      end

      private

      def post_params
        params.permit(:content, :images)
      end
    end
  end
end

