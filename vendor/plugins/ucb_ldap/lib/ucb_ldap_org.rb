
module UCB
  module LDAP
    ##
    # =UCB::LDAP::Org
    #
    # Class for accessing the Org Unit tree of the UCB LDAP directory.
    # 
    # You can search by specifying your own filter:
    # 
    #   e = Org.search(:filter => 'ou=jkasd')
    #   
    # But most of the time you'll use the find_by_ou() method:
    # 
    #   e = Org.find_by_ou('jkasd')
    #   
    # Get attribute values as if the attribute names were instance methods.
    # Values returned reflect the cardinality and type as specified in the
    # LDAP schema.
    # 
    #   e = Org.find_by_ou('jkasd')
    #   
    #   e.ou                                 #=> ['JKASD']
    #   e.description                        #=> ['Application Services']
    #   e.berkeleyEduOrgUnitProcessUnitFlag  #=> true
    #   
    # Convenience methods are provided that have friendlier names
    # and return scalars for attributes the schema says are mulit-valued,
    # but in practice are single-valued:
    # 
    #   e = Org.find_by_ou('jkasd')
    #   
    #   e.deptid                      #=> 'JKASD'
    #   e.name                        #=> 'Application Services'
    #   e.processing_unit?            #=> true
    #
    # Other methods encapsulate common processing:
    #
    #   e.level                       #=> 4
    #   e.parent_node                 #=> #<UCB::LDAP::Org: ...>
    #   e.parent_node.deptid          #=> 'VRIST'
    #   e.child_nodes                 #=> [#<UCB::LDAP::Org: ..>, ...]
    #
    # 
    # You can retrieve people in a department.  This will be
    # an +Array+ of UCB::LDAP::Person.
    # 
    #   asd = Org.find_by_ou('jkasd')
    #   
    #   asd_staff = asd.persons       #=> [#<UCB::LDAP::Person: ...>, ...]
    #
    # === Getting a Node's Level "n" Code or Name
    # 
    # There are methods that will return the org code and org name
    # at a particular level.  They are implemented by method_missing
    # and so are not documented in the instance method section.
    #
    #   o = Org.find_by_ou('jkasd')
    #
    #   o.code          #=> 'JKASD'
    #   o.level         #=> 4
    #   o.level_4_code  #=> 'JKASD'
    #   o.level_3_name  #=> 'Info Services & Technology'
    #   o.level_2_code  #=> 'AVCIS'
    #   o.level_5_code  #=> nil
    #
    # == Dealing With the Entire Org Tree
    #
    # There are several class methods that simplify most operations
    # involving the entire org tree.
    #
    # === Org.all_nodes()
    #
    # Returns a +Hash+ of all org nodes whose keys are deptids
    # and whose values are corresponding Org instances.
    #
    #   # List all nodes alphabetically by department name
    #   
    #   nodes_by_name = Org.all_nodes.values.sort_by{|n| n.name.upcase}
    #   nodes_by_name.each do |n|
    #     puts "#{n.deptid} - #{n.name}"
    #   end 
    #
    # === Org.flattened_tree()
    #
    # Returns an +Array+ of all nodes in hierarchy order.
    # 
    #   UCB::LDAP::Org.flattened_tree.each do |node|
    #     puts "#{node.level} #{node.deptid} - #{node.name}"
    #   end
    #   
    # Produces:
    # 
    #   1 UCBKL - UC Berkeley Campus
    #   2 AVCIS - Information Sys & Technology
    #   3 VRIST - Info Systems & Technology
    #   4 JFAVC - Office of the CIO
    #   5 JFADM - Assoc VC Off General Ops
    #   4 JGMIP - Museum Informatics Project
    #   4 JHSSC - Social Sci Computing Lab    
    #   etc.
    #   
    # === Org.root_node()
    #
    # Returns the root node in the Org Tree.
    # 
    # By recursing down child_nodes you can access the entire
    # org tree:
    # 
    #   # display deptid, name and children recursively
    #   def display_node(node)
    #     indent = "  " * (node.level - 1)
    #     puts "#{indent} #{node.deptid} - #{node.name}"
    #     node.child_nodes.each{|child| display_node(child)}
    #   end
    #  
    #   # start at root node
    #   display_node(Org.root_node)
    #
    # == Caching of Search Results
    # 
    # Calls to any of the following class methods automatically cache
    # the entire Org tree:
    # 
    # * all_nodes()
    # * flattened_tree()
    # * root_node()
    #
    # Subsequent calls to any of these methods return the results from
    # cache and don't require another LDAP query.
    #
    # Subsequent calls to find_by_ou() are done
    # against the local cache.  Searches done via the #search()
    # method do <em>not</em> use the local cache.
    #
    # Force loading of the cache by calling load_all_nodes().
    #
    class Org < Entry
      @entity_name = "org"
      @tree_base = 'ou=org units,dc=berkeley,dc=edu'
      
      ##
      # Returns <tt>Array</tt> of child nodes, each an instance of Org,
      # sorted by department id.
      #
      def child_nodes()
        @sorted_child_nodes ||= load_child_nodes.sort_by { |node| node.deptid }
      end
      
      ##
      # Returns the department id.
      #
      def deptid()
        ou.first
      end
      alias :code :deptid

      ##
      # Returns the entry's level in the Org Tree.
      #
      def level()
        @level ||= parent_deptids.size + 1
      end
      
      ##
      # Returns the department name.
      #
      def name()
        description.first
      end

      ##
      # Returns parent node's deptid
      #
      def parent_deptid()
        @parent_deptid ||= parent_deptids.last
      end

      ##
      # Returns Array of parent deptids.
      # 
      # Highest level is first element; immediate parent is last element.
      #
      def parent_deptids()
        return @parent_deptids if @parent_deptids
        hierarchy_array = berkeleyEduOrgUnitHierarchyString.split("-")
        hierarchy_array.pop  # last element is deptid ... toss it
        @parent_deptids = hierarchy_array
      end

      ##
      # Returns +true+ if org is a processing unit.
      #
      def processing_unit?()
        berkeleyEduOrgUnitProcessUnitFlag
      end

      ##
      # Return parent node which is an instance of Org.
      #
      def parent_node()
        return nil if parent_deptids.size == 0
        @parent_node ||= UCB::LDAP::Org.find_by_ou parent_deptid
      end

      ##
      # Returns <tt>Array</tt> of parent nodes which are instances of Org.
      #
      def parent_nodes()
        @parent_nodes ||= parent_deptids.map { |deptid| UCB::LDAP::Org.find_by_ou(deptid) }
      end

      ##
      # Support for method names like level_2_code, level_2_name
      #
      def method_missing(method, *args) #:nodoc:
        return code_or_name_at_level($1, $2) if method.to_s =~ /^level_([1-6])_(code|name)$/
        super
      end

      ##
      # Return the level "n" code or name.  Returns nil if level > self.level.
      # Called from method_messing().
      #
      def code_or_name_at_level(level, code_or_name) #:nodoc:
        return (code_or_name == 'code' ? code : name) if level.to_i == self.level
        element = level.to_i - 1
        return parent_deptids[element] if code_or_name == 'code'
        parent_nodes[element] && parent_nodes[element].name
      end
      
      ##
      # Returns <tt>Array</tt> of UCB::LDAP::Person instances for each person
      # in the org node.
      #
      def persons()
        @persons ||= UCB::LDAP::Person.search(:filter => {:departmentnumber => ou})
      end
      alias :people :persons
      
      #---
      # Must be public for load_all_nodes()
      def init_child_nodes() #:nodoc:
        @child_nodes = []
      end

      #---
      # Add node to child node array.
      def push_child_node(child_node)#:nodoc:
        @child_nodes ||= []
        unless @child_nodes.find { |n| n.ou == child_node.ou }
          @child_nodes.push(child_node)
        end
      end

      private unless $TESTING
      
      ##
      # Loads child nodes for individual node.  If all_nodes_nodes()
      # has been called, child nodes are all loaded/calculated.
      #
      def load_child_nodes
        @child_nodes ||= UCB::LDAP::Org.search(:scope => 1, :base => dn, :filter => {:ou => '*'})
      end
      
      ##
      # Access to instance variables for testing
      #
      def child_nodes_i()
        @child_nodes
      end


      class << self
        public
        
        ##
        # Rebuild the org tree using fresh data from ldap
        #
        def rebuild_node_cache
          clear_all_nodes
          load_all_nodes
        end
        
        ##
        # Returns a +Hash+ of all org nodes whose keys are deptids
        # and whose values are corresponding Org instances.
        #
        def all_nodes()
          @all_nodes ||= load_all_nodes
        end
        
        ##
        # Returns an instance of Org for the matching _ou_.
        #
        def find_by_ou(ou)
          find_by_ou_from_cache(ou) || search(:filter => {:ou => ou}).first
        end

        ##
        # for backwards compatibility -- should be deprecated
        #
        alias :org_by_ou :find_by_ou

        ##
        # Returns an +Array+ of all nodes in hierarchy order.  If you call
        # with <tt>:level</tt> option, only nodes down to that level are
        # returned.
        #
        #   Org.flattened_tree               # returns all nodes
        #   Org.flattened_tree(:level => 3)  # returns down to level 3
        #
        def flattened_tree(options={})
          @flattened_tree ||= build_flattened_tree
          return @flattened_tree unless options[:level]
          @flattened_tree.reject { |o| o.level > options[:level] }
        end
        
        ##
        # Loads all org nodes and stores them in Hash returned by all_nodes().
        # Subsequent calls to find_by_ou() will be from cache and not 
        # require a trip to the LDAP server.
        #
        def load_all_nodes()
          return @all_nodes if @all_nodes
          return nodes_from_test_cache if $TESTING && @test_node_cache
          
          bind_for_whole_tree
          @all_nodes = search.inject({}) do |accum, org|            
            accum[org.deptid] = org if org.deptid != "Org Units"
            accum
          end
          
          build_test_node_cache if $TESTING
          calculate_all_child_nodes
          UCB::LDAP.clear_authentication
          @all_nodes
        end
        
        ##
        # Returns the root node in the Org Tree.
        #
        def root_node()
          load_all_nodes
          find_by_ou('UCBKL')
        end

        private unless $TESTING

        ##
        # Use bind that allows for retreiving entire org tree in one search.
        #
        def bind_for_whole_tree()
          username = "uid=istaswa-ruby,ou=applications,dc=berkeley,dc=edu"
          password = "t00lBox12"
          UCB::LDAP.authenticate(username, password)
        end
        
        ##
        # Returns an instance of Org from the local if cache exists, else +nil+.
        #
        def find_by_ou_from_cache(ou) #:nodoc:
          return nil if ou.nil?
          return nil unless @all_nodes
          @all_nodes[ou.upcase]
        end
        
        ##
        # Returns cached nodes if we are testing and have already 
        # fetched all the nodes.
        #
        def nodes_from_test_cache()
          @all_nodes = {}
          @test_node_cache.each { |k, v| @all_nodes[k] = v.clone }
          calculate_all_child_nodes
          @all_nodes
        end
        
        ##
        # Build cache of all nodes.  Only used during testing.
        #
        def build_test_node_cache()
          @test_node_cache = {}
          @all_nodes.each { |k, v| @test_node_cache[k] = v.clone }
        end
        
        ##
        # Will calculate child_nodes for every node.
        #
        def calculate_all_child_nodes()
          @all_nodes.values.each { |node| node.init_child_nodes }
          @all_nodes.values.each do |node|
            next if node.deptid == 'UCBKL' || node.deptid == "Org Units"
            parent_node = find_by_ou_from_cache(node.parent_deptids.last)
            parent_node.push_child_node(node)
          end
        end
        
        ##
        # Builds flattened tree.  See RDoc for flattened_tree() for details.
        #
        def build_flattened_tree()
          load_all_nodes
          @flattened_tree = []
          add_to_flattened_tree UCB::LDAP::Org.root_node
          @flattened_tree
        end
        
        ##
        # Adds a node and its children to @flattened_tree.
        #
        def add_to_flattened_tree(node)
          @flattened_tree.push node
          node.child_nodes.each { |child| add_to_flattened_tree child }
        end
      
        # Direct access to instance variables for unit testing
        
        def all_nodes_i()
          @all_nodes
        end
        
        def clear_all_nodes()
          @all_nodes = nil
        end
      end
    end
  end 
end
