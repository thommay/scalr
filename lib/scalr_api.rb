require 'scalr_api/client'
require 'scalr_api/calls'

class ScalrApi
  def self.setup(opts = {})
    @url = opts[:url]
    @key = opts[:key]
    @secret = opts[:secret]
    @env = opts[:environment]
    @api ||= ScalrApi::Calls.new(url: @url, key: @key, secret: @secret,
                            environment: @env)
  end

  def self.api
    @api ||= ScalrApi::Calls.new(url: @url, key: @key, secret: @secret,
                            environment: @env)
  end

  require 'scalr_api/model/farm'
  require 'scalr_api/model/role'
  require 'scalr_api/model/server'
end
