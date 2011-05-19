class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.float :price
      t.integer :quantity
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
