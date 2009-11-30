class CreateProglangs < ActiveRecord::Migration
  def self.up
    create_table :proglangs do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :proglangs
  end
end
