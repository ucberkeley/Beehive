
module UCB
  module LDAP
    ##
    # Class for accessing the Namespace/Name part of LDAP.
    #
    class Namespace < Entry
      @tree_base = 'ou=names,ou=namespace,dc=berkeley,dc=edu'
      @entity_name = 'namespaceName'
      
      ##
      # Returns name
      #
      def name
        cn.first
      end

      ##
      # Returns +Array+ of services
      #
      def services
        berkeleyEduServices
      end

      ##
      # Returns uid
      #
      def uid
        super.first
      end
      
      class << self
        ##
        # Returns an +Array+ of Namespace for _uid_.
        #
        def find_by_uid(uid)
          search(:filter => "uid=#{uid}")
        end

        ##
        # Returns Namespace instance for _cn_.
        #
        def find_by_cn(cn)
          search(:filter => "cn=#{cn}").first
        end
      end
    end
    
  end  
end
