class CreateAttribs < ActiveRecord::Migration
  def self.up
    create_table :attribs do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :attribs
  end
end
