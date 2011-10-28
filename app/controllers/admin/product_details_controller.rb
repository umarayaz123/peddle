class Admin::ProductDetailsController < ApplicationController

  def index
		#@product_detail = ProductDetail.find(params[:product_id])
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
		@product_detail = ProductDetail.find(:all, :conditions => ["product_id = ?",params[:product_id]])
    if @product_detail.empty?
      redirect_to :action => 'new'
    end
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @products }
    #end
  end

  def new
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
    @product_detail = ProductDetail.new
  end

  def create
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
    @product_detail = ProductDetail.new(params[:product_detail])

    respond_to do |format|
      if @product_detail.save
        format.html { redirect_to '/admin/products/'+@product_id+'/product_details', :notice => 'Product was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
    @product_detail = ProductDetail.find(params[:id])
  end

end
