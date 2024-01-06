# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController

      def show
        user = User.find_by(user_name: params[:user_name])

        if user
          data = user.posts_and_image_merged_json
          render json: data
        else
          # 該当idのuserがない場合、status_code:404で返す
          render json: { message: 'ユーザが見つかりませんでした。' }, status: :not_found
        end
      end
    end
  end
end
