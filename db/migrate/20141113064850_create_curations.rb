class CreateCurations < ActiveRecord::Migration
  def change
    create_table :curations do |t|
      t.references :job
      t.references :org
      t.references :user

      t.timestamps
    end
    add_index :curations, :job_id
    add_index :curations, :org_id
    add_index :curations, :user_id
  end
end
