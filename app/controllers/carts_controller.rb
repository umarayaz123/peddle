class CartsController < ApplicationController
  # GET /carts
  # GET /carts.json
  def index
    @cart  = current_cart
    @store = Store.find_by_name(request.subdomain)

    render :layout => false
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    @cart  = Cart.find(params[:id])
    @store = Store.find_by_name(request.subdomain)

    #google_merchant_ID = "157193595798525"
    #google_merchant_key = "GEcRtJBOnpEJPFRaZfIsLA"
    #google_cart = GoogleCheckout::Cart.new(google_merchant_ID, google_merchant_key)
    #google_cart.add_item(:name => 'Chair', :description => 'A sturdy, wooden chair', :price => 44.99)
    #google_cart.add_item(:name => "Pancakes",
    #                     :description => "Flapjacks by mail.",
    #                     :price => 0.50,
    #                     :quantity => 10,
    #                     "merchant-item-id" => '2938292839')
    #@google_cart_button = google_cart.checkout_button.html_safe

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cart }
    end
  end

  # GET /carts/new
  # GET /carts/new.json
  def new
    @cart = Cart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cart }
    end
  end

  # GET /carts/1/edit
  def edit
    @cart = Cart.find(params[:id])
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, :notice => 'Cart was successfully created.' }
        format.json { render :json => @cart, :status => :created, :location => @cart }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /carts/1
  # PUT /carts/1.json
  def update
    @cart = Cart.find(params[:id])

    respond_to do |format|
      if @cart.update_attributes(params[:cart])
        format.html { redirect_to @cart, :notice => 'Cart was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart = current_cart
    @cart.order_details.each do |order_detail|
      if order_detail.product_detail.product_quantity.nil?
        details = 0
      else
        details = order_detail.product_detail.product_quantity
      end
      details +=1
      order_detail.product_detail.update_attributes(:product_quantity => details)
    end
    @cart.destroy
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to '/carts' }
      #format.html { redirect_to carts_url }
      format.json { head :ok }
    end
  end
end
