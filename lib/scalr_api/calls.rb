class ScalrApi
  class Calls
    extend Forwardable
    attr_reader :client

    def initialize(opts = {})
      @client ||= ScalrApi::Client.new
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
    def_delegator :farm, :terminate, :farm_terminate

    def role
      @role ||= Role.new(client)
    end
    def_delegator :role, :list, :roles_list
    def_delegator :role, :clone, :server_image_create

    def server
      @server ||= Server.new(client)
    end
    def_delegator :server, :info, :server_information
    def_delegator :server, :launch, :server_launch
    def_delegator :server, :terminate, :server_terminate
    def_delegator :server, :reboot, :server_reboot

    require_relative 'calls/base'
    require_relative 'calls/farm'
    require_relative 'calls/role'
    require_relative 'calls/server'
  end
end
