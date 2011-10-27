class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  #  before_filter :check_role, :except => ["/users/new"]
  
  #  def check_role
  #    if session["role_checked"].blank?
  #      if current_user
  #        admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
  #        if current_user.roles.include?(admin_role)
  #          session["role_checked"] = true
  #        end
  #        check_role_type
  #      end
  #    end
  #  end

  def check_role
    unless session["role_checked"]      
      if current_user
        admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
        seller_role = Role.find(:first, :conditions => ["name = ?", "Buyer"])
        if current_user.roles.include?(admin_role)          
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
    subdomain = current_user.store.name
    puts "store"
    admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
    buyer_role = Role.find(:first, :conditions => ["name = ?", "Buyer"])
    if current_user.roles.include?(admin_role)        
      root_url(:subdomain => subdomain)
    elsif current_user.roles.include?(buyer_role)
      stores_url(:subdomain => subdomain)
    end

  end

  protected
  def check_role_type    
    if current_user
      subdomain = current_user.store.name
      admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
      if current_user.roles.include?(admin_role)        
        #        redirect_to :controller => "/admin/store_admin"
        redirect_to request.url
      else        
        redirect_to :controller => "/stores", :subdomain => subdomain
      end
    end
  end

end
