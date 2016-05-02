namespace :job_status do
  desc "Closing past due jobs..."
  task :close => :environment do
    people = Hash.new
    Job.all.where.not(status: 1).each do |j|
      if j.user_id == nil
        j.update_column(:status, 1)
      elsif j.latest_start_date < (Date.today - 365)
        begin
          poster = User.find(j.user_id)
          if people[poster] == nil
            people[poster] = Array.new
          end
          people[poster].push(j)
          #j.update_column(:status, 1)
        rescue
          puts j.user_id
        end
      end
    end
    people.each do |k, v|
      # Do Stuff with |User, [Jobs]|
      v.each do |j|
        # Do Stuff with |Jobs|
      end
    end
  end

  desc "init job status..."
  task :init => :environment do
    Job.all.where(status: nil).each do |j|
      if j.latest_start_date < Time.now
        j.update_column(:status, 1)
      else
        j.update_column(:status, 0)
      end
    end
  end

  desc "Checking How Many Old Jobs..."
  task :count => :environment do
    count = 0
    Job.all.where.not(status: 1).each do |j|
      if j.latest_start_date < (Date.today - 365)
        count += 1
      end
    end
    p count
  end
end
