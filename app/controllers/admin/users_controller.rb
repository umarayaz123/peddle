class Admin::UsersController < ApplicationController

  layout "admin"

  before_filter :authenticate_user!, :make_resources
  before_filter :check_role
  before_filter :check_domain
  before_filter :not_admin

  # GET /sys_admins
  # GET /sys_admins.json
  def index
    @users = User.all
    admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
    if current_user.roles.include?(admin_role)
      @users = current_user.store.users
    end
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render :json => @sys_admins }
    #end
  end

  # GET /sys_admins/1
  # GET /sys_admins/1.json
  #  def show
  #    @sys_admin = SysAdmin.find(params[:id])
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.json { render json: @sys_admin }
  #    end
  #  end

  # GET /admins/new
  # GET /admins/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @sys_admin }
    end
  end

  # GET /sys_admins/1/edit
  def edit
    @user = User.find(params[:id])
  end


  # POST /admins
  # POST /admins.json
  def create
    @user = User.new(params[:user])
    @user.store = current_user.store
    respond_to do |format|
      if @user.save
        format.html { redirect_to :controller => "admin/users", :notice => 'User was successfully created.' }
        #format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        #format.json { render :json => @sys_admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  #
  # PUT /sys_admins/1
  # PUT /sys_admins/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to '/admin/users' }
        format.json { head :ok }
      else
        puts "erererereer"
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    seller_role = Role.find(:first, :conditions => ["name = ?", "Seller"])
    admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
    if current_user.roles.include?(seller_role) || @user.roles.include?(admin_role)
      redirect_to :controller => "admin/users"
    end
    @user.destroy
    redirect_to '/admin/users/'
#    respond_to do |format|
#      format.html { redirect_to admin_user_url }
#      format.json { head :ok }
#    end
  end

  def make_resources
    @allowed_staff_members = current_user.store.package.package_rules.select { |r| r.key=="allowed_staff_members" }
    @current_store_users = current_user.store.users.count
  end

end
