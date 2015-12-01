FactoryGirl.define do
	factory :user do |u|
		u.name "bingbong"
		u.login "abc"
		u.email "abc@hotmail.com"
		u.user_type 5
		u.id 1
		u.persistence_token "a"
		u.single_access_token "a"
		u.perishable_token "a"
	end
end