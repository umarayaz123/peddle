class Admin::ProductsController < ApplicationController

  before_filter :authenticate_user!
  before_filter do
    admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
    redirect_to '/' unless current_user && current_user.roles.include?(admin_role)
  end

  # GET /products
  # GET /products.json
  def index
    @store = current_user.store    
    @products = current_user.store.products.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    #    @product.images.build
    1.upto(1) { @product.images.build }
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])
#    @product.save    
      if @product.save
        @store = current_user.store
        @products = current_user.store.products.all
        render "index"
      else
        render "new"
      end    
  end
  #  def create
  #    @product = Product.new(params[:product])
  #    unless params[:image].blank?
  #      params[:image].each do |i|
  #        if i[:image_data] && !i[:image_data].blank?
  ##          puts 'IIIIIIIIIIIII', i.inspect
  ##          dddd
  ##          new_image = Image.new[i[:image_data]]
  ##          new_image.save
  ##          ddd
  ##          new_image.uploaded_data = i[:image_data]
  ##          if new_image.save
  #          i[:image_data].
  #            puts 'IIIIIIIIIIIIIIIIII', i.inspect
  ##            @product.images << i[:image_data]
  #            dd
  ##          else
  ##            image_errors.push(new_image.filename)
  #          end
  #        end
  #      end
  #
  #
  #    respond_to do |format|
  #      if @product.save
  #        format.html { redirect_to [:admin, @product], :notice => 'Product was successfully created.' }
  #        format.json { render :json => [:admin, @product], :status => :created, :location => @product }
  #      else
  #        format.html { render :action => "new" }
  #        format.json { render :json => @product.errors, :status => :unprocessable_entity }
  #      end
  #    end
  #  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to [:admin, @product], :notice => 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to admin_products_url }
      format.json { head :ok }
    end
  end

  def admin?
    self.admin == true
  end


end
