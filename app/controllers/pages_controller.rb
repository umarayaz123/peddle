class PagesController < ApplicationController
  before_filter :current_cart_create
  def index
    @store = Store.find_by_name(request.subdomain)
    page_name = params[:name]
    @page = Page.find_by_name(page_name)
    #@product = Product.find(params[:id])
    @order_details = OrderDetail.new
    render :layout => false
  end

  def purchase_history
    @orders = Order.where("user_id = ?",current_user.id).page(params[:page])
    render :layout => false
  end

  def edit
    render :controller => "registrations", :action => "edit", :layout => false
  end

end
