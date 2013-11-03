# -*- encoding : utf-8 -*-

class User::RegistrationsController < Devise::RegistrationsController
  #include InvitationsHelper
  #include InternationalizationHelper

  #before_filter :require_no_authentication, :only => [:new, :create, :cancel]
  before_filter :authenticate_scope!, :only => [:update]

  ## Update user profile
  ## If Successul --> reset cache user
  def update
    @user = User.find(current_user.id)

    ## delete password if have to update without password
    #params.delete("password")
    #params.delete("password_confirmation")

    ## Update other fields
    if @user.update_attributes(params)

      sign_in @user, :bypass => true
      respond_to do |format|
        # prepare json data
        resource_json = @user.as_json
        arr_include_fields = %w(_id name avatar avatar_thumb cover address area_code phone email google_id facebook_id twitter_id sex birthday note language gcm_token apn_token city country)
        resource_json = resource_json.keep_if { |key, value| arr_include_fields.include? key }

        format.html { render :template => '/users/show' }

        format.json { render :json => {"user" => resource_json}, :status => :created }
      end
    else  ## error when save
      clean_up_passwords @user
      respond_to do |format|
        format.html { render :action => "edit" }
        format.json { render json: @user.errors.full_messages, :status => :bad_request }
      end
    end
  end

end
