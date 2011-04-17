module ::ActiveRecord
  class << Migrator
    include WhatColumnMigrator
  end
end
