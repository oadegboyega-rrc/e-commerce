class Cartscontroller < ApplicationController
    before_action :initializer_cart

    def show
        @cart_items = []
        @total = 0

        @cart.each do |product_id, quantity|
            product = Product.find_by(id: product_id)
            if product
                item_total = product.price * quantity
                @cart_items << {
                    product: product,
                    quantity: quantity, 
                    total: item_total
                }
                @total += item_total
            end
        end
    end

    # Add an item to the cart
    def add_item
        product_id = params[:product_id]
        quantity = params[:quantity]&.to_i || 1

        if product_exists?(product_id)
            @cart[product_id] = (@cart[product_id] || 0) + quantity
            session[:cart] = cart

            flash[:notice] = "Item added to cart successfully!"
        else
            flash[:alert] = "Product not found."
        end

        redirect_back(fallback_location: root_path)
    end

    # Update item quantity
    def update_item
        product_id = params[:product_id]
        quantity = params[:quantity].to_i

        if quantity > 0
            @cart[product_id] = quantity
            flash[:notice] = "cart updated successfully!"
        else
            @cart.delete(product_id)
            flash[:notice] = "Item removed from cart."
        end

        session[:cart] = @cart
        redirect_to cart_path
    end

    # Remove an item from the cart
    def remove_item
        product_id = params[:product_id]
        @cart.delete(product_id)
        session[:cart] = @cart

        flash[:notice] = "Item removed from cart."
        redirect_to cart_path
    end

    def destroy
        session[:cart] = {}
        flash[:notice] = "Cart cleared successfully."
        redirect_to root_path
    end

    private
    
    def initializer_cart
        @cart = session[:cart] || {}
    end 

    def product_exists?(product_id)
        Product.exists?(product_id)
    end
end