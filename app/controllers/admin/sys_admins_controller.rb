class Admin::SysAdminsController < ApplicationController

  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :check_role
  before_filter :check_domain
  before_filter :not_admin

  # GET /sys_admins
  # GET /sys_admins.json
  def index
    #@sys_admins = SysAdmin.all

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render :json => @sys_admins }
    #end
  end

  # GET /sys_admins/1
  # GET /sys_admins/1.json
  def show
    @sys_admin = SysAdmin.find(params[:id])

#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @sys_admin }
#    end
  end

  # GET /sys_admins/new
  # GET /sys_admins/new.json
  def new
    @sys_admin = SysAdmin.new

    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @sys_admin }
    end
  end

  # GET /sys_admins/1/edit
  def edit
    @sys_admin = SysAdmin.find(params[:id])
  end

  # POST /sys_admins
  # POST /sys_admins.json
  def create
    @sys_admin = SysAdmin.new(params[:sys_admin])

    respond_to do |format|
      if @sys_admin.save
#        format.html { redirect_to @sys_admin, notice: 'Sys admin was successfully created.' }
#        format.json { render json: @sys_admin, status: :created, location: @sys_admin }
      else
#        format.html { render action: "new" }
#        format.json { render json: @sys_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sys_admins/1
  # PUT /sys_admins/1.json
  def update
    @sys_admin = SysAdmin.find(params[:id])

    respond_to do |format|
      if @sys_admin.update_attributes(params[:sys_admin])
#        format.html { redirect_to @sys_admin, notice: 'Sys admin was successfully updated.' }
#        format.json { head :ok }
      else
#        format.html { render action: "edit" }
#        format.json { render json: @sys_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_admins/1
  # DELETE /sys_admins/1.json
  def destroy
    @sys_admin = SysAdmin.find(params[:id])
    @sys_admin.destroy

    respond_to do |format|
#      format.html { redirect_to sys_admins_url }
#      format.json { head :ok }
    end
  end
end
