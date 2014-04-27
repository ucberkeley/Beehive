class RemoveOpen < ActiveRecord::Migration
  def up
    remove_column :jobs, :open
  end

  def down
  end
end
