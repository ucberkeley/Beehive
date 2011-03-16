
module UCB
  module LDAP
    module Schema
      # = UCB::LDAP::SchemaAttribute
      # 
      # This class models <em>schema</em> information about an LDAP attribute.
      # 
      # This class is used internally by various UCB::LDAP classes.
      # Users of UCB::LDAP probably won't need to interact with this
      # class directly.
      #
      # The LDAP entity classes have access to their Attribute's.
      #
      #   uid_attr = UCB::LDAP::Person.attribute(:uid) # :symbol ok as attribute name
      #
      #   uid_attr.name             #=> 'uid'
      #   uid_attr.aliases          #=> ['userid']
      #   uid_attr.description      #=> 'Standard LDAP attribute type'
      #   uid_attr.multi_valued?    #=> true
      #   uid_attr.required?        #=> true
      #   uid_attr.type             #=> 'string'
      #
      #   uas_attr = UCB::LDAP::Person.attribute('berkeleyEduUasEligFlag') # case doesn't matter
      #
      #   uas_attr.name             #=> 'berkeleyEduUasEligFlag'
      #   uas_attr.aliases          #=> ['ucbvalidflag']
      #   uas_attr.description      #=> 'UAS Eligibility Flag'
      #   uas_attr.multi_valued?    #=> false
      #   uas_attr.required?        #=> false
      #   uas_attr.type             #=> 'boolean'
      #
      class Attribute
      
        # Constructor called by UCB::LDAP::Entry.set_schema_attributes().
        def initialize(args) #:nodoc:
          @name = args["name"]
          @type = args["syntax"]
          @aliases = args["aliases"] || []
          @description = args["description"]
          @required = args["required"]
          @multi_valued = args["multi"]
        end
        
        # Returns attribute name as found in the schema 
        def name
          @name
        end
        
        # Returns Array of aliases as found in schema.  Returns empty
        # Array ([]) if no aliases.
        #
        def aliases
          @aliases
        end
        
        # Returns (data) type.  Used by get_value() to cast value to correct Ruby type.
        #
        # Supported types and corresponding Ruby type:
        #
        #   * string      String
        #   * integer     Fixnum
        #   * boolean     TrueClass / FalseClass
        #   * timestamp   DateTime (convenience methods may return Date if attribute's semantics don't include time)
        #
        def type
          @type
        end
        
        # Returns attribute description.  Of limited value since all
        # standard LDAP attributes have a description of 
        # "Standard LDAP attribute type".
        def description
          @description
        end
        
        # Returns <tt>true</tt> if attribute is required, else <tt>false</tt>
        def required?
          @required
        end
        
        # Returns <tt>true</tt> if attribute is multi-valued, else <tt>false</tt>.
        # Multi-valued attribute values are returned as an Array.
        def multi_valued?
          @multi_valued
        end
        
        # Takes a value returned from an LDAP attribute (+Array+ of +String+)
        # and returns value with correct cardinality (array or scalar)
        # cast to correct #type.
        def get_value(array)
          if array.nil?
            return false if boolean?
            return [] if multi_valued?
            return nil
          end
          typed_array = apply_type_to_array(array)
          multi_valued? ? typed_array : typed_array.first
        end
        
        # Cast each element to correct type.
        def apply_type_to_array(array) #:nodoc:
          array.map{|scalar| apply_type_to_scalar scalar}
        end
        
        # Case element to correct type
        def apply_type_to_scalar(string) #:nodoc:
          return string if string?
          return string.to_i if integer?
          return %w{true 1}.include?(string) ? true : false if boolean?
          return UCB::LDAP.local_datetime_parse(string) if timestamp?
          raise "unknown type '#{type}' for attribute '#{name}'"
        end
        
        # Return <tt>true</tt> if attribute type is string.
        def string?
          type == "string"
        end
        
        # Return <tt>true</tt> if attribute type is integer.
        def integer?
          type == "integer"
        end
        
        # Return <tt>true</tt> if attribute type is boolean.
        def boolean?
          type == "boolean"
        end
        
        # Return <tt>true</tt> if attribute type is timestamp
        def timestamp?
          type == "timestamp" 
        end
        
        # Returns a value in LDAP attribute value format (+Array+ of +String+).
        def ldap_value(value)
          return nil if value.nil?
          return value.map{|v| ldap_value_stripped(v)} if value.instance_of?(Array)
          return [ldap_value_stripped(value)]
        end
        
        private 
        
        # Remove leading/trailing white-space and imbedded newlines.
        def ldap_value_stripped(s)
          s.to_s.strip.gsub(/\n/,"")
        end
        
      end
      
    end
  end 
end
