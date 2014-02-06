class ProfilesController < ApplicationController
  before_filter :require_authentication

  def edit
    @user = current_user
    @user.update_column(:prompted_for_details, true)
  end

  def update
    @user = current_user
    @user.update_attributes(profile_params)

    redirect_to session.delete(:return_path).presence || dashboard_path
  end


  protected

  def profile_params
    params.require(:user).permit(:full_name, :email)
  end
end
