# app/controllers/checkout_controller.rb

class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty
  before_action :initialize_cart
  
  # Step 1: Show checkout overview
  def show
    calculate_cart_totals
    @provinces = Province.all.order(:name)
  end
  
  # Step 2: Collect/Update address information (Feature 3.1.5)
  def address
    @provinces = Province.all.order(:name)
    @user = current_user
  end
  
  def process_address
    @user = current_user
    @provinces = Province.all.order(:name)
    
    if @user.update(address_params)
      redirect_to review_checkout_index_path
    else
      render :address, status: :unprocessable_entity
    end
  end
  
  # Step 3: Review order before completion
  def review
    unless current_user.address_complete?
      redirect_to address_checkout_index_path, alert: "Please complete your address information."
      return
    end
    
    calculate_cart_totals
    @tax_breakdown = current_user.province.tax_breakdown
  end
  
  # Step 4: Complete the order (Feature 3.1.3 ✯)
  def complete
    unless current_user.address_complete?
      redirect_to address_checkout_index_path, alert: "Please complete your address information."
      return
    end
    
    begin
      ActiveRecord::Base.transaction do
        @order = create_order
        clear_cart
        
        redirect_to order_path(@order), notice: "Order placed successfully! Order number: #{@order.order_number}"
      end
    rescue => e
      Rails.logger.error "Order creation failed: #{e.message}"
      redirect_to review_checkout_index_path, alert: "There was an error processing your order. Please try again."
    end
  end
  
  private
  
  def authenticate_user!
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      redirect_to new_user_session_path, alert: "Please sign in to continue with checkout."
    end
  end
  
  def ensure_cart_not_empty
    if @cart.nil? || @cart.empty?
      redirect_to root_path, alert: "Your cart is empty."
    end
  end
  
  def initialize_cart
    @cart = session[:cart] || {}
  end
  
  def calculate_cart_totals
    @cart_items = []
    @subtotal = 0
    
    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        item_total = product.price * quantity
        @cart_items << {
          product: product,
          quantity: quantity,
          total: item_total
        }
        @subtotal += item_total
      end
    end
    
    # Calculate taxes based on user's province
    if current_user&.province
      tax_rate = current_user.province.total_tax_rate
      @tax_amount = (@subtotal * tax_rate / 100).round(2)
    else
      @tax_amount = 0
    end
    
    @total = @subtotal + @tax_amount
  end
  
  def create_order
    calculate_cart_totals
    
    order = current_user.orders.build(
      status: 'pending',
      subtotal: @subtotal,
      tax_amount: @tax_amount,
      total: @total,
      province: current_user.province,
      billing_address: current_user.full_address,
      order_date: Time.current
    )
    
    order.save!
    
    # Create order items (Feature 3.3.2 - Save historical prices)
    @cart_items.each do |item|
      order.order_items.create!(
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price  # Save current price for historical record
      )
    end
    
    order
  end
  
  def clear_cart
    session[:cart] = {}
  end
  
  def address_params
    params.require(:user).permit(:first_name, :last_name, :phone, 
                                 :address_line_1, :address_line_2, 
                                 :city, :postal_code, :province_id)
  end
end