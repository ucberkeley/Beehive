module WhatColumnMigrator #:nodoc:
  
  def self.included(base)
    base.class_eval do
      if !base.method_defined?(:migrate_without_columnizer)
        alias_method_chain :migrate, :columnizer
      end
    end
  end

  def migrate_with_columnizer(*args)
    result_of_migrations = migrate_without_columnizer(*args)
    WhatColumn::Columnizer.new.add_column_details_to_models if RAILS_ENV == 'development'
    result_of_migrations
  end

end