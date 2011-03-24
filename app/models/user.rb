class User < ActiveRecord::Base
  acts_as_authentic do |u|
  end
end
