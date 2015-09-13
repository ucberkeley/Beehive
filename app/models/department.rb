# == Schema Information
#
# Table name: departments
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  created_at :datetime
#  updated_at :datetime
#

class Department < ActiveRecord::Base

  has_many :jobs
  has_many :faculties

  class << self
    # Define methods like ".eecs"
    begin
      Department.all.each do |d|
        define_method d.name.underscore do
          d
        end rescue nil
      end
    rescue => e
    end
  end

end
