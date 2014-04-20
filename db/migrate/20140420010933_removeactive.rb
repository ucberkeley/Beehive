class Removeactive < ActiveRecord::Migration
  def up
    remove_column :jobs, :active
  end

  def down
  end
end
