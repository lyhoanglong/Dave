
class Users::PasswordsController < ApplicationController

  respond_to :json, :html

  ## put users/password
  def update
    user = User.where(:id => params[:user_id]).first
    respond_to do |format|
      if not user
        format.json{render :json => {:error => 'user not found'}, :status => :bad_request}
      elsif user.encrypted_password and user.encrypted_password != ''
        format.json{render :json => {:error => 'permission denied'}, :status => :forbidden}
      else
        if params[:password] and params[:password_confirmation] and params[:password] == params[:password_confirmation]
          user.password = params[:password]
          user.password_confirmation = params[:password_confirmation]
          user.is_verified_email = 'yes'

          user.save
          sign_in(user)

          user_info = user.as_json.keep_if{|key, value| (%w(_id first_name last_name email type authentication_token).include? key)}

          format.json{render :json => {:user => user_info, :auth_token => user.authentication_token}, :status => :created}
        else
          format.json{render :json => {:error => 'password not match'}, :status => :bad_request}
        end
      end
    end
  end

end
