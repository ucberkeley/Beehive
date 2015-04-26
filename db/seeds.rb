# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Create departments
[ ['Elec Eng & Comp Sci', 'EECS'] ].each do |name, abbrev|
  #Department.find_or_create_by_name_and_abbrev(name, abbrev)   # TODO: add abbrev
  Department.find_or_create_by(name: abbrev)
end

#   Development-specific seeds
if Rails.env == 'development' then
  [ ['Test Faculty', 'test@faculty.com']
  ].each do |name, email|
    f = Faculty.find_or_initialize_by_name_and_email(name, email)
    #f.department_id = Department.first  # TODO
    f.save
  end
end

