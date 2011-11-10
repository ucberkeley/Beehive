class AddInfoToPerson < ActiveRecord::Migration

  Columns = [
    [ :units,          :integer ],
    [ :free_hours,     :integer ],
    [ :research_blurb, :text    ],
    [ :experience,     :string, :limit => 255 ],
    [ :summer,         :boolean ],
    [ :url,            :string  ],
    [ :year,           :integer ]
  ]

  def self.up
    Columns.each do |c|
      field, type = c.slice(0,2)
      options = c.slice(2) || {}
      send :add_column, *[:users, field, type, options]
    end
  end

  def self.down
    Columns.each do |c|
      remove_column :users, c[0]
    end
  end
end
