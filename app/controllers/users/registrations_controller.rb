class Users::RegistrationsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [:new, :create, :cancel]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  include Devise::Controllers::InternalHelpers
  layout :resolve_layout
  #layout "admin"
  # GET /resource/sign_up
  def new
    resource = build_resource({ })
    @package = params[:package]
    respond_with_navigational(resource) { render_with_scope :new }
  end

  # POST /resource
  def create
    if (params[:package] != "1")
      package           = package_selection(params[:package])
      #@order = current_cart.build_order(params[:order])
      @start_date       = Date.civil(params[:card_expires_on][:"(1i)"].to_i, params[:card_expires_on][:"(2i)"].to_i, params[:card_expires_on][:"(3i)"].to_i)
      @order            = order_create(params)
      @order.ip_address = request.remote_ip
      if @order.save
        response = @order.authorise_store_package(package.price.to_i)
        if response.success?
          @authorise = response.authorization
        else
          flash[:notice] = "Couldn't authorise your card. Please check if your card has required amount'"
          redirect_to '/users/sign_up'
          return
        end
      else
        flash[:notice] = "Card Info is not correct"
        redirect_to '/users/sign_up'
        return
      end
    end
    stores = Store.find_by_name(params[:store_name])
    if stores.nil? && !params[:store_name].blank?
      surl    = params[:store_name]+'.peddle.com'
      package ||= package_selection(params[:package])
      store   = Store.new(:package_id => package.id.to_i, :name => params[:store_name], :url => surl)
      build_resource
      admin  = Role.find_by_name('Admin')
      seller = Role.find_by_name('Seller')
      buyer  = Role.find_by_name('Buyer')

      if params[:seller].nil? && params[:buyer].nil?
        resource.roles << admin
      end
      unless params[:seller].nil?
        resource.roles << admin
      end
      unless params[:buyer].nil?
        resource.roles << buyer
      end
      if store.save
        resource.store_id = store.id
        if resource.save
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_navigational_format?
            sign_in(resource_name, resource)
            respond_with resource, :location => redirect_location(resource_name, resource)
          else
            if (params[:package] != "1")
              response = @order.capture_store_package(package.price.to_i, resource.id, @authorise)
              if response.success?
                resource.update_attributes!(:user_id => @order.id)
              end
            end
            set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
            expire_session_data_after_sign_in!
            respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords(resource)
          respond_with_navigational(resource) { render_with_scope :new }
        end
      else
        flash[:notice] = "Couldn't create your Store Please try again Later.'"
        redirect_to '/users/sign_up'
      end
    elsif params[:store_name].blank?
      flash[:notice] = "Buyers account"
      #surl = params[:store_name]+'.peddle.com'
      #store = Store.new(:package_id => 1, :name => params[:store_name], :url => surl)
      build_resource
      buyer = Role.find_by_name('Buyer')

      resource.roles << buyer
      if resource.save
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, resource)
          respond_with resource, :location => redirect_location(resource_name, resource)
        else
          set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
          expire_session_data_after_sign_in!
          #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          respond_with resource, :location => root_url
        end
      else
        clean_up_passwords(resource)
        respond_with_navigational(resource) { render_with_scope :new }
      end
    else
      flash[:notice] = "Store Name Already taken"
      redirect_to '/users/sign_up', params
      return
    end
  end

  # GET /resource/edit
  def edit
    @cart = current_cart
    @request_type = "plain"
    if request.xhr?
      @request_type = "ajax"
      render :layout => false
      puts "************ request.xhr true", request.xhr?
      return
    end
    puts "************ request.xhr FALSE", request.xhr?
    render_with_scope :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    package    = package_selection(params[:package])
    @store     = Store.find_by_name(request.subdomain) || current_user.store
    buyer_role = Role.find(:first, :conditions => ["name = ?", "Buyer"])
    unless current_user.roles.include?(buyer_role)
      if (params[:package] != "1")
        @start_date       = Date.civil(params[:card_expires_on][:"(1i)"].to_i, params[:card_expires_on][:"(2i)"].to_i, params[:card_expires_on][:"(3i)"].to_i)
        @order            = order_create(params)
        @order.ip_address = request.remote_ip
        @price            = package.price.to_i - @store.package.price.to_i
        if @order.save
          response = @order.authorise_store_package(@price)
          if response.success?
            @authorise = response.authorization
          else
            flash[:notice] = response.message
            redirect_to '/users/edit'
            return
          end
        else
          flash[:notice] = "Card Info is not correct"
          redirect_to '/users/edit'
          return
        end
      end
    end
    @user = current_user
    if @user.update_with_password(params[:user])
      @store.update_attribute(:package_id, package.id) unless current_user.roles.include?(buyer_role)
      unless @order.nil?
        response = @order.capture_store_package(@price, current_user.id, @authorise)
        if response.success?
          @order.update_attributes!(:user_id => current_user.id)
          @store.update_attribute(:package_id, package.id)
        end
      end
      set_flash_message :notice, :updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      @request_type = "plain"
      if request.xhr?
        @request_type = "ajax"
        redirect_to root_url+"index_layout"
        return
      end
      respond_with resource, :location => after_update_path_for(resource)

    else
      @request_type = "plain"
      if request.xhr?
        @request_type = "ajax"
        #render :action => "edit", :layout => false
        #
        #return
      end
      render :text => "update_failed"
      #clean_up_passwords(resource)
      #respond_with_navigational(resource) { render_with_scope :edit }
    end
  end

# DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  end

# GET /resource/cancel
# Forces the session data which is usually expired after sign
# in to be expired now. This is useful if the user wants to
# cancel oauth signing in/up in the middle of the process,
# removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

# Build a devise resource passing in the session. Useful to move
# temporary session data to the newly created user.
  def build_resource(hash=nil)
    hash          ||= params[resource_name] || { }
    self.resource = resource_class.new_with_session(hash, session)
  end

# The path used after sign up. You need to overwrite this method
# in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

# Overwrite redirect_for_sign_in so it takes uses after_sign_up_path_for.
  def redirect_location(scope, resource)
    stored_location_for(scope) || after_sign_up_path_for(resource)
  end

# Returns the inactive reason translated.
  def inactive_reason(resource)
    reason = resource.inactive_message.to_s
    I18n.t("devise.registrations.reasons.#{reason}", :default => reason)
  end

# The path used after sign up for inactive accounts. You need to overwrite
# this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    root_path
  end

# The default url to be used after updating a resource. You need to overwrite
# this method in your own RegistrationsController.
  def after_update_path_for(resource)
    if defined?(super)
      ActiveSupport::Deprecation.warn "Defining after_update_path_for in ApplicationController " <<
                                          "is deprecated. Please add a RegistrationsController to your application and define it there."
      super
    else
      after_sign_in_path_for(resource)
    end
  end

# Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  private

  def package_selection(package)
    case package
      when "2" then
        package = Package.find_by_name("Time to Grow")
      when "3" then
        package = Package.find_by_name("Corporation")
      when "4" then
        package = Package.find_by_name("Enterprise")
      else
        package = Package.find_by_name("Start-up")
    end
    package
  end

  def order_create(params)
    @order                   = Order.new
    @order.billing_address   = params[:billing_address]
    @order.billing_city      = params[:billing_city]
    @order.first_name        = params[:first_name]
    @order.last_name         = params[:last_name]
    @order.billing_name      = params[:first_name]+" "+params[:last_name]
    @order.billing_state     = params[:billing_state]
    @order.billing_country   = params[:billing_country]
    @order.billing_zip       = params[:billing_zip]
    @order.card_number       = params[:card_number]
    @order.card_verification = params[:card_verification]
    @order.card_expires_on   = @start_date
    @order.card_type         = params[:card_type]
    @order
  end

  def resolve_layout
    buyer_role = Role.find(:first, :conditions => ["name = ?", "Buyer"])
    case action_name
      when "new", "create" then
        "application"
      when "edit" then
        if current_user.roles.include?(buyer_role)
          "application"
        else
          "admin"
        end
    end
  end


end
