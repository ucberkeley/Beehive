class AddOpenFieldToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :open, :boolean, :default => 1
  end

  def self.down
    remove_column :jobs, :open
  end
end
