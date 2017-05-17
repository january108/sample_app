class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  
  def create
      p "micropost create"
  end
  
  def destroy
      p "micropost destroy"
  end
end
