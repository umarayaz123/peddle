class HomeController < ApplicationController
  layout "application"

  def index
    @stores = Store.limit(3).offset(0)
    unless current_user
      @stores = Store.limit(4).offset(0)
      render :action => "home"
    end
  end

  def next_stores
    offset = params[:offset]
    @stores = Store.limit(3).offset(offset)
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

  end

  def home

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
