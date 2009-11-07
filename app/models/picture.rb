class Picture < ActiveRecord::Base
  belongs_to :user
  belongs_to :job
end
