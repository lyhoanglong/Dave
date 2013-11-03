class UsersController < ApplicationController
  respond_to :json, :html

  before_filter :authenticate_user!

  def index
    @users = User.all
    respond_with(@users)
  end

  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end

end
