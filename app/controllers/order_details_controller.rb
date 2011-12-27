class OrderDetailsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @order_details = OrderDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @order_details }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @order_detail = OrderDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @order_detail }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @order_detail = OrderDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @order_detail }
    end
  end

  # GET /order_details/1/edit
  def edit
    @order_detail = OrderDetail.find(params[:id])
  end

  # POST /order_details
  # POST /order_details.json
  def create
    @cart = current_cart
    unless params[:order_detail].nil?
      product_detail = ProductDetail.find(params[:order_detail][:product_detail_id])
    else
      product_detail = ProductDetail.find(params[:product_detail_id])
    end
    if ((product_detail.product_quantity.nil?) || (product_detail.product_quantity < 1))
      render :text => "fail", :layout => false
      return
    else
      @order_detail = @cart.order_details.build(:product_detail => product_detail)
      respond_to do |format|
        if @order_detail.save
          if product_detail.product_quantity.nil?
            details = 0
          else
            details = product_detail.product_quantity-1
          end
          product_detail.update_attributes(:product_quantity => details)
          format.html { redirect_to(@order_detail,
                                    :notice => 'Product was successfully created.') }
          format.xml { render :xml    => @order_detail,
                              :status => :created, :location => @order_detail }

        else
          format.html { render :action => "new" }
          format.xml { render :xml    => @order_detail.errors,
                              :status => :unprocessable_entity }
        end
      end
    end
  end


  # PUT /order_details/1
  # PUT /order_details/1.json
  def update
    @order_detail = OrderDetail.find(params[:id])

    respond_to do |format|
      if @order_detail.update_attributes(params[:order_detail])
        format.html { redirect_to @order_detail, :notice => 'Line item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @order_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /order_details/1
  # DELETE /order_details/1.json
  def destroy
    @order_detail = OrderDetail.find(params[:id])
    product_detail = ProductDetail.find_by_id(@order_detail.product_detail_id)
    if product_detail.product_quantity.nil?
      details = 0
    else
      details = product_detail.product_quantity
    end
    @order_detail.destroy
    details +=1
    product_detail.update_attributes(:product_quantity => details)
    respond_to do |format|
      format.html {
        unless params[:cart_id].blank?
          redirect_to carts_url
        else
          redirect_to carts_url
        end
      }
      format.json { head :ok }
    end
  end
end
