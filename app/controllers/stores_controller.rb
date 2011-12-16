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
      @products = @store.products.limit(3).offset(0)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stores }
    end
  end

  def store
    @store = Store.find_by_name(request.subdomain)
    @store_name = request.subdomain
    @stores = Store.all
    unless @store.blank?
      @products = @store.products.limit(3).offset(0)
    end
    render :layout => false
  end

  def next_products
    @store = Store.find_by_name(request.subdomain)
    offset = params[:offset]
    unless @store.blank?
      @products = @store.products.limit(3).offset(offset)
    end
    #@stores = Store.limit(3).offset(offset)
    render :layout => false
  end

  def show
    @product = Product.find(params[:id])
  end

  def cart
    @store = Store.find(params[:id])
    redirect_to :controller => "store/#{@store.id}", :subdomain => @store.name
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

  def search_store
    @sname = params[:sname]
    if @sname != ""
      @stores = Store.find(:all, :conditions => ["name = ?", @sname])
      #else
      #  @stores = Store.all
    end
    render :layout => false
  end

end
