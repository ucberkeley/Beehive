module UCB
  module LDAP
 
    class BadAttributeNameException < Exception #:nodoc:
    end

    class BindFailedException < Exception #:nodoc:
      def initialize
        super("Failed to bind username '#{UCB::LDAP.username}' to '#{UCB::LDAP.host}'")
      end
    end
   
    class ConnectionFailedException < Exception #:nodoc:
      def initialize
        super("Failed to connect to ldap host '#{UCB::LDAP.host}''")
      end
    end
   
    class DirectoryNotUpdatedException < Exception #:nodoc:
      def initialize
        result = UCB::LDAP.net_ldap.get_operation_result 
        super("(Code=#{result.code}) #{result.message}")
      end
    end
   
 end
end