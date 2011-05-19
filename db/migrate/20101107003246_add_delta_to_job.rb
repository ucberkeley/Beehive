class AddDeltaToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :jobs, :delta
  end
end
