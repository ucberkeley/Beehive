
module UCB
  module LDAP
    # = UCB::LDAP::Address
    # 
    # This class models a person address instance in the UCB LDAP directory.
    #
    #   a = Address.find_by_uid("1234")       #=> [#<UCB::LDAP::Address: ...>, ...]
    #
    # Addresses are usually loaded through a Person instance:
    #
    #   p = Person.find_by_uid("1234")    #=> #<UCB::LDAP::Person: ...>
    #   addrs = p.addresses               #=> [#<UCB::LDAP::Address: ...>, ...]
    #
    # == Note on Binds
    # 
    # You must have a privileged bind and pass your credentials to UCB::LDAP.authenticate()
    # before performing your Address search.
    #
    class Address < Entry
      @entity_name = 'personAddress'

      def primary_work_address?
        berkeleyEduPersonAddressPrimaryFlag
      end
      
      def address_type
        berkeleyEduPersonAddressType
      end
      
      def building_code
        berkeleyEduPersonAddressBuildingCode
      end
      
      def city
        l.first
      end
      
      def country_code
        berkeleyEduPersonAddressCountryCode
      end
      
      def department_name
        berkeleyEduPersonAddressUnitCalNetDeptName
      end
      
      def department_acronym
        berkeleyEduPersonAddressUnitHRDeptName
      end
      
      def directories
        berkeleyEduPersonAddressPublications
      end
      
      # Returns email address associated with this Address.
      def email
        mail.first
      end
      
      def mail_code
        berkeleyEduPersonAddressMailCode
      end
      
      def mail_release?
        berkeleyEduEmailRelFlag
      end
      
      def phone
        telephoneNumber.first
      end
      
      # Returns postal address as an Array.
      #
      #   addr.attribute(:postalAddress) #=> '501 Banway Bldg.$Berkeley, CA 94720-3814$USA'
      #   addr.postal_address            #=> ['501 Banway Bldg.', 'Berkeley, CA 94720-3814', 'USA']
      #
      def postal_address
        postalAddress == [] ? nil : postalAddress.split("$")  
      end
      
      def sort_order
        berkeleyEduPersonAddressSortOrder.first || 0
      end
      
      def state
        st.first
      end
      
      def zip
        postalCode
      end
      
      class << self
        # Returns an Array of Address for <tt>uid</tt>, sorted by sort_order().
        # Returns an empty Array ([]) if nothing is found.  
        #
        def find_by_uid(uid)
          base = "uid=#{uid},ou=people,dc=berkeley,dc=edu"
          filter = Net::LDAP::Filter.eq("objectclass", 'berkeleyEduPersonAddress')
          search(:base => base, :filter => filter).sort_by{|addr| addr.sort_order}
        end
         
      end
    end
  end
end