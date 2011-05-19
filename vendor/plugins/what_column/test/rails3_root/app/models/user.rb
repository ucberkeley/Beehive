class User < ActiveRecord::Base
  
  class MyError < Exception; end
  
  def name_and_age
    "#{name} and #{age}"
  end
end
