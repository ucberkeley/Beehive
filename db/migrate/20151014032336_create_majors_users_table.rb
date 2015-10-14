class CreateMajorsUsersTable < ActiveRecord::Migration
  def change
    create_table :majors_users, id: false do |t|
      t.integer :user_id
      t.integer :major_id
    end
  end
end
