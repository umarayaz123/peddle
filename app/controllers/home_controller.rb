class HomeController < ApplicationController
  layout "application"
  def index
    @stores = Store.limit(3).offset(0)
  end

  def next_stores
    offset = params[:offset]
    @stores = Store.limit(3).offset(offset)
    render :layout => false
  end

  def show
    @blog = Store.find_by_subdomain!(request.subdomain)
  end

  def plans

  end

end
