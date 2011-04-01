class CreateUserAttribs < ActiveRecord::Migration
  def self.up
    create_table :user_attribs do |t|
      t.references :user
      t.references :attrib

      t.timestamps
    end
  end

  def self.down
    drop_table :user_attribs
  end
end
