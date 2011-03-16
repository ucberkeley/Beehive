

module UCB::LDAP
    module AffiliationMethods
      
      ##
      # Returns an <tt>Array</tt> of Person's affiliations.
      #
      def affiliations
        @affiliations ||= berkeleyEduAffiliations.map { |a| a.upcase }
      end
      
      ##
      # Returns <tt>true</tt> if entry's affiliations contain _affiliation_.
      # 
      # Case-insensitive.
      #
      def has_affiliation?(affiliation)
        affiliations.include?(affiliation.upcase)
      end
      
      ##
      # Returns <tt>true</tt> if Person's affiliations contain at least one affiliation of a particular type.
      #
      #   p = Person.find_by_uid ...
      #   p.affiliations                         #=> ['EMPLOYEE-TYPE-STAFF']
      #   p.has_affiliation_of_type?(:employee)  #=> true
      #   p.has_affiliation_of_type?(:student)   #=> false
      #
      def has_affiliation_of_type?(affiliation_type)
        aff_type_string = affiliation_type.to_s.upcase
        affiliations.find{|a| a =~ /^#{aff_type_string}-TYPE-/} ? true : false
      end


      ############################################
      #  Determine if the person is an EMPLOYEE  #
      ############################################
      
      ##
      # Returns <tt>true</tt> if entry has the "staff" affiliation.
      #
      def employee_staff?
        has_affiliation? 'EMPLOYEE-TYPE-STAFF'
      end

      def employee_academic?
        has_affiliation? 'EMPLOYEE-TYPE-ACADEMIC'
      end

      def employee_expired?
        has_affiliation? 'EMPLOYEE-STATUS-EXPIRED'
      end

      def employee_expiration_date
        Date.parse(berkeleyEduEmpExpDate.to_s)
      end

      def employee?
        has_affiliation_of_type?(:employee) && !employee_expired?
      end

     
      ##########################################
      #  Determine if the person is a STUDENT  #
      ##########################################
      
      ##
      # Returns +true+ if is an expired student.
      #
      def student_expired?
        has_affiliation? 'STUDENT-STATUS-EXPIRED'
      end

      def student_expiration_date
        Date.parse(berkeleyEduStuExpDate.to_s)
      end

      def student_registered?
        has_affiliation? 'STUDENT-TYPE-REGISTERED'
      end

      def student_not_registered?
        has_affiliation? 'STUDENT-TYPE-NOT REGISTERED'
      end
      
      ##
      # Returns <tt>true</tt> if entry has a studend affiliation and
      # is not expired.
      #
      def student?
        has_affiliation_of_type?(:student) && !student_expired?
      end


      ##############################################      
      #  Determine if the persone is an AFFILIATE  #
      ##############################################

      def affiliate_aws_only?
        has_affiliation? 'AFFILIATE-TYPE-AWS ONLY'
      end

      def affiliate_staff_retiree?
        has_affiliation? 'AFFILIATE-TYPE-STAFF RETIREE'  
      end

      def affiliate_emeritus?
        has_affiliation? 'AFFILIATE-TYPE-EMERITUS'
      end

      def affiliate_directory_only?
        has_affiliation? 'AFFILIATE-TYPE-DIRECTORY ONLY'
      end
      
      ##
      # Note: there are actually 2 types of visting affiliaties, visiting student and 
      # visiting scholars.  But for now we will generalize.
      #
      def affiliate_visiting?
        has_affiliation? 'AFFILIATE-TYPE-VISITING'
      end

      def affiliate_contractor?
        has_affiliation? 'AFFILIATE-TYPE-CONTRACTOR'
      end

      def affiliate_lbl_doe_postdoc?
        has_affiliation? 'AFFILIATE-TYPE-LBL/DOE POSTDOC'
      end

      def affiliate_lbl_op_staff?
        has_affiliation? 'AFFILIATE-TYPE-LBLOP STAFF'
      end
     
      def affiliate_committee_member?
        has_affiliation? 'AFFILIATE-TYPE-COMMITTEE MEMBER'
      end

      def affiliate_consultant?
        has_affiliation? 'AFFILIATE-TYPE-CONSULTANT'
      end

      def affiliate_volunteer?
        has_affiliation? 'AFFILIATE-TYPE-VOLUNTEER'
      end

      def affiliate_hhmi_researcher?
        has_affiliation? 'AFFILIATE-TYPE-HHMI RESEARCHER'
      end
     
      def affiliate_concurrent_enrollment?
        has_affiliation? 'AFFILIATE-TYPE-CONCURR ENROLL'
      end

      def affiliate_temp_agency?
        has_affiliation? 'AFFILIATE-TYPE-TEMP AGENCY'  
      end

      def affiliate_departmental?
        has_affiliation? 'AFFILIATE-TYPE-DEPARTMENTAL'
      end

      def affiliate_test?
        has_affiliation? 'AFFILIATE-TYPE-TEST'
      end

      def affiliate_staff_affiliate?
        has_affiliation? 'AFFILIATE-TYPE-STAFF-AFFILIATE'
      end

      def affiliate_academic_case_tracking?
        has_affiliation? 'AFFILIATE-TYPE-ACADEMIC CASE TRACKING'
      end

      def affiliate_maintenance?
        has_affiliation? 'AFFILIATE-TYPE-MAINTENANCE'
      end

      def affiliate_billing_only?
        has_affiliation? 'AFFILIATE-TYPE-BILLING ONLY'
      end

      def affiliate_advcon_trustee?
        has_affiliation? 'AFFILIATE-TYPE-ADVCON-TRUSTEE'
      end

      def affiliate_advcon_friend?
        has_affiliation? 'AFFILIATE-TYPE-ADVCON-FRIEND'
      end

      def affiliate_advcon_alumnus?
        has_affiliation? 'AFFILIATE-TYPE-ADVCON-ALUMNUS'
      end

      def affiliate_advcon_caa_member?
        has_affiliation? 'AFFILIATE-TYPE-ADVCON-CAA-MEMBER'
      end

      def affiliate_advcon_i_house_resident?
        has_affiliation? 'AFFILIATE-TYPE-ADVCON-I-HOUSE-RESIDENT'  
      end

      def affiliate_advcon_student?
        has_affiliation? 'AFFILIATE-TYPE-ADVCON-STUDENT'
      end

      def affiliate_advcon_attendee?
        has_affiliation? 'AFFILIATE-TYPE-ADVCON-ATTENDEE'
      end

      def affiliate_expired?
        has_affiliation? 'AFFILIATE-STATUS-EXPIRED'
      end

      def affiliate?
        has_affiliation_of_type?(:affiliate) && !affiliate_expired?
      end

      def affiliate_expiration_date
        Date.parse(berkeleyEduAffExpDate.to_s)
      end
    
  end 
end
