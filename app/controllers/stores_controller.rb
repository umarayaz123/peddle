class StoresController < ApplicationController
#  before_filter :authenticate_user!
# GET /stores
# GET /stores.json
  before_filter :check_role, :current_cart_create

  def index
    @store = Store.find_by_name(request.subdomain)
    @store_name = request.subdomain
    @stores = Store.all
    unless @store.blank?
      @products = @store.products
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stores }
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def cart
    @store = Store.find(params[:id])
    redirect_to :controller => "store/#{@store.id}", :subdomain => @store.name
  end

  # GET /stores/new
  # GET /stores/new.json
  def new
    @store = Store.new
    @packages = Package.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @store }
    end
  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
    @packages = Package.all
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(params[:store])

    respond_to do |format|
      if @store.save
        #        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        #        format.json { render json: @store, status: :created, location: @store }
      else
        #        format.html { render action: "new" }
        #        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        #        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { head :ok }
      else
        #        format.html { render action: "edit" }
        #        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :ok }
    end
  end
end
