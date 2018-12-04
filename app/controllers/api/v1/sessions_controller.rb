class Api::V1::SessionsController < ApplicationController

  def facebook
    response = User.validate_facebook_token(params[:facebook_token])
    if response
      response['token'] = params[:facebook_token]
      user = current_user || User.find_by(email: response['email'])
      provider = Provider.where(name: 'facebook').first
      authentication = provider.authentications.where(uid: response['id']).first

      if authentication
        sign_in authentication.user
        user.generate_authentication_token!
        user.save
        render json: user, status: 200, location: [:api, user]
      elsif user
        Authentication.create_from_koala(response, user, provider)
        sign_in user
        user.generate_authentication_token!
        user.save
        render json: user, status: 200, location: [:api, user]
      else
        user = User.create_from_social(response)
        if user
          user.generate_authentication_token!
          user.save
          Authentication.create_from_koala(response, user, provider)
          render json: user, status: 200, location: [:api, user]
        else
          render json: { errors: "Invalid user"}, status: 422
        end
      end
    else
      render json: { errors: "Invalid facebook token" }, status: 422
    end
  end

  def instagram
    response = User.validate_instagram_token(params[:instagram_token])
    if response
      provider = Provider.where(name: 'instagram').first
      authentication = provider.authentications.where(uid: response.id).first
      if authentication
        sign_in authentication.user
        authentication.user.generate_authentication_token!
        authentication.user.save
        render json: authentication.user, status: 200, location: [:api, authentication.user]
      elsif current_user
        Authentication.create_from_instagram(params[:google_token], response, current_user, provider)
        sign_in current_user
        current_user.generate_authentication_token!
        current_user.save
        render json: current_user, status: 200, location: [:api, current_user]
      else
        user = User.create_from_social(response)
        if user
          user.generate_authentication_token!
          user.save
          Authentication.create_from_instagram(params[:google_token], response, user, provider)
          render json: user, status: 200, location: [:api, user]
        else
          render json: { errors: "Invalid user"}, status: 422
        end
      end
    else
      render json: { errors: "Invalid instagram token" }, status: 422
    end
  end

  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    user = User.find_by(email: user_email)

    if user && user.valid_password?(user_password)
      sign_in user
      user.generate_authentication_token!
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid username or password" }, status: 422
    end
  end

  def recover
    user = User.find_by('lower(email) = ?', params[:email].downcase) rescue nil
    if user
      password = Devise.friendly_token.first(12)

      user.update_attributes(password: password, password_confirmation: password)
      UserMailer.password_reset(user, password).deliver_now
      render json: { message: "Password email resent"}
    else
      render json: { errors: "User not found"}, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    if user
      user.generate_authentication_token!
      user.save
      head 204
    else
      head 404
    end
  end

  def environment
      render json: {
        facebook_app_id: Rails.application.credentials.facebook_app_id,
        facebook_redirect_url: Rails.application.credentials.facebook_redirect_url,
        insta_client_id: Rails.application.credentials.instagram_client_id,
        insta_redirect_url: Rails.application.credentials.instagram_redirect_url,
        cloud_name: Rails.application.credentials.cloudinary_name,
        cloud_preset: Rails.application.credentials.cloudinary_preset
      }
  end
end
