class Api::V1::NotificationsController < ApplicationController
  def index
    notifications = current_api_v1_user.notifications.order(created_at: :desc).map{|record|
      sender = record.sender.merge_image_as_json
      record.as_json.merge(target: record.target, sender:)
    }
    render json: notifications
  end
end
