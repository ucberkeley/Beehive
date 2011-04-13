class SpecHelperMethods
  def self.stub_cas_ok  
          # means either it logged in or something else happened that 
          # the plugin deemed okay
    CASClient::Frameworks::Rails::Filter.stub(:filter).and_return(true)
  end
  
end
