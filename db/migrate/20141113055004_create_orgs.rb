class CreateOrgs < ActiveRecord::Migration
  def change
    create_table :orgs do |t|
      t.string :name
      t.text :desc

      t.timestamps
    end
  end
end
