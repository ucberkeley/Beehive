class Sponsorship < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :job
end
