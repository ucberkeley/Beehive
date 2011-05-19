class AddInfoToApplics < ActiveRecord::Migration
  def self.up
    add_column :applics, :message, :text
    add_column :applics, :resume_id, :integer
    add_column :applics, :transcript_id, :integer
  end

  def self.down
    remove_column :applics, :transcript
    remove_column :applics, :resume
    remove_column :applics, :message
  end
end
