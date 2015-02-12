class AddAColumnToApplics < ActiveRecord::Migration
  def up
  	add_column :applics, :applied, :boolean
  end

  def down
  	remove_column :applics, applics, :boolean
  end
end
