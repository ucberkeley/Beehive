class CreateJobAttribs < ActiveRecord::Migration
  def self.up
    create_table :job_attribs do |t|
      t.references :job
      t.references :attrib

      t.timestamps
    end
  end

  def self.down
    drop_table :job_attribs
  end
end
