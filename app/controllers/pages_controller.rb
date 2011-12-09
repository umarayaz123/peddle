class PagesController < ApplicationController
  #before_filter :check_role, :current_cart_create
  def index
    @store = Store.find_by_name(request.subdomain)
    page_name = params[:name]
    @page = Page.find_by_name(page_name)
    #@product = Product.find(params[:id])
    @order_details = OrderDetail.new
  end

  def purchase_history
    @orders = Order.where("user_id = ?",current_user.id).page(params[:page])
  end

end
