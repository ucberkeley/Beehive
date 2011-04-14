class UserAttrib < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   user_id    : integer 
  #   attrib_id  : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  belongs_to :user
  belongs_to :attrib
end
