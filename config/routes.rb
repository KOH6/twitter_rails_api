# frozen_string_literal: true

Rails.application.routes.draw do
  # 開発環境でブラウザ上でメール受信できるようにする
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'users', controllers: {
        # confirmationはUnsafe redirect toのエラー対応のため、変更を加えた同名自作メソッドを使用
        confirmations: 'api/v1/auth/confirmations'
      }

      # ログイン確認
      namespace :auth do
        resources :sessions, only: %i[index]
      end

      # Postsテーブル
      post 'tweets', to: 'posts#create'
      get 'tweets', to: 'posts#index'
      get 'tweets/:id', to: 'posts#show'
      delete 'tweets/:id', to: 'posts#destroy'

      # Postsテーブルの画像登録
      post 'images', to: 'posts#attach_images'

      # Usersテーブル
      get 'users/:user_name', to: 'users#show'
      post 'profile', to: 'users#update'

      # Commentsテーブル
      post 'comments', to: 'comments#create'
      get 'tweets/:tweet_id/comments', to: 'comments#index'
      delete 'comments/:id', to: 'comments#destroy'
    end
  end
end
