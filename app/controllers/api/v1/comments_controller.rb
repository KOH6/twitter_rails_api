module Api
  module V1
    class CommentsController < ApplicationController
      def create
        comment = current_api_v1_user.comments.build(comment_params)
        if comment.save
          render json: { data: comment }
        else
          # status_code:422で返す
          render json: { message: 'コメントに失敗しました。' }, status: :unprocessable_entity
        end
      end

      private

      def comment_params
        permit_params = params.require(:comment).permit(%i[content post_id])
        permit_params.merge(post_id: permit_params[:post_id])
      end
    end
  end
end