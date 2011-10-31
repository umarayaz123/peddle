class Admin::StoreAdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_role
  
  def index    
#    unless is_admin?
#      redirect_to "/"
#    end		
		#@products = Product.all
		@store = current_user.store
		@products = current_user.store.products.all
    respond_to do |format|
      format.html # index.html.erb
#      format.json { render json: @products }
    end
  end
end
