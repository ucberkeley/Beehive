class Proficiency < ActiveRecord::Base

  # === List of columns ===
  #   id          : integer 
  #   proglang_id : integer 
  #   user_id     : integer 
  #   created_at  : datetime 
  #   updated_at  : datetime 
  # =======================

  belongs_to :proglang
  belongs_to :user
end
