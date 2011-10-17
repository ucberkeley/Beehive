namespace :import do

  desc "Import faculty names and emails into the database"
  task :faculty => :environment do
    require 'faculty_importer'
    puts 'Loading...'
    fi = FacultyImporter.new
    fi.save!
  end

end
