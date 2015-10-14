class SeedMajorsToMajorsTable < ActiveRecord::Migration
  def change
    YAML::load_file(File.join(__dir__, '../data/majors.yml')).each do |major|
      Major.create(name: major)
    end
  end
end
