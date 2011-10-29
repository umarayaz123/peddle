class Admin::ProductDetailsController < ApplicationController
   before_filter :authenticate_user!
  def index
		#@product_detail = ProductDetail.find(params[:product_id])
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
		@product_detail = ProductDetail.find(:all, :conditions => ["product_id = ?",params[:product_id]])
    #if @product_detail.empty?
    #  redirect_to :action => 'new'
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

  def update
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
    @product_detail = ProductDetail.find(params[:id])
    respond_to do |format|
      if @product_detail.update_attributes(params[:product_detail])
        format.html { redirect_to '/admin/products/'+@product_id+'/product_details', :notice => 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
    @product_detail = ProductDetail.find(params[:id])
    @product_detail.destroy
    redirect_to '/admin/products/'+@product_id+'/product_details', :notice => 'Product was successfully deleted.'
  end

  def delete
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
    @product_detail = ProductDetail.find(params[:id])
    @product_detail.destroy
    redirect_to '/admin/products/'+@product_id+'/product_details', :notice => 'Product was successfully deleted.'
  end

end
