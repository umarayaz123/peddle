class OrdersController < ApplicationController
  def new
    @order = current_cart
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

  def update
    @order = current_cart
    @start_date = Date.civil(params[:card_expires_on][:"(1i)"].to_i, params[:card_expires_on][:"(2i)"].to_i, params[:card_expires_on][:"(3i)"].to_i)
    @order = order_create(params[:order])
    if @order.update_attributes(:success => false)
      response = @order.purchase(current_user.id)
      if response
        @cart = current_cart
        #@cart.destroy
        session[:cart_id] = nil
        render :action => "success"
      else
        render :action => "new"
      end
    else
      puts "***********",@order.errors.inspect
      redirect_to :action => 'new'
    end

  end


  def order_create(params)
    @order.billing_address = params[:billing_address]
    @order.billing_city = params[:billing_city]
    @order.first_name = params[:first_name]
    @order.last_name = params[:last_name]
    @order.billing_name = params[:first_name]+" "+params[:last_name]
    @order.billing_state = params[:billing_state]
    @order.billing_country = params[:billing_country]
    @order.billing_zip = params[:billing_zip]
    @order.card_number = params[:card_number]
    @order.card_verification = params[:card_verification]
    @order.card_expires_on = @start_date
    @order.card_type = params[:card_type]
    @order
  end

end
