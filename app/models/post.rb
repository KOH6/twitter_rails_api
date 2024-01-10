# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :content, presence: true, length: { maximum: 140 }

  def merge_user_and_image_as_json
    image_paths = images.map { |image| url_for(image) }
    user = self.user.merge_image_as_json
    as_json.merge(image_paths:, user:)
  end
end
