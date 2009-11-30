class Proficiency < ActiveRecord::Base
  belongs_to :proglang
  belongs_to :user
end
