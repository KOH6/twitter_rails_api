# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :messages, dependent: :destroy

  def self.search_existing_group(user_id:, other_id:)
    existing_group = nil
    groups = GroupMember.where(user_id:).map(&:group)
    groups.each do |group|
      if group.group_members.find_by(user_id: other_id)
        existing_group = group
        break
      end
    end
    existing_group
  end
end
