class Scalr
  extend Forwardable
  attr_reader :client

  def initialize(opts = {})
    @client ||= Scalr::Client.new(opts[:url], opts[:key], opts[:secret], opts[:environment])
  end

  def environments_list
    client.get('EnvironmentsList')
  end

  def farm
    @farm ||= Scalr::API::Farm.new(client)
  end
  def_delegator :farm, :list, :farms_list
  def_delegator :farm, :details, :farm_details
  def_delegator :farm, :stats, :farm_stats
  def_delegator :farm, :launch, :farm_launch
  def_delegator :farm, :clone, :farm_clone

  def role
    @role ||= Scalr::API::Role.new(client)
  end
  def_delegator :role, :list, :roles_list
  def_delegator :role, :clone, :server_image_create

  def server
    @server ||= Scalr::API::Server.new(client)
  end
  def_delegator :server, :info, :get_server_information

  require_relative 'scalr/client'
  require_relative 'scalr/api/base'
  require_relative 'scalr/api/farm'
  require_relative 'scalr/api/role'
  require_relative 'scalr/api/server'
end
