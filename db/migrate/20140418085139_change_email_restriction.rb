class ChangeEmailRestriction < ActiveRecord::Migration
  def up
    change_column :users, :email, :string, :null => true
  end

  def down
  end
end
