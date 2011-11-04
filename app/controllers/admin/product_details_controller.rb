class Admin::ProductDetailsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  def index    
		#@product_detail = ProductDetail.find(params[:product_id])
#    @product_id = params[:product_id]
#    @product = Product.find(@product_id)
    @product = Product.find(params[:id])
		@product_details = ProductDetail.find(:all, :conditions => ["product_id = ?",params[:id]])
    #if @product_detail.empty?
    #  redirect_to :action => 'new'
    #end
  end

  def new    
    @product_id = params[:id]
    @product = Product.find(@product_id)
    @product_detail = ProductDetail.new
    @product_detail.images.build
  end

  def create
#    puts 'DSSSSSSS', params[:product_id].inspect
#    @product_id = params[:product_id]
#    @product = Product.find(@product_id)
    @product_detail = ProductDetail.new(params[:product_detail])        
      if @product_detail.save
        @product_details = ProductDetail.find(:all, :conditions => ["product_id = ?",@product_detail.product_id])
        redirect_to :controller => "admin/product_details",  :id => @product_detail.product_id
      else
        render :action => "new"
      end    
  end

  def edit
    @product_detail = ProductDetail.find(params[:id])
    @product_id = @product_detail.product_id
  end

  def update    
     @product_detail = ProductDetail.find(params[:id])
      if @product_detail.update_attributes(params[:product_detail])
        redirect_to "/admin/product_details?id="+@product_detail.product_id.to_s
#        format.html { redirect_to '/admin/products/'+@product_id+'/product_details', :notice => 'Product was successfully updated.' }
#        format.json { head :ok }
      else
        redirect_to '/admin/product_details/'+@product_detail.id.to_s+'/edit'
      end    
  end

  def destroy
#    @product_id = params[:id]
#    @product = Product.find(@product_id)
    @product_detail = ProductDetail.find(params[:id])
    @product_detail.destroy
    redirect_to :controller => "admin/product_details",  :id => @product_detail.product_id
#    redirect_to '/admin/products/'+@product_id+'/product_details', :notice => 'Product was successfully deleted.'
  end

  def delete
    @product_id = params[:product_id]
    @product = Product.find(@product_id)
    @product_detail = ProductDetail.find(params[:id])
    @product_detail.destroy
    redirect_to '/admin/products/'+@product_id+'/product_details', :notice => 'Product was successfully deleted.'
  end

end
