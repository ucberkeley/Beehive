class RemoveReviews < ActiveRecord::Migration
  def self.up
    drop_table :reviews
  end

  def self.down
    create_table :reviews do |t|
      t.references :user
      t.text :body
      t.integer :rating

      t.timestamps
    end
  end
end
