require 'date'

class ScalrApi
  class Model
    class Server
      attr_reader :server
      attr_reader :id, :private_ip, :public_ip, :status
      attr_reader :platform, :created, :index

      def initialize(server)
        @server = server
        parse_server
      end

      def inspect
        "<#{self.class.name} #{id} #{created} data=private_ip: #{private_ip}, status: #{status}>"
      end

      def reboot
        ScalrApi.calls.server_reboot(id)
      end

      def terminate(decrease = true)
        ScalrApi.calls.server_terminate(id, decrease)
      end

      def self.find(id)
        server = ScalrApi.calls.server_information(id)
        new(server)
      end

      def self.create(role)
        id = ScalrApi.calls.server_launch(role)
        new(ScalrApi.calls.server_information(id))
      end

      private

      def parse_server
        @id = @server['ServerInfo']['ServerID']
        @private_ip = @server['ServerInfo']['LocalIP']
        @public_ip = @server['ServerInfo']['RemoteIP']
        @status = get_status(@server['ServerInfo']['Status'])
        @platform = @server['ServerInfo']['Platform']
        @created = DateTime.parse(@server['ServerInfo']['AddedAt'])
        @index = @server['ServerInfo']['Index']
      end

      # rubocop:disable CyclomaticComplexity, MethodLength
      def get_status(status)
        case status
        when 'Pending launch'
          :requested
        when 'Pending'
          :pending
        when 'Initializing'
          :initializing
        when 'Running'
          :running
        when 'Pending terminate'
          :terminating
        when 'Terminated'
          :terminated
        else
          fail 'Unknown status'
        end
      end
    end
  end
end
