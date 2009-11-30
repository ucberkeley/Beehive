class CreateProficiencies < ActiveRecord::Migration
  def self.up
    create_table :proficiencies do |t|
      t.references :proglang
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :proficiencies
  end
end
