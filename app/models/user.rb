# frozen_string_literal: true

class User < ApplicationRecord
  before_save :attach_dummy_image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :profile_image
  has_one_attached :header_image

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :reposts, dependent: :destroy
  has_many :reposting_posts, through: :reposts, source: :post

  has_many :likes, dependent: :destroy
  has_many :liking_posts, through: :likes, source: :post

  with_options presence: true do
    validates :phone
    validates :birthdate
    validates :name, length: { maximum: 50 }
    validates :user_name, uniqueness: true
  end

  validates :introduction, length: { maximum: 160 }
  validates :place, length: { maximum: 30 }
  validates :website, length: { maximum: 100 }

  # プロフィール画像ファイルのパスを内包したjsonを返す
  def merge_image_as_json
    profile_image_path = profile_image.attached? ? url_for(profile_image) : ''
    header_image_path = header_image.attached? ? url_for(header_image) : ''
    as_json.merge(profile_image_path:, header_image_path:)
  end

  # 子レコードとプロフィール画像ファイルのパスを内包したjsonを返す
  def merge_children_and_image_as_json
    tweets = posts.order(created_at: :desc).map(&:merge_user_and_image_as_json)
    comments = self.comments.order(created_at: :desc).map(&:merge_user_as_json)
    retweets = reposting_posts.order(created_at: :desc).map(&:merge_user_and_image_as_json)
    likes = liking_posts.order(created_at: :desc).map(&:merge_user_and_image_as_json)
    merge_image_as_json.as_json.merge(tweets:, comments:, retweets:, likes:)
  end

  private

  def attach_dummy_image
    unless profile_image.attached?
      profile_image.attach(io: Rails.root.join('app/assets/images/dummy_image.jpg').open,
                           filename: 'dummy_image.jpg')
    end

    return if header_image.attached?

    header_image.attach(io: Rails.root.join('app/assets/images/dummy_header_image.jpg').open,
                        filename: 'dummy_header_image.jpg')
  end
end
