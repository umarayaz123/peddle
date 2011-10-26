class Admin::StoreAdminController < ApplicationController

  before_filter :authenticate_user!

  def index

  end

end
