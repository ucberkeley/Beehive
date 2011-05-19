class Interest < ActiveRecord::Base

  # === List of columns ===
  #   id          : integer 
  #   category_id : integer 
  #   user_id     : integer 
  #   created_at  : datetime 
  #   updated_at  : datetime 
  # =======================

  belongs_to :category
  belongs_to :user
end
