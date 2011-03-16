module UCB
  module LDAP
    ##
    # = UCB::LDAP::Entry
    # 
    # Abstract class representing an entry in the UCB LDAP directory.  You
    # won't ever deal with Entry instances, but instead instances of Entry
    # sub-classes.
    # 
    # == Accessing LDAP Attributes
    # 
    # You will not see the attributes documented in the
    # instance method section of the documentation for Entry sub-classes,
    # even though you can access them as
    # if they _were_ instance methods.
    #
    #   person = Person.find_by_uid("123")  #=> #<UCB::LDAP::Person ..>
    #   people.givenname                    #=> ["John"]
    #   
    # Entry sub-classes may have convenience methods that
    # allow for accessing attributes by friendly names:
    # 
    #   person = Person.person_by_uid("123")  #=> #<UCB::LDAP::Person ..>
    #   person.firstname                      #=> "John"
    #
    # See the sub-class documentation for specifics.
    # 
    # ===Single- / Multi-Value Attributes
    #
    # Attribute values are returned as arrays or scalars based on how 
    # they are defined in the LDAP schema.  
    #
    # Entry subclasses may have convenience
    # methods that return scalars even though the schema defines
    # the unerlying attribute as multi-valued becuase in practice the are single-valued.
    # 
    # === Attribute Types
    # 
    # Attribute values are stored as arrays of strings in LDAP, but 
    # when accessed through Entry sub-class methods are returned
    # cast to their Ruby type as defined in the schema.  Types are one of:
    #
    # * string
    # * integer
    # * boolean
    # * datetime
    #
    # === Missing Attribute Values
    # 
    # If an attribute value is not present, the value returned depends on
    # type and multi/single value field:
    #
    # * empty multi-valued attributes return an empty array ([])
    # * empty booleans return +false+
    # * everything else returns +nil+ if empty
    #
    # Attempting to get or set an attribute value for an invalid attriubte name
    # will raise a BadAttributeNameException.
    #
    # == Updating LDAP
    #
    # If your bind has privleges for updating the directory you can update
    # the directory using methods of Entry sub-classes.  Make sure you call
    # UCB::LDAP.authenticate before calling any update methods.
    #
    # There are three pairs of update methods that behave like Rails ActiveRecord
    # methods of the same name.  These methods are fairly thin wrappers around
    # standard LDAP update commands.
    #
    # The "bang" methods (those ending in "!") differ from their bangless 
    # counterparts in that the bang methods raise +DirectoryNotUpdatedException+
    # on failure, while the bangless return +false+.
    #
    # * #create/#create! - class methods that do LDAP add
    # * #update_attributes/#update_attributes! - instance methods that do LDAP modify
    # * #delete/#delete! - instance methods that do LDAP delete
    #
    class Entry
      
      ##
      # Returns new instance of UCB::LDAP::Entry.  The argument
      # net_ldap_entry is an instance of Net::LDAP::Entry.
      # 
      # You should not need to create any UCB::LDAP::Entry instances;
      # they are created by calls to UCB::LDAP.search and friends.
      #
      def initialize(net_ldap_entry) #:nodoc:
        # Don't store Net::LDAP entry in object since it uses the block
        # initialization method of Hash which can't be marshalled ... this 
        # means it can't be stored in a Rails session.
        @attributes = {}
        net_ldap_entry.each do |attr, value|
          @attributes[canonical(attr)] = value.map{|v| v.dup}
        end
      end
      
      ##
      # <tt>Hash</tt> of attributes returned from underlying NET::LDAP::Entry
      # instance.  Hash keys are #canonical attribute names, hash values are attribute
      # values <em>as returned from LDAP</em>, i.e. arrays.
      # 
      # You should most likely be referencing attributes as if they were
      # instance methods rather than directly through this method.  See top of
      # this document.
      #
      def attributes
        @attributes
      end
      
      ##
      # Returns the value of the <em>Distinguished Name</em> attribute.
      #
      def dn
        attributes[canonical(:dn)]
      end
    
      def canonical(string_or_symbol) #:nodoc:
        self.class.canonical(string_or_symbol)
      end
      
      ##
      # Update an existing entry.  Returns entry if successful else false.
      #
      #   attrs = {:attr1 => "new_v1", :attr2 => "new_v2"}
      #   entry.update_attributes(attrs)
      #
      def update_attributes(attrs)
        attrs.each{|k, v| self.send("#{k}=", v)}        
        if modify()
          @attributes = self.class.find_by_dn(dn).attributes.dup
          return true
        end
        false
      end

      ##
      # Same as #update_attributes(), but raises DirectoryNotUpdated on failure.
      #
      def update_attributes!(attrs)
        update_attributes(attrs) || raise(DirectoryNotUpdatedException)
      end

      ##
      # Delete entry.  Returns +true+ on sucess, +false+ on failure.
      #
      def delete
        net_ldap.delete(:dn => dn)
      end

      ##
      # Same as #delete() except raises DirectoryNotUpdated on failure.
      #
      def delete!
        delete || raise(DirectoryNotUpdatedException)
      end
      
      def net_ldap
        self.class.net_ldap
      end
      
      
      private unless $TESTING
      
      ##
      # Used to get/set attribute values.
      #
      # If we can't make an attribute name out of method, let
      # regular method_missing() handle it.
      #
      def method_missing(method, *args) #:nodoc:
        setter_method?(method) ? value_setter(method, *args) : value_getter(method)
      rescue BadAttributeNameException
        return super
      end

      ##
      # Returns +true+ if _method_ is a "setter", i.e., ends in "=".
      #
      def setter_method?(method)
        method.to_s[-1, 1] == "="
      end
      
      ##
      # Called by method_missing() to get an attribute value.
      #
      def value_getter(method)
        schema_attribute = self.class.schema_attribute(method)
        raw_value = attributes[canonical(schema_attribute.name)]
        schema_attribute.get_value(raw_value)
      end
      
      ##
      # Called by method_missing() to set an attribute value.
      #
      def value_setter(method, *args)
        schema_attribute = self.class.schema_attribute(method.to_s.chop)
        attr_key = canonical(schema_attribute.name)
        assigned_attributes[attr_key] = schema_attribute.ldap_value(args[0])
      end
    
      def assigned_attributes
        @assigned_attributes ||= {}
      end
    
      def modify_operations
        ops = []
        assigned_attributes.keys.sort_by{|k| k.to_s}.each do |key|
          value = assigned_attributes[key]
          op = value.nil? ? :delete : :replace
          ops << [op, key, value]
        end
        ops
      end
    
      def modify()
        if UCB::LDAP.net_ldap.modify(:dn => dn, :operations => modify_operations)
          @assigned_attributes = nil
          return true
        end
        false
      end

      # Class methods
      class << self
        
        public
        
        # Creates and returns new entry.  Returns +false+ if unsuccessful.
        # Sets :objectclass key of <em>args[:attributes]</em> to 
        # object_classes read from schema.
        #
        #   dn = "uid=999999,ou=people,dc=example,dc=com"
        #   attr = {
        #     :uid => "999999",
        #     :mail => "gsmith@example.com"
        #   }
        #   
        #   EntrySubClass.create(:dn => dn, :attributes => attr)  #=> #<UCB::LDAP::EntrySubClass ..>
        #
        # Caller is responsible for setting :dn and :attributes correctly,
        # as well as any other validation.
        #
        def create(args)
          args[:attributes][:objectclass] = object_classes
          result = net_ldap.add(args)
          result or return false
          find_by_dn(args[:dn])
        end
        
        ##
        # Returns entry whose distinguised name is _dn_.
        def find_by_dn(dn)
          search(
            :base => dn,
            :scope => Net::LDAP::SearchScope_BaseObject,
            :filter => "objectClass=*"
          ).first
        end

        ##
        # Same as #create(), but raises DirectoryNotUpdated on failure.
        def create!(args)
          create(args) || raise(DirectoryNotUpdatedException)          
        end

        ##
        # Returns a new Net::LDAP::Filter that is the result of combining
        # <em>filters</em> using <em>operator</em> (<em>filters</em> is 
        # an +Array+ of Net::LDAP::Filter).
        #
        # See Net::LDAP#& and Net::LDAP#| for details.
        #
        #   f1 = Net::LDAP::Filter.eq("lastname", "hansen")
        #   f2 = Net::LDAP::Filter.eq("firstname", "steven")
        #   
        #   combine_filters([f1, f2])      # same as: f1 & f2
        #   combine_filters([f1, f2], '|') # same as: f1 | f2
        #
        def combine_filters(filters, operator = '&')
          filters.inject{|accum, filter| accum.send(operator, filter)}
        end
        
        ##
        # Returns Net::LDAP::Filter.  Allows for <em>filter</em> to
        # be a +Hash+ of :key => value.  Filters are combined with "&".
        #
        #   UCB::LDAP::Entry.make_search_filter(:uid => '123') 
        #   UCB::LDAP::Entry.make_search_filter(:a1 => v1, :a2 => v2)
        #
        def make_search_filter(filter)
          return filter if filter.instance_of?  Net::LDAP::Filter
          return filter if filter.instance_of?  String
          
          filters = []
          # sort so result is predictable for unit test
          filter.keys.sort_by { |symbol| "#{symbol}" }.each do |attr|
            filters << Net::LDAP::Filter.eq("#{attr}", "#{filter[attr]}")
          end
          combine_filters(filters, "&")
        end
        
        ##
        # Returns +Array+ of object classes making up this type of LDAP entity.
        def object_classes
          @object_classes ||= UCB::LDAP::Schema.schema_hash[entity_name]["objectClasses"]
        end
        
        def unique_object_class
          @unique_object_class ||= UCB::LDAP::Schema.schema_hash[entity_name]["uniqueObjectClass"]
        end
        
        ##
        # returns an Array of symbols where each symbol is the name of
        # a required attribute for the Entry
        def required_attributes
          required_schema_attributes.keys
        end
        
        ##
        # returns Hash of SchemaAttribute objects that are required
        # for the Entry.  Each SchemaAttribute object is keyed to the
        # attribute's name.
        #
        # Note: required_schema_attributes will not return aliases, it
        # only returns the original attributes
        #
        # Example:
        #  Person.required_schema_attribues[:cn]
        #  => <UCB::LDAP::Schema::Attribute:0x11c6b68>
        #
        def required_schema_attributes
          required_atts = schema_attributes_hash.reject { |key, value| !value.required? }
          required_atts.reject do |key, value|
            aliases = value.aliases.map { |a| canonical(a) }
            aliases.include?(key)
          end
        end

        ##
        # Returns an +Array+ of Schema::Attribute for the entity.
        #
        def schema_attributes_array
          @schema_attributes_array || set_schema_attributes
          @schema_attributes_array
        end

        ##
        # Returns as +Hash+ whose keys are the canonical attribute names
        # and whose values are the corresponding Schema::Attributes.
        #
        def schema_attributes_hash
          @schema_attributes_hash || set_schema_attributes
          @schema_attributes_hash
        end
        
        def schema_attribute(attribute_name)
          schema_attributes_hash[canonical(attribute_name)] ||
            raise(BadAttributeNameException, "'#{attribute_name}' is not a recognized attribute name")
        end

        ##
        # Returns Array of UCB::LDAP::Entry for entries matching _args_.
        # When called from a subclass, returns Array of subclass instances.
        #
        # See Net::LDAP::search for more information on _args_.
        #
        # Most common arguments are <tt>:base</tt> and <tt>:filter</tt>.
        # Search methods of subclasses have default <tt>:base</tt> that
        # can be overriden.
        # 
        # See make_search_filter for <tt>:filter</tt> options.
        # 
        #   base = "ou=people,dc=berkeley,dc=edu"
        #   entries = UCB::LDAP::Entry.search(:base => base, :filter => {:uid => '123'})
        #   entries = UCB::LDAP::Entry.search(:base => base, :filter => {:sn => 'Doe', :givenname => 'John'}
        #
        def search(args={})
          args = args.dup
          args[:base] ||= tree_base
          args[:filter] = make_search_filter args[:filter] if args[:filter]
          
          results = []
          net_ldap.search(args) do |entry|
            results << new(entry)
          end
          results
        end

        ##
        # Returns the canonical representation of a symbol or string so
        # we can look up attributes in a number of ways.
        #
        def canonical(string_or_symbol)
          string_or_symbol.to_s.downcase.to_sym
        end
        
        ##
        # Returns underlying Net::LDAP instance.
        #
        def net_ldap #:nodoc:
          UCB::LDAP.net_ldap
        end

        private unless $TESTING
        
        ##
        # Schema entity name.  Set in each subclass.
        #
        def entity_name
          @entity_name
        end
        
        ##
        # Want an array of Schema::Attributes as well as a hash
        # of all possible variations on a name pointing to correct array element.
        #
        def set_schema_attributes
          @schema_attributes_array = []
          @schema_attributes_hash = {}
          UCB::LDAP::Schema.schema_hash[entity_name]["attributes"].each do |k, v|
            sa = UCB::LDAP::Schema::Attribute.new(v.merge("name" => k))
            @schema_attributes_array << sa
            [sa.name, sa.aliases].flatten.each do |name|
              @schema_attributes_hash[canonical(name)] = sa
            end
          end
        rescue
          raise "Error loading schema attributes for entity_name '#{entity_name}'"
        end
        
        ##
        # Returns tree base for LDAP searches.  Subclasses each have
        # their own value.
        # 
        # Can be overridden in #search by passing in a <tt>:base</tt> parm.
        ##
        def tree_base
          @tree_base
        end
        
        def tree_base=(tree_base)
          @tree_base = tree_base
        end
        
      end  # end of class methods
    end
  end 
end
