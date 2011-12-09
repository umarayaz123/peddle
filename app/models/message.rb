class Message < ActiveRecord::Base
  default_scope order('created_at')
  paginates_per 15
end
