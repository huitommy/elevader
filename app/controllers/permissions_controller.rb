class PermissionsController < ApplicationController
  def require_permission
    @item = controller_name.classify.constantize.find(params[:id])
    @user = @item.user
    session[:current_page] ||= request.referer
    unless current_user == @user || current_admin
      flash[:notice] = 'You do not have permission to change this'
      redirect_to session.delete(:current_page)
    end
  end
end
