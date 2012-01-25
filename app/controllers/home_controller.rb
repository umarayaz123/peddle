class HomeController < ApplicationController
  layout "application"
  before_filter :current_cart_create, :only => ["index","sales_floor"]

  def index
    @cart= current_cart
    @stores          = Store.limit(3).offset(0)
    @featured_stores = Store.where("is_featured = 1")
    unless current_user
      @featured_stores = Store.where("is_featured = 1")
      @stores          = @featured_stores.limit(4).offset(0)
      render :action => "home"
    else
      @feeds = Feed.order('created_at DESC').limit(20)
    end
  end

  def twitter_sign_in
    auth = request.env["omniauth.auth"]

    $token = auth["credentials"]["token"] unless auth.blank?
    $secret = auth["credentials"]["secret"] unless auth.blank?
    redirect_to root_url
  end

  def fb_sign_in
    auth = request.env["omniauth.auth"]
    puts "****************",auth.inspect
    $ftoken = auth["credentials"]["token"] unless auth.blank?
    $fsecret = auth["credentials"]["secret"] unless auth.blank?
    redirect_to root_url
  end

  def index_layout
    @stores          = Store.limit(3).offset(0)
    @featured_stores = Store.where("is_featured = 1")
    render :layout => false
  end

  def next_stores
    offset  = params[:offset]
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
    @package_rules         = Package.all
    @allowed_products      = PackageRule.where(:key => "allowed_products")
    @allowed_staff_members = PackageRule.where(:key => "allowed_staff_members")
    @allowed_images        = PackageRule.where(:key => "allowed_images")
    @chat                  = PackageRule.where(:key => "chat")
    @inventory_tracking    = PackageRule.where(:key => "inventory_tracking")
    @discount_count        = PackageRule.where(:key => "discount_count")
    render :layout => false
  end

  def home
    render :layout => false
  end

  def features
    render :layout => false
  end

  def sales_floor
    #@featured_stores = Store.where("is_featured = 1")
    #@stores = @featured_stores.limit(4).offset(0)
    @cart = current_cart
    @stores          = Store.limit(3).offset(0)
    @featured_stores = Store.where("is_featured = 1")
    unless current_user
      @featured_stores = Store.where("is_featured = 1")
      @stores          = @featured_stores.limit(4).offset(0)
      render :action => "home"
      return
    else
      @feeds = Feed.order('created_at DESC').limit(20)
    end
    render :action => "index"
  end

  def check_store
    @store = Store.find_by_name(params[:store_name])
    exist  =false
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

  def update_tweet
    Twitter.configure do |config|
      config.consumer_key       = "Msaz5aB2EZWjA8LJoOuWPQ"
      config.consumer_secret    = "TC1sATa0vworlTXT0LPmoZWFwoI9r4aSkvcWa41b25I"
      config.oauth_token        = $token
      config.oauth_token_secret = $secret
    end
    Twitter.update(params[:tweet])
    render :text => "Success"
  end

  def update_fb_status
    #@oauth = Koala::Facebook::OAuth.new("305179209528609", "bb50b9fc56195684033544a378ccf470", "/")
    user = FbGraph::User.new('me',  :access_token => $ftoken)
    user.feed!(
        :message     => params[:message],
        #:picture     => 'https://graph.facebook.com/matake/picture',
        :link        => 'http://ilsainteractive.com:3003',
        #:link        => 'http://lvh.me:3000',
        :name        => 'Peddle-online',
        :description => 'Updating FB status from peddle-Online',
        :scope       => 'publish_stream'
    )
    render :text => "Success"
  end

  def twitter_reg

  end

  def tweet_return

    render :text => "Success"
  end

end
