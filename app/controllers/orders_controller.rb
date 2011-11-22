class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    unless current_cart.order.nil?
      @order = current_cart.order
      @order.destroy
      @order = current_cart.build_order(params[:order])
    else
      @order = current_cart.build_order(params[:order])
    end
    @order.ip_address = request.remote_ip
    if @order.save
      response = @order.purchase
      if response
        @cart = current_cart
        #@cart.destroy
        session[:cart_id] = nil
        render :action => "success"
      else
        render :action => "new"
      end
    else
      redirect_to :action => 'new'
    end
  end

end
