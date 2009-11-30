class Proglangreq < ActiveRecord::Base
  belongs_to :job
  belongs_to :proglang
end
