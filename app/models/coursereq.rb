class Coursereq < ActiveRecord::Base
  belongs_to :course
  belongs_to :job
end
