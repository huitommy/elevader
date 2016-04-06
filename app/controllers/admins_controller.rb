class AdminsController < ApplicationController


  def index
    @admins = Admin.all
  end

  def create
    @user = User.find(params[:user_id])
    @admin = Admin.new(
      username: @user.username,
      email: @user.email,
      password: 'placeholder',
      encrypted_password: @user.encrypted_password 
    )
    if @admin.save
      flash[:notice] = "#{@admin.username} is now an admin"
    else 
      unless Admin.find_by(email: @admin.email).nil?
        flash[:notice] = "#{admin.username} is already admin"
      end
    end
    redirect_to admins_path
  end

  def destroy
    @admin = Admin.find(params['id'])
    @admin.delete
    flash[:notice] = "Admin was deleted"
    redirect_to admins_path
  end
end