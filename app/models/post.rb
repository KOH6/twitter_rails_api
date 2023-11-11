class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :content, presence: true, length: { maximum: 140 }
end
