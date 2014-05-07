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
    def client
      @client ||= Faraday.new(url: ScalrApi.configuration.url,
                              ssl: { verify: false, version: 'SSLv3' }) do |f|
        f.request   :url_encoded
        f.response  :xml, content_type: /\bxml$/
        f.use       ScalrApi::APIError
        f.adapter   Faraday.default_adapter
      end
    end

    def get(action, params = {})
      action(action, :get, params).body
    end

    def timestamp
      Time.now.getgm.iso8601
    end

    def sanitize_params(p)
      p.keys.inject({}) do |acc, k|
        key = k.to_s
        if p[k].kind_of? Hash
          p[k].each_pair { |n,v| acc["#{key}[#{n}]"] = v }
        else
          if p.fetch(k) == true
            acc[key] = 1
          elsif p.fetch(k) == false
            acc[key] = 0
          else
            acc[key] = p[k]
          end
        end
        acc
      end
    end

    def sig(action, timestamp)
      string = "#{action}:#{ScalrApi.configuration.key}:#{timestamp}"
      mac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'),
                                 ScalrApi.configuration.secret, string)
      Base64.strict_encode64(mac)
    end

    def action(action, mode = :get, params = {})
      time = timestamp
      additional = { Signature: sig(action, time),
                     Action: action, Version: '2.3.0',
                     TimeStamp: time, KeyID: ScalrApi.configuration.key,
                     AuthVersion: 3
      }

      additional[:EnvID] = ScalrApi.configuration.environment if ScalrApi.configuration.environment

      p = params.merge(additional).delete_if { |k, v| v.nil? }
      client.send(mode, '/api/api.php', sanitize_params(p))
    end
  end
end
