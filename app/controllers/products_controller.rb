class ProductsController < ApplicationController
  before_filter :current_cart_create#, :authenticate_user!
  # GET /products
  # GET /products.json
  def index
    @store = Store.find_by_name(request.subdomain)
    @store_name = request.subdomain
    @stores = Store.all
    unless @store.blank?
      @products = @store.products.limit(3).offset(0)
    end
    render :template => 'stores/index'
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @store = Store.find_by_name(request.subdomain)
    @product = Product.find(params[:id])
    @order_details = OrderDetail.new
    render :layout => false

  end


  def _cart_div
    render :partial => "cart_div", :layout => false
  end

  def search_products
    @store = Store.find_by_name(request.subdomain)
    @pname = params[:pname]
    if @pname != ""
      @products = Product.find(:all,:conditions => ["name = ? AND store_id=?",@pname,@store.id])
    else
      @products = Product.all
    end
    render :layout => false
  end

end
