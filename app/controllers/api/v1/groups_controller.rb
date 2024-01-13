class Api::V1::GroupsController < ApplicationController
  def index
    p 'call index'
    render json: { data:  'call index' }
  end

  def create
    p 'call create'
    render json: { data:  'call create' }
  end
end
