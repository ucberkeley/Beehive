
module UCB::LDAP
  ##
  # =UCB::LDAP::Person
  #
  # Class for accessing the People tree of the UCB LDAP directory.
  # 
  # You can search by specifying your own filter:
  # 
  #   e = Person.search(:filter => {:uid => 123})
  #   
  # Or you can use a convenience search method:
  # 
  #   e = Person.find_by_uid("123")
  #   
  # Access attributes as if they were instance methods:  
  # 
  #   e = Person.find_by_uid("123")
  #   
  #   e.givenname    #=> "John"
  #   e.sn           #=> "Doe"
  #   
  # Methods with friendly names are provided for accessing attribute values:
  # 
  #   e = Person.person_by_uid("123")
  #   
  #   e.firstname    #=> "John"
  #   e.lastname     #=> "Doe"
  # 
  # There are other convenience methods:
  # 
  #   e = Person.person_by_uid("123")
  #   
  #   e.affiliations        #=> ["EMPLOYEE-TYPE-STAFF"]
  #   e.employee?           #=> true
  #   e.employee_staff?     #=> true
  #   e.employee_academic?  #=> false
  #   e.student?            #=> false
  # 
  # == Other Parts of the Tree
  #
  # You can access other parts of the LDAP directory through Person
  # instances:
  #
  #   p = Person.find_by_uid("123")
  #
  #   p.org_node          #=> Org
  #   p.affiliations      #=> Array of Affiliation
  #   p.addresses         #=> Array of Address
  #   p.job_appointments  #=> Array of JobAppointment
  #   p.namespaces        #=> Array of Namespace
  #   p.student_terms     #=> Array of StudentTerm
  #
  # ==Attributes
  # 
  # See Ldap::Entry for general information on accessing attribute values.
  #
  class Person < Entry
    class RecordNotFound < StandardError; end
    
    include AffiliationMethods
    include GenericAttributes
    
    @entity_name = 'person'
    @tree_base = 'ou=people,dc=berkeley,dc=edu'
    
    class << self
      ##
      # Returns an instance of Person for given _uid_.
      #
      def find_by_uid(uid)
        uid = uid.to_s
        find_by_uids([uid]).first
      end
      alias :person_by_uid :find_by_uid  
      
      ##
      # Returns an +Array+ of Person for given _uids_.
      #
      def find_by_uids(uids)
        return [] if uids.size == 0
        filters = uids.map{|uid| Net::LDAP::Filter.eq("uid", uid)}
        search(:filter => self.combine_filters(filters, '|'))
      end
      alias :persons_by_uids :find_by_uids 

      ##
      # Exclude test entries from search results unless told otherwise.
      #
      def search(args) #:nodoc:
        results = super
        include_test_entries? ? results : results.reject { |person| person.test? }
      end

      ##
      # If <tt>true</tt> test entries are included in search results
      # (defalut is <tt>false</tt>).
      #
      def include_test_entries?
        @include_test_entries ? true : false
      end

      ##
      # Setter for include_test_entries?
      #
      def include_test_entries=(include_test_entries)
        @include_test_entries = include_test_entries
      end
    end

    
    def deptid
      berkeleyEduPrimaryDeptUnit
    end
    alias :dept_code :deptid
    
    def dept_name
      berkeleyEduUnitCalNetDeptName
    end
    
    ##
    # Returns +Array+ of JobAppointment for this Person.
    # Requires a bind with access to job appointments.
    # See UCB::LDAP.authenticate().
    #
    def job_appointments
      @job_appointments ||= JobAppointment.find_by_uid(uid)
    end
    
    ##
    # Returns +Array+ of StudentTerm for this Person.
    # Requires a bind with access to student terms.
    # See UCB::LDAP.authenticate().
    #
    def student_terms
      @student_terms ||= StudentTerm.find_by_uid(uid)
    end
    
    ##
    # Returns instance of UCB::LDAP::Org corresponding to 
    # primary department.
    #
    def org_node
      @org_node ||= UCB::LDAP::Org.find_by_ou(deptid)
    end
    
  end
end
