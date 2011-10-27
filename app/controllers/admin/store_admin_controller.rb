class Admin::StoreAdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_role
  
  def index    
#    unless is_admin?
#      redirect_to "/"
#    end
  end

end