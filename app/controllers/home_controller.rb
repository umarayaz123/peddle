class HomeController < ApplicationController
  layout "application"
  def index
    @stores = Store.all
  end

  def show
    @blog = Store.find_by_subdomain!(request.subdomain)
  end

end
