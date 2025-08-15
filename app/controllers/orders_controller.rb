# app/controllers/orders_controller.rb

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]
  
  # Feature 3.2.1 - List all past orders
  def index
    @orders = current_user.orders.recent.includes(:order_items, :products)
    @orders = @orders.page(params[:page]).per(10)
  end
  
  def show
    # Order is set in before_action
    @order_items = @order.order_items.includes(:product)
  end
  
  private
  
  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to view your orders."
    end
  end
  
  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Order not found."
  end
end