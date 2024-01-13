# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      def index
        Rails.logger.debug 'call index'
        render json: { data: 'call index' }
      end

      def create
        Rails.logger.debug 'call create'
        render json: { data: 'call create' }
      end
    end
  end
end
