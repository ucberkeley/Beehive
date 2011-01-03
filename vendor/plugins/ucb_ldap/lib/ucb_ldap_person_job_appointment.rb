
module UCB
  module LDAP
    # = UCB::LDAP::JobAppointment
    # 
    # This class models a person's job appointment instance in the UCB LDAP directory.
    #
    #   appts = JobAppontment.find_by_uid("1234")       #=> [#<UCB::LDAP::JobAppointment: ...>, ...]
    #
    # JobAppointments are usually loaded through a Person instance:
    #
    #   p = Person.find_by_uid("1234")    #=> #<UCB::LDAP::Person: ...>
    #   appts = p.job_appointments        #=> [#<UCB::LDAP::JobAppointment: ...>, ...]
    #
    # == Note on Binds
    # 
    # You must have a privileged bind and pass your credentials to UCB::LDAP.authenticate()
    # before performing your JobAppointment search.
    #
    class JobAppointment < Entry
      @entity_name = 'personJobAppointment'

      def cto_code
        berkeleyEduPersonJobApptCTOCode
      end
      
      def deptid
        berkeleyEduPersonJobApptDepartment
      end
      
      def record_number
        berkeleyEduPersonJobApptEmpRecNumber.to_i
      end
      
      def personnel_program_code
        berkeleyEduPersonJobApptPersPgmCode
      end
      
      def primary?
        berkeleyEduPersonJobApptPrimaryFlag
      end
      
      # Returns Employee Relation Code
      def erc_code
        berkeleyEduPersonJobApptRelationsCode
      end
      
      def represented?
        berkeleyEduPersonJobApptRepresentation != 'U'
      end
      
      def title_code
        berkeleyEduPersonJobApptTitleCode
      end
      
      def appointment_type
        berkeleyEduPersonJobApptType
      end
      
      # Returns +true+ if appointment is Without Salary
      def wos?
        berkeleyEduPersonJobApptWOS
      end
      
      class << self
        # Returns an Array of JobAppointment for <tt>uid</tt>, sorted by
        # record_number().
        # Returns an empty Array ([]) if nothing is found.  
        #
        def find_by_uid(uid)
          base = "uid=#{uid},ou=people,dc=berkeley,dc=edu"
          filter = Net::LDAP::Filter.eq("objectclass", 'berkeleyEduPersonJobAppt')
          search(:base => base, :filter => filter).sort_by{|appt| appt.record_number}
        end
         
      end
    end
  end
end