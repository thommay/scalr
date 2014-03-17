require 'scalr/client'
require 'scalr/api'

class Scalr
  def self.setup(opts = {})
    @url = opts[:url]
    @key = opts[:key]
    @secret = opts[:secret]
    @env = opts[:environment]
    @api ||= Scalr::API.new(url: @url, key: @key, secret: @secret,
                            environment: @env)
  end

  def self.api
    @api ||= Scalr::API.new(url: @url, key: @key, secret: @secret,
                            environment: @env)
  end

  require 'scalr/model/farm'
  require 'scalr/model/role'
  require 'scalr/model/server'
end
