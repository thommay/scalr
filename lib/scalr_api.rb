require 'scalr_api/client'
require 'scalr_api/calls'

class ScalrApi
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.calls
    @calls ||= ScalrApi::Calls.new
  end

  class Configuration
    attr_accessor :url
    attr_accessor :key
    attr_accessor :secret
    attr_accessor :environment
  end

  require 'scalr_api/model/farm'
  require 'scalr_api/model/role'
  require 'scalr_api/model/server'
end
