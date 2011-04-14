require 'test_helper'

class MigrationTest < ActiveSupport::TestCase
  
  def open_file(name)
    File.open(File.join(rails_root, "app", "models", name))
  end
  
  context "migrations" do
    
    should "run columnize after migrations if RAILS_ENV == 'development'" do
      WhatColumnMigrator.const_set("RAILS_ENV", 'development')        
      WhatColumn::Columnizer.any_instance.expects(:add_column_details_to_models).at_least_once
      ActiveRecord::Migrator.migrate("#{rails_root}/db/migrate")      
    end
        
    should "not run columnize after migrations if RAILS_ENV == 'test'" do
      WhatColumn::Columnizer.any_instance.expects(:add_column_details_to_models).never
      ActiveRecord::Migrator.migrate("#{rails_root}/db/migrate")
    end
    
  end
  
end