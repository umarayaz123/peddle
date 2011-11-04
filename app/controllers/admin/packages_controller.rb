class Admin::PackagesController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!
  # GET /stores
  # GET /stores.json
  before_filter :check_role
  
  def index    
    @packages = Package.all
    #    @products = @store.products
    #    respond_to do |format|
    #      format.html # index.html.erb
    #      format.json { render :json => @stores }
    #    end
  end
  
  def show  	
    @package = Package.find(params[:id])
  end

  def cart
    @store = Store.find(params[:id])
    redirect_to :controller => "store/#{@store.id}", :subdomain => @store.name
  end

  # GET /stores/new
  # GET /stores/new.json
  def new

    @package = Package.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @store }
    end

  end

  # GET /stores/1/edit
  def edit
    @package = Package.find(params[:id])    
  end

  # POST /stores
  # POST /stores.json
  def create    
    @package = Package.new(params[:package])
    if @package.save      
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end


# PUT /stores/1
# PUT /stores/1.json
def update
  @package = Package.find(params[:id]) 
  if @package.update_attributes(params[:package])    
    redirect_to :action => "index"
  else
     redirect_to :action => "edit"
  end
end  

# DELETE /stores/1
# DELETE /stores/1.json
def destroy
  @package = Package.find(params[:id])
  @package.destroy
  redirect_to :action => "index"
end
end
