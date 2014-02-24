class Scalr
  class API
    extend Forwardable
    attr_reader :client

    def initialize(opts = {})
      @client ||= Scalr::Client.new(opts[:url], opts[:key], opts[:secret], opts[:environment])
    end

    def environments_list
      client.get('EnvironmentsList')
    end

    def farm
      @farm ||= Farm.new(client)
    end
    def_delegator :farm, :list, :farms_list
    def_delegator :farm, :details, :farm_details
    def_delegator :farm, :stats, :farm_stats
    def_delegator :farm, :launch, :farm_launch
    def_delegator :farm, :clone, :farm_clone

    def role
      @role ||= Role.new(client)
    end
    def_delegator :role, :list, :roles_list
    def_delegator :role, :clone, :server_image_create

    def server
      @server ||= Server.new(client)
    end
    def_delegator :server, :info, :get_server_information

    require_relative 'api/base'
    require_relative 'api/farm'
    require_relative 'api/role'
    require_relative 'api/server'
  end
end
