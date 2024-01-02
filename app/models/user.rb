# frozen_string_literal: true

class User < ApplicationRecord
  # url_forのメソッドを使うためinclude
  include Rails.application.routes.url_helpers

  before_save :attach_dummy_image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy
  has_one_attached :profile_image
  has_one_attached :header_image

  with_options presence: true do
    validates :phone
    validates :birthdate
    validates :name, uniqueness: true
  end

  # 画像ファイルのパスを内包したjsonを返す
  def image_merged_json
    profile_image_path = profile_image.attached? ? url_for(profile_image) : ""
    header_image_path = header_image.attached? ? url_for(header_image) : ""
    self.as_json.merge(profile_image_path:, header_image_path:)
  end

  private

  def attach_dummy_image
    unless profile_image.attached?
      profile_image.attach(io: File.open(Rails.root.join('app/assets/images/dummy_image.jpg')),
                   filename: 'dummy_image.jpg')
    end

    return if header_image.attached?

    header_image.attach(io: File.open(Rails.root.join('app/assets/images/dummy_header_image.jpg')),
                        filename: 'dummy_header_image.jpg')
  end
end
