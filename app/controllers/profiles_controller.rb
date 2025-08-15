# app/controllers/profiles_controller.rb

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = current_user
    @recent_orders = current_user.orders.recent.limit(3).includes(:order_items, :products)
  end
  
  def edit
    @user = current_user
    @provinces = Province.all.order(:name)
  end
  
  def update
    @user = current_user
    @provinces = Province.all.order(:name)
    
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to access your profile."
    end
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, 
                                 :address_line_1, :address_line_2, 
                                 :city, :postal_code, :province_id)
  end
end