class CreateApplics < ActiveRecord::Migration
  def self.up
    create_table :applics do |t|
      t.references :job
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :applics
  end
end
