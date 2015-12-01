require 'date'

FactoryGirl.define do
	factory :job do |j|
		j.title "beehive"
		j.project_type 1
		j.department_id 1
		j.desc "make website"
		j.earliest_start_date DateTime.new(2000,1,1)
		j.latest_start_date DateTime.new(3000,1,1)
		j.end_date DateTime.new(4000,1,1)
	end

	factory :latest_lessthan_earliest, parent: :job do |j|
		j.earliest_start_date DateTime.new(2000,1,1)
		j.latest_start_date DateTime.new(1900,1,1)
	end

	factory :end_lessthan_latest, parent: :job do |j|
		j.latest_start_date DateTime.new(2000,1,1)
		j.end_date DateTime.new(1900,1,1)
	end

end