class Users::ConfirmationsController < ApplicationController
#  before_filter :check_role
  include Devise::Controllers::InternalHelpers

# GET /resource/confirmation/new
  def new
    build_resource
    render_with_scope :new
  end

  # POST /resource/confirmation
  def create
#    params[resource_name].skip_confirmation!
    #puts "*****************AAAAAAAAAAAAAAAAAA",resource_class
    #self.resource = resource_class.send_confirmation_instructions(params[resource_name], request.protocol, request.host_with_port)

    #if resource.errors.empty?
     # set_flash_message :notice, :send_instructions
      #redirect_to new_session_path(resource_name)
#    else
 #     render_with_scope :new
  #  end
  	
  	self.resource = resource_class.send_confirmation_instructions(params[resource_name])

    if successful_and_sane?(resource)
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with_navigational(resource){ render_with_scope :new }
    end
  
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message :notice, :confirmed
      unless params[:store_name].blank?
        redirect_to admin_url(:subdomain => params[:store_name])
        #redirect_to root_url
      else
        sign_in_and_redirect(resource_name, resource)
      end
    else
      render_with_scope :new
    end
  end
end
