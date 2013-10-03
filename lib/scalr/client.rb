require 'faraday'
require 'faraday_middleware'
require 'openssl'
require 'base64'
require 'time'

class Scalr
  class Client
    attr_accessor :key, :secret, :url

    def initialize(url, key, secret)
      @url = url
      @key = key
      @secret = secret
    end

    def client
      @client ||= Faraday.new(url: @url, ssl: {verify: false, version: 'SSLv3'}) do |f|
        f.request   :url_encoded
        f.response  :json, :content_type => /\bjson$/
        f.response  :xml, content_type: /\bxml$/
        f.response  :logger
        f.adapter   Faraday.default_adapter
      end
    end

    def get(action, params)
      action(action, :get, params)
    end

    private
    def timestamp
      Time.now.getgm.iso8601
    end

    def sig(action, timestamp)
      string = "#{action}:#{@key}:#{timestamp}"
      mac = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha256"), @secret, string)
      Base64.strict_encode64(mac)
    end

    def action(action, mode=:get, params={})
      time = timestamp
      additional = { Signature: sig(action, time),
                     Action: action,
                     Version: '2.3.0',
                     TimeStamp: time,
                     KeyID: @key,
                     AuthVersion: 3
      }
      params.merge!(additional)
      client.send(mode, '/api/api.php', params)
    end

  end
end
