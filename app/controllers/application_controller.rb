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
    if session["role_checked"] == ""      
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


  protected
  def check_role_type    
    if current_user
      admin_role = Role.find(:first, :conditions => ["name = ?", "Admin"])
      if current_user.roles.include?(admin_role)        
        redirect_to :controller => "/admin/store_admin"
      else        
        redirect_to :controller => "/stores"
      end
    end
  end

end
