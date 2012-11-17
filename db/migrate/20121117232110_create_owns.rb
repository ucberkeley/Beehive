class CreateOwns < ActiveRecord::Migration
  def self.up
    create_table :owns do |t|
      t.references :job
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :owns
  end
end
