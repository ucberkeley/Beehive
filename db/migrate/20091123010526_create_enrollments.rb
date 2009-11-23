class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.string :grade
      t.string :semester
      t.references :course
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
  end
end
