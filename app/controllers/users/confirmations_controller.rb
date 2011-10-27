class Users::ConfirmationsController < Devise::ConfirmationsController
#  before_filter :check_role
#  include Devise::Controllers::InternalHelpers

  # GET /resource/confirmation/new
  def new
    build_resource
    render_with_scope :new
  end

  # POST /resource/confirmation
  def create    
#    params[resource_name].skip_confirmation!    
    self.resource = resource_class.send_confirmation_instructions(params[resource_name], request.protocol, request.host_with_port)

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      redirect_to new_session_path(resource_name)
    else
      render_with_scope :new
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message :notice, :confirmed
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :new
    end
  end
end
