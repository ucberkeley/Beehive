class AbstractUser < ActiveRecord::Base
  self.abstract_class = true
end
