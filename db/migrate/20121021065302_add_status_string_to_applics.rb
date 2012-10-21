class AddStatusStringToApplics < ActiveRecord::Migration
  def self.up
    add_column :applics, :status, :string, {:default => "undecided"}
  end

  def self.down
    remove_column :applics, :status
  end
end
