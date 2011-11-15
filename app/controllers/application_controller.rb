class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :mailer_set_url_options

  def mailer_set_url_options
    #ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def check_domain    
    unless current_user.store.blank?      
      unless request.subdomain == current_user.store.name
        session["subdomain"] == request.subdomain
        redirect_to "/sign_out"
      end
    end
  end


  def check_role
    unless session["role_checked"]
      if current_user
        admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
        seller_role = Role.find(:first, :conditions => ["name = ?", "Seller"])
        buyer_role = Role.find(:first, :conditions => ["name = ?", "Buyer"])
        if current_user.roles.include?(admin_role)
          session["role_checked"] = true
        end
        if current_user.roles.include?(buyer_role)
          session["role_checked"] = true
        end
        if current_user.roles.include?(seller_role)
          session["role_checked"] = true
        end
      end
      check_role_type
    end
  end

  def stored_location_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    session["role_checked"] = false
    puts "Deleting session in stored_location_for #{scope}";
    session.delete("#{scope}_return_to")
    puts "store"
    super_admin_role = Role.find(:first, :conditions => ["name = ?", "SuperAdmin"])
    admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
    seller_role = Role.find(:first, :conditions => ["name = ?", "Seller"])
    buyer_role = Role.find(:first, :conditions => ["name = ?", "Buyer"])
    unless current_user.store.blank?
      if current_user.store.name == request.subdomain
        if current_user.roles.include?(admin_role)
          admin_url(:subdomain => request.subdomain)
        elsif current_user.roles.include?(buyer_role)
          stores_url(:subdomain => request.subdomain)
        else
          root_url(:subdomain => request.subdomain)
        end
      else
        sign_out_url
      end
    else
      #      admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
      unless request.subdomain.blank?
        sign_out_url
      else
        if current_user.roles.include?(super_admin_role)
          sysadmin_url
        else
          #sign_out_url
          root_url()
        end
      end
    end
  end

  protected
  def check_role_type
    super_admin_role = Role.find(:first, :conditions => ["name = ?", "SuperAdmin"])
    admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
    seller_role = Role.find(:first, :conditions => ["name = ?", "Seller"])
    buyer_role = Role.find(:first, :conditions => ["name = ?", "Buyer"])
    if current_user
      unless current_user.store.blank?
        subdomain = current_user.store.name
        if current_user.roles.include?(admin_role)
          redirect_to :controller => "/admin/store_admin", :subdomain => subdomain
        else
          redirect_to :controller => "/stores", :subdomain => subdomain
        end
      else
        unless request.subdomain.blank?
          sign_out_url
        else
          if current_user.roles.include?(super_admin_role)
            sysadmin_url
          else
            #sign_out_url
            root_url()
          end
        end
      end
    end
  end

  def not_admin
    admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
    if current_user.roles.include?(admin_role)
      sign_out_url
    end
  end

  def not_super_admin
    super_admin_role = Role.find(:first, :conditions => ["name = ?", "SuperAdmin"])
    if current_user.roles.include?(super_admin_role)
      sign_out_url
    end
  end

end
