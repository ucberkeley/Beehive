class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.references :category
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :interests
  end
end
