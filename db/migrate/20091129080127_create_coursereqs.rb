class CreateCoursereqs < ActiveRecord::Migration
  def self.up
    create_table :coursereqs do |t|
      t.references :course
      t.references :job

      t.timestamps
    end
  end

  def self.down
    drop_table :coursereqs
  end
end
