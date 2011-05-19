require 'test_helper'

class WhatColumnTest < ActiveSupport::TestCase
  
  def setup
    @columnizer = WhatColumn::Columnizer.new
  end

  def open_file(name)
    File.open(File.join(rails_root, "app", "models", name))
  end

  context "before columnization" do
    should "not have name column detailed if not add_column_details_to_modelsd" do
      assert_no_match(/# name\s+: string/, open_file("user.rb").read)
    end    
  end

  context "decolumnizing" do
    setup do
      @columnizer.add_column_details_to_models
      @columnizer.remove_column_details_from_models
      @file = open_file("user.rb")
    end

    should "not display column details" do
      assert_no_match(/name\s+: string/, @file.read)      
    end

    should "not display footer" do
      assert_no_match(/#{WhatColumn::Columnizer::FOOTER}/, @file.read)      
    end

    should "not remove class information" do
      assert_match(/class User < ActiveRecord::Base/, @file.read)
    end
            
    should "not have extra line feed" do
      assert_no_match(/^\nclass User < ActiveRecord::Base/, @file.read)      
    end
  end
  
  context "columnizing a standard model" do
    setup do
      @file = open_file("user.rb")
      @columnizer.add_column_details_to_models
    end
    
    teardown do
      @columnizer.remove_column_details_from_models
    end

    should "have age column detailed" do
      assert_match(/age\s+: integer/, @file.read)
    end

    should "have name column detailed" do
      assert_match(/name\s+: string/, @file.read)
    end
    
    should "not write over code alredy in class" do      
      assert_match(/def name_and_age/, @file.read)      
    end
    
    should "add column details at the top of class" do
      assert_match(/class.*#{WhatColumn::Columnizer::HEADER}.*/, @file.read.delete("\n"))
    end
    
    should "add header to comments" do
      assert_match(/#{WhatColumn::Columnizer::HEADER}/, @file.read)
    end
    
    should "add footer to comments" do
      assert_match(/#{WhatColumn::Columnizer::FOOTER}/, @file.read)
    end
    
    should "only have the one columnization if columnizing twice" do
      @columnizer.add_column_details_to_models
      assert_no_match(/#{WhatColumn::Columnizer::FOOTER}.*#{WhatColumn::Columnizer::FOOTER}/, @file.read.delete("\n"))
    end
    
    should "justify the columns" do
      assert_match(/age        : integer/, @file.read)
    end
    
    should "add line feed before and after columns" do
      number_of_empty_lines = @file.readlines.select {|line| line == "\n"}.size
      assert_equal 2, number_of_empty_lines
    end

  end

  context "columnizing a model in a subfolder" do
    setup do
      @file = open_file("shop/product.rb")
      @columnizer.add_column_details_to_models
    end
    
    teardown do
      @columnizer.remove_column_details_from_models
    end

    should "have price column detailed" do
      assert_match(/price\s+: float/, @file.read)
    end

    should "have integer column detailed" do
      debugger
      assert_match(/quantity\s+: integer/, @file.read)
    end    
  end
  
  context "columnizing a file in a subfolder" do
    setup do
      @file = open_file("shop/product.rb")
      @columnizer.add_column_details_to_models
    end
    
    teardown do
      @columnizer.remove_column_details_from_models
    end

    should "have price column detailed" do
      assert_match(/price\s+: float/, @file.read)
    end

    should "have integer column detailed" do
      assert_match(/quantity\s+: integer/, @file.read)
    end    
  end
  
  context "columnizing an inherited model" do
    setup do
      @file = open_file("admin_user.rb")
      @columnizer.add_column_details_to_models
    end

    should "have name column detailed" do
      assert_match(/name\s+: string/, @file.read)
    end
  end
  
  context "columnizing an abstract model" do
    setup do
      @file = open_file("abstract_user.rb")
      @columnizer.add_column_details_to_models
    end

    should "not have any what column stuff" do
      assert_no_match(/#{WhatColumn::Columnizer::FOOTER}/, @file.read)
    end
  end
  
  context "columnizing a module" do
    setup do
      @file = open_file("user_methods.rb")
      @columnizer.add_column_details_to_models      
    end

    should "not have any what column stuff" do
      assert_no_match(/#{WhatColumn::Columnizer::FOOTER}/, @file.read)
    end
  end

  context "columnizing a class that's not an activerecord model" do
    setup do
      @file = open_file("authorizer.rb")
      @columnizer.add_column_details_to_models      
    end

    should "not have any what column stuff" do
      assert_no_match(/#{WhatColumn::Columnizer::FOOTER}/, @file.read)
    end
  end    
end