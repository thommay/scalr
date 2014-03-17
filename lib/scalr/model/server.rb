require 'date'

class Scalr
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
        Scalr.api.server_reboot(id)
      end

      def terminate(decrease = true)
        Scalr.api.server_terminate(id, decrease)
      end

      def self.find(id)
        server = Scalr.api.server_information(id)
        new(server)
      end

      def self.create(role)
        id = Scalr.api.server_launch(role)
        new(Scalr.api.server_information(id))
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
