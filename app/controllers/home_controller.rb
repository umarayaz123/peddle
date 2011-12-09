class HomeController < ApplicationController
  layout "application"

  def index
    @stores = Store.limit(3).offset(0)
    @featured_stores = Store.where("is_featured = 1")
    unless current_user
      @featured_stores = Store.where("is_featured = 1")
      @stores = @featured_stores.limit(4).offset(0)
      render :action => "home"
    end
  end

  def next_stores
    offset = params[:offset]
    @stores = Store.limit(3).offset(offset.to_i)
    render :layout => false
  end

  def get_states
    begin
      @states = Carmen::states(params[:country])
    rescue
      @states = "states not supported"
    end
    render :layout => false
  end

  def show
    @blog = Store.find_by_subdomain!(request.subdomain)
  end

  def plans
    @package_rules =Package.all
    @allowed_products = PackageRule.where(:key => "allowed_products")
    @allowed_staff_members = PackageRule.where(:key => "allowed_staff_members")
    @allowed_images = PackageRule.where(:key => "allowed_images")
    @chat = PackageRule.where(:key => "chat")
    @inventory_tracking = PackageRule.where(:key => "inventory_tracking")
    @discount_count = PackageRule.where(:key => "discount_count")
  end

  def home

  end

  def features

  end

  def sales_floor
    @featured_stores = Store.where("is_featured = 1")
    @stores = @featured_stores.limit(4).offset(0)
    unless current_user
      @featured_stores = Store.where("is_featured = 1")
      @stores = @featured_stores.limit(4).offset(0)
      render :action => "home"
    end
    render :action => "index"
  end

  def check_store
    @store = Store.find_by_name(params[:store_name])
    exist =false
    unless @store.nil?
      exist =true
    end
    render :layout => false, :text => exist
  end

  def check_email
    @user = User.find_by_email(params[:email])
    exist =false
    unless @user.nil?
      exist =true
    end
    render :layout => false, :text => exist
  end

end
