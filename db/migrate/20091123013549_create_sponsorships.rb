class CreateSponsorships < ActiveRecord::Migration
  def self.up
    create_table :sponsorships do |t|
      t.references :faculty
      t.references :job

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsorships
  end
end
