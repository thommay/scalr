class Scalr
  class Model
    class Role
      attr_reader :id, :role_id, :name, :platform, :category, :servers

      def initialize(role)
        @role = role
        parse_role
      end

      def inspect
        "<#{self.class.name} #{id} #{name} #{servers.length} servers>"
      end

      private

      def parse_role
        @id = @role['ID']
        @role_id = @role['RoleID']
        @name = @role['Name']
        @platform = @role['Platform']
        @category = @role['Category']
        if @role['ServerSet']['Item'].is_a? Array
          @servers = @role['ServerSet']['Item'].map { |s| s['ServerID'] }
        else
          @servers = [@role['ServerSet']['Item']['ServerID']]
        end
      end
    end
  end
end
