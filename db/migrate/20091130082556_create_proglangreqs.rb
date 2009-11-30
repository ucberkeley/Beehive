class CreateProglangreqs < ActiveRecord::Migration
  def self.up
    create_table :proglangreqs do |t|
      t.references :job
      t.references :proglang

      t.timestamps
    end
  end

  def self.down
    drop_table :proglangreqs
  end
end
