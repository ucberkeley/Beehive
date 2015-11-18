class AddMajorField < ActiveRecord::Migration
  def change
    add_column :users, :major_code, :int
  end
end
