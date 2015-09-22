class AddClassOfColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :class_of, :integer
  end
end
