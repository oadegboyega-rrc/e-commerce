class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.all
    @products = @products.by_category(params[:category]) if params[:category].present?

    case params[:filter]
    when 'on_sale'
      @products = @products.on_sale
    when 'new'
      @products = @products.new_arrivals
    when 'recent'
      @products = @products.recently_updated
    end

    @products = @products.page(params[:page]).per(12)
    @current_category = params[:category]
    @current_filter = params[:filter]
  end
  
  def show
    # Products is set in before_action
  end
  
  def search
    @products = Product.all
    
    if params[:keyword].present?
      @products = @products.search_by_keyword(params[:keyword])
    end
    
    if params[:category].present?
      @products = @products.by_category(params[:category])
    end
    
    # Pagination for search results
    @products = @products.page(params[:page]).per(12)
    
    @search_keyboard = params[:keyword]
    @search_category = params[:category]
    
    render :index
  end
  
  private
  
  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Product not found."
  end
end

