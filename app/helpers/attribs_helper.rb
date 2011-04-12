module AttribsHelper
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
end
