class SessionsController < ApplicationController
  # GET /sign-in
  def new
    redirect_to auth_path
  end

  # GET /sign-out
  def destroy
    session[:user_id] = nil
    @current_user = nil

    redirect_to session[:return_path].presence || root_path
    session.delete(:return_path)
  end

  # GET /auth/:provider/callback?param=a98xh0xeui2sc
  def create
    @user = User.authorize(auth)
    sign_in_as(@user)

    redirect_to session.delete(:return_path).presence || dashboard_path
  end

  protected

  def auth
    Auth.new(request.env['omniauth.auth'])
  end
end
