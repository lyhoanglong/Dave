class UsersController < ApplicationController
  respond_to :json, :html

  before_filter :authenticate_user!

  def index
    if current_user.type == User::SYSTEM_ADMINISTRATOR
      @users = User.slice[HomeHelper::CommonHelper.new.calculate_skip_number_in_pagination(params[:page], TOTAL_USERS_PER_PAGE), TOTAL_USERS_PER_PAGE]
      respond_to do |format|
        format.json {render :json => @users, :status => :ok}
      end
    else
      respond_to do |format|
        format.json {render :json => {:error => 'permission denied'}, :status => :forbidden}
      end
    end
  end

  def show
    @user = User.where(id: params[:id]).first

    if not @user
      respond_to do |format|
        format.json {render :json => {:error => 'user not found'}, :status => :bad_request}
      end

      return
    end

    respond_to do |format|
      ## view by admin or current user
      if @user.id == current_user.id or current_user.type == User::SYSTEM_ADMINISTRATOR
        format.json {render :json => @user, :status => :ok}
      else
        ## other user view
        user_info = @user.as_json.keep_if{|key, value| User::BASIC_USER_FIELDS.include? key}
        format.json {render :json => user_info, :status => :ok}
      end
    end

  end

  ## put users/:id/approve.json
  def approve
    if current_user.type != User::SYSTEM_ADMINISTRATOR
      respond_to do |format|
        format.json {render :json => {:error => 'permission denied'}, :status => :forbidden}
      end
      return
    end

    @user = User.where(id: params[:id]).first

    if not @user
      respond_to do |format|
        format.json {render :json => {:error => 'user not found'}, :status => :bad_request}
      end
      return
    end

    respond_to do |format|
      @user.update_attributes(approval_status: 'approved')
      format.json {render :json => @user, :status => :ok}
    end
  end

end
