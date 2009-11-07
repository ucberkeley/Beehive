class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end
	
	create_table :categories_jobs, {:id=>false} do |t|
      t.references :category
	  t.references :job
    end
  end

  def self.down
    drop_table :categories
	drop_table :categories_jobs
  end
end
