
module UCB
  module LDAP
    # = UCB::LDAP::Affiliation
    # 
    # This class models a persons affiliate entries in the UCB LDAP directory.
    #
    #   affiliations = Affiliation.find_by_uid("1234")  #=> [#<UCB::LDAP::Affiliation: ...>, ...]
    #
    # Affiliation are usually loaded through a Person instance:
    #
    #   p = Person.find_by_uid("1234")    #=> #<UCB::LDAP::Person: ...>
    #   affs = p.affiliations        #=> [#<UCB::LDAP::Affiliation: ...>, ...]
    #
    # == Note on Binds
    # 
    # You must have a privileged bind and pass your credentials to UCB::LDAP.authenticate()
    # before performing your Affiliation search.
    #
    class Affiliation < Entry
      @entity_name = 'personAffiliateAffiliation'

      def create_datetime
        berkeleyEduAffCreateDate
      end
      
      def expired_by
        berkeleyEduAffExpBy
      end
      
      def expiration_date
         UCB::LDAP.local_date_parse(berkeleyEduAffExpDate)
      end
      
      def affiliate_id
        berkeleyEduAffID.first
      end
      
      def affiliate_type
        berkeleyEduAffType
      end

      def first_name
        givenName.first
      end
      
      def middle_name
        berkeleyEduMiddleName
      end
      
      def last_name
        sn.first
      end
      
      def modified_by
        berkeleyEduModifiedBy
      end
      
      def source
        berkeleyEduPersonAffiliateSource
      end
      
      def dept_code
        departmentNumber.first
      end
      
      def dept_name
        berkeleyEduUnitCalNetDeptName
      end
      
      class << self
        # Returns an Array of Affiliation for <tt>uid</tt>.
        # Returns an empty Array ([]) if nothing is found.  
        #
        def find_by_uid(uid)
          base = "uid=#{uid},ou=people,dc=berkeley,dc=edu"
          filter = Net::LDAP::Filter.eq("objectclass", 'berkeleyEduPersonAffiliate')
          search(:base => base, :filter => filter)
        end
         
      end
    end
  end
end