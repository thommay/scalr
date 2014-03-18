require 'faraday'
require 'faraday_middleware'
require 'openssl'
require 'base64'
require 'time'

class ScalrApi
  class ResponseError < Faraday::Error::ClientError
    attr_reader :response

    def initialize(response)
      super response['Error']['Message']
    end
  end

  class APIError < Faraday::Response::Middleware
    dependency 'multi_xml'

    def call(env)
      @app.call(env).on_complete do |e|
        body = ::MultiXml.parse(e[:body])
        fail(ScalrApi::ResponseError, body) if body['Error']
      end
    end
  end

  class Client
    attr_accessor :key, :secret, :url, :env

    def initialize(url, key, secret, env)
      @url = url
      @key = key
      @secret = secret
      @env = env
    end

    def client
      @client ||= Faraday.new(url: @url,
                              ssl: { verify: false, version: 'SSLv3' }) do |f|
        f.request   :url_encoded
        f.response  :xml, content_type: /\bxml$/
        f.response  :logger
        f.use       ScalrApi::APIError
        f.adapter   Faraday.default_adapter
      end
    end

    def get(action, params = {})
      action(action, :get, params).body
    end

    private

    def timestamp
      Time.now.getgm.iso8601
    end

    def sig(action, timestamp)
      string = "#{action}:#{@key}:#{timestamp}"
      mac = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'),
                                 @secret, string)
      Base64.strict_encode64(mac)
    end

    def action(action, mode = :get, params = {})
      time = timestamp
      additional = { Signature: sig(action, time),
                     Action: action, Version: '2.3.0',
                     TimeStamp: time, KeyID: @key,
                     AuthVersion: 3, EnvID: @env
      }
      p = params.merge(additional).delete_if { |k, v| v.nil? }
      client.send(mode, '/api/api.php', p)
    end
  end
end
