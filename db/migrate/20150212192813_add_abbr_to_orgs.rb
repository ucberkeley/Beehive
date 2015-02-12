class AddAbbrToOrgs < ActiveRecord::Migration
  def change
    add_column :orgs, :abbr, :string
  end
end
