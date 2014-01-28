require 'spec_helper'

describe AttribsHelper do
  before :each do
    @job = mock_model({
      :categories => ['signal processing', 'ai']
    })
  end

  describe "attrib_names_for_type" do
    it "should join without spaces" do
    end

    it "should join with spaces" do
    end
  end # attrib_names_for_type
end

