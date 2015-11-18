class ChangeMajorToString < ActiveRecord::Migration
  def change
    remove_column :users, :major_code
    add_column :users, :major_code, :string
  end
end
