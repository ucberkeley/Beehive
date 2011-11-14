class AddCompensationFieldToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :compensation, :string
  end

  def self.down
    remove_column :jobs, :compensation
  end
end
