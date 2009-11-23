class AddFacultiesToJob < ActiveRecord::Migration
  def self.up
      create_table :sponsors do |t|
		t.references :faculty
		t.references :job
		t.timestamps
	  end
  end

  def self.down
	drop_table :sponsors
  end
end
