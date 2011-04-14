require Rails.root.join("config", "environment")

namespace :what_column do
  desc "Add column detail comment block to your model files"
  task :add do
    WhatColumn::Columnizer.new.add_column_details_to_models
  end

  desc "Remove column detail comment block from model files (if it exists)"
  task :remove do
    WhatColumn::Columnizer.new.remove_column_details_from_models
  end
end