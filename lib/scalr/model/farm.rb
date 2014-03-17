class Scalr
  class Model
    class Farm
      attr_reader :id, :name, :roles

      def initialize(farm)
        @farm = farm
        parse_farm
      end

      def locked?
        !!@locked
      end

      def inspect
        "<#{self.class.name} #{id} #{name} #{roles.length} roles>"
      end

      def self.find(id)
        farm = Scalr.api.farm_details(id)
        new(farm)
      end

      def self.all
        Scalr.api.farms_list['FarmSet']['Item'].reduce([]) do |acc, x|
          acc << new(Scalr.api.farm_details(x['ID']))
        end
      end

      private

      def parse_farm
        @id = @farm['ID']
        @name = @farm['Name']
        @roles = parse_roles(@farm['FarmRoleSet']['Item'])
        @locked = @farm['IsLocked']
      end

      def parse_roles(roles)
        if roles.is_a? Array
          roles.reduce([]) do |acc, r|
            acc << Scalr::Model::Role.new(r)
          end
        else
          [Scalr::Model::Role.new(roles)]
        end
      end
    end
  end
end
