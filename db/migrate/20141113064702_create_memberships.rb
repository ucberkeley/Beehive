class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :org
      t.references :user

      t.timestamps
    end
    add_index :memberships, :org_id
    add_index :memberships, :user_id
  end
end
