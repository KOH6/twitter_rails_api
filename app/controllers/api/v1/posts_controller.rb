module Api
  module V1
    class PostsController < ApplicationController
      def create
        render json: {message: "create_success"}
      end

      def image_create
        render json: {message: "image_create_success"}
      end
    end
  end
end

