class Proglangreq < ActiveRecord::Base

  # === List of columns ===
  #   id          : integer 
  #   job_id      : integer 
  #   proglang_id : integer 
  #   created_at  : datetime 
  #   updated_at  : datetime 
  # =======================

  belongs_to :job
  belongs_to :proglang
end
