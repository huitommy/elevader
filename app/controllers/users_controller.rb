class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params['id'])
    @user.delete
    flash[:notice] = "User was deleted"
    redirect_to users_path
  end
end

