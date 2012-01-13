class Users::SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create
  include Devise::Controllers::InternalHelpers
  #  after_sign_in_path_for :check_role

  # GET /resource/sign_in
  def new
    resource = build_resource
    clean_up_passwords(resource)
    respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }
  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => redirect_location(resource_name, resource)
  end

  #  def create
  #    resource = warden.authenticate!(:scope => resource_name, :recall => "new")
  #    puts "sign_in_and_redirect #{resource_name} #{resource}"
  #    sign_in_and_redirect(resource_name, resource)
  #  end

  # GET /resource/sign_out

  def destroy
    $token =  nil
    $secret = nil
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :signed_out if signed_in
    session["role_checked"] = ""
    session["admin_role_checked"] = ""    
    #    redirect_to root_url(:subdomain => subdomain)
    # We actually need to hardcode this, as Rails default responder doesn't
    # support returning empty response on GET request

    respond_to do |format|
      format.any(*navigational_formats) {
        if request.subdomain.blank?
          redirect_to "/"
        else
          url = root_url(:subdomain => false)
          if request.subdomain != ""
            new_url = request.subdomain+'.'
            url = url.sub(new_url,'')
          end
          redirect_to url
        end
      }
      format.all do
        method = "to_#{request_format}"
        text = {}.respond_to?(method) ? {}.send(method) : ""
        render :text => text, :status => :ok
      end
    end
  end

  protected

  def stub_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { :methods => methods, :only => [:password] }
  end
end

