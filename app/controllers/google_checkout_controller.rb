class GoogleCheckoutController < ApplicationController

  def google_checkout
    @cart = current_cart
    @cart.destroy
    session[:cart_id] = nil
    redirect_to root_url
  end

end
