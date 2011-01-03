
module UCB
  module LDAP
    # = UCB::LDAP::StudentTerm
    # 
    # This class models a student's term entries in the UCB LDAP directory.
    #
    #   terms = StudentTerm.find_by_uid("1234")       #=> [#<UCB::LDAP::StudentTerm: ...>, ...]
    #
    # StudentTerms are usually loaded through a Person instance:
    #
    #   p = Person.find_by_uid("1234")    #=> #<UCB::LDAP::Person: ...>
    #   terms = p.student_terms        #=> [#<UCB::LDAP::StudentTerm: ...>, ...]
    #
    # == Note on Binds
    # 
    # You must have a privileged bind and pass your credentials to UCB::LDAP.authenticate()
    # before performing your StudentTerm search.
    #
    class StudentTerm < Entry
      @entity_name = 'personStudentTerm'

      def change_datetime
        UCB::LDAP.local_datetime_parse(berkeleyEduStuChangeDate)
      end
      
      def college_code
        berkeleyEduStuCollegeCode
      end
      
      def college_name
        berkeleyEduStuCollegeName
      end
      
      def level_code
        berkeleyEduStuEduLevelCode
      end
      
      def level_name
        berkeleyEduStuEduLevelName
      end
      
      def role_code
        berkeleyEduStuEduRoleCode
      end
      
      def role_name
        berkeleyEduStuEduRoleName
      end
      
      def major_code
        berkeleyEduStuMajorCode
      end
      
      def major_name
        berkeleyEduStuMajorName
      end
      
      def registration_status_code
        berkeleyEduStuRegStatCode
      end
      
      def registration_status_name
        berkeleyEduStuRegStatName
      end
      
      def term_code
        berkeleyEduStuTermCode
      end
      
      def term_name
        berkeleyEduStuTermName
      end
      
      def term_status
        berkeleyEduStuTermStatus
      end
      
      def term_year
        berkeleyEduStuTermYear
      end
      
      def under_graduate_code
        berkeleyEduStuUGCode
      end
      
      class << self
        # Returns an Array of JobAppointment for <tt>uid</tt>, sorted by
        # record_number().
        # Returns an empty Array ([]) if nothing is found.  
        #
        def find_by_uid(uid)
          base = "uid=#{uid},ou=people,dc=berkeley,dc=edu"
          filter = Net::LDAP::Filter.eq("objectclass", 'berkeleyEduPersonTerm')
          search(:base => base, :filter => filter)
        end
         
      end
    end
  end
end