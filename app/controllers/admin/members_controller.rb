class Admin::MembersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = current_user.store.users
  end

  private

end
