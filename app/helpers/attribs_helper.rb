module AttribsHelper
  # Returns a string representing the values for all
  # the attribs with this name.
  def attrib_values_for_name(attrib_name, add_spaces = false)
    attrib_values = ''
    (attribs.select {|a| a.name == attrib_name}).each do |attrib|
      attrib_values << attrib.value + ','
      if add_spaces: attrib_values << ' ' end
    end
    
    # lop off extra ',' or ', ' at the end
  	if add_spaces
  	  return attrib_values[0..(attrib_values.length - 3)]
	  else
    	return attrib_values[0..(attrib_values.length - 2)]
  	end
  end
  
  # Helper method invoked by JobController's and UserController's
  # update and create. Updates the attribs of the job with the
  # stuff in params.
  def update_attribs(params)
    
    # Attribs logic. Gets the attribs from the params and finds or 
    # creates them appropriately.

    self.attribs = []
    
    Attrib.get_attrib_names.each do |attrib_name|

      # What was typed into the box. May include commas and spaces.
      raw_attrib_value = params['attrib_' + attrib_name]
      
      # If left blank, we don't want to create "" attribs.
      if raw_attrib_value.present?
        raw_attrib_value.split(',').uniq.each do |val_before_fmt|
          
          # Avoid ", , , ," situations
          if val_before_fmt.present?
            
            # Remove leading/trailing whitespace
            val = val_before_fmt.strip
            
            # HACK: We want to remove spaces and use uppercase for courses only
            # and capitalize programming languages only.
            if attrib_name == 'course'
              val = val.upcase.gsub(/ /, '')
            elsif attrib_name == 'programming language'
              val = val.capitalize
            else
              val = val.downcase
            end
            
            the_attrib = Attrib.find_or_create_by_name_and_value(attrib_name, val)

            self.attribs << the_attrib unless self.attribs.include?(the_attrib)

          end
        end
      end
    end
    
  end
  
  # Helper method used by edit and show methods in UserController and 
  # JobController to prepare the params hash by putting in the attribs.
  def prepare_attribs_in_params(obj)
  
    # Attribs logic. Puts the attribs in the params so that 
    # the user's edit profile form displays existing attribs.
    Attrib.get_attrib_names.each do |attrib_name|
      params['attrib_' + attrib_name] = obj.attrib_values_for_name(attrib_name, true)
    end
  end
end
