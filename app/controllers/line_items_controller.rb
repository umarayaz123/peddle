class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    unless params[:line_item].nil?
      product_detail = ProductDetail.find(params[:line_item][:product_detail_id])
    else
      product_detail = ProductDetail.find(params[:product_detail_id])
    end
    @line_item = @cart.line_items.build(:product_detail => product_detail)
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to(@line_item.cart,
                                  :notice => 'Line item was successfully created.') }
        format.xml { render :xml => @line_item,
                            :status => :created, :location => @line_item }

      else
        format.html { render :action => "new" }
        format.xml { render :xml => @line_item.errors,
                            :status => :unprocessable_entity }
      end
    end
  end


  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, :notice => 'Line item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html {
        unless params[:cart_id].blank?
          redirect_to '/carts/'+params[:cart_id]
        else
          redirect_to carts_url
        end
      }
      format.json { head :ok }
    end
  end
end
