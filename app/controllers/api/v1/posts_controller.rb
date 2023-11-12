module Api
  module V1
    class PostsController < ApplicationController
      def create
        post = Post.new(post_params)
        post.user = current_api_v1_user
        if post.save!
          render json: {data: post}
        else
          # status_code:422で返す
          render json: {message: "ポスト投稿に失敗しました。"}, status: :unprocessable_entity
        end
      end

      def attach_image
        images = params.require(:images)
        # 画像がない状態で呼ばれた場合、status_code:204で返す
        render status: :no_content images.length == 0

        post = Post.find(params[:post_id])
        # 添付先の投稿が見つからない場合、status_code:422で返す
        render json: {message: "画像添付先の投稿が見つかりませんでした。"}, status: :unprocessable_entity unless post

        blobs = []
        images.each do |image|
          blob =
          ActiveStorage::Blob.create_and_upload!(
            io: image,
            filename: image.original_filename,
            content_type: image.content_type,
          )

          post.images.attach(blob.signed_id)
          blobs.push(blob)
        end

        if blobs.length >= 0
          render json: {data: blobs}
        else
          # status_code:422で返す
          render json: {message: "画像登録に失敗しました。"}, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.require(:post).permit(:content)
      end
    end
  end
end

