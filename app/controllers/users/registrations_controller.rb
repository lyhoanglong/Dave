# -*- encoding : utf-8 -*-

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json, :html

  #include InvitationsHelper
  #include InternationalizationHelper

  #before_filter :require_no_authentication, :only => [:new, :create, :cancel]
  before_filter :authenticate_scope!, :only => [:update]

  def create
    build_resource(sign_up_params)

    if resource.save
      user_info = resource.as_json.keep_if{|key, value| (%w(_id first_name last_name email type authentication_token).include? key)}
      respond_to do |format|
        format.json {render :json => {:user => user_info}, status: :created}
      end
    else
      respond_to do |format|
        format.json {render :json => resource.errors.full_messages, status: :bad_request}
      end
    end
  end

  ## Update user profile
  ## If Successul --> reset cache user
  def update
    @user = current_user

    ## Update other fields
    if @user.update_attributes(params)
      sign_in @user, :bypass => true
      respond_to do |format|
        format.json { render :json => {"user" => @user.as_json}, :status => :created }
      end
    else  ## error when save
      respond_to do |format|
        format.json { render json: @user.errors.full_messages, :status => :bad_request }
      end
    end
  end

end
