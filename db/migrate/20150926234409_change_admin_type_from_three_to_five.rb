class ChangeAdminTypeFromThreeToFive < ActiveRecord::Migration
  def change
    User.where(:user_type => 3).update_all(:user_type => 5)
  end
end
