class Scalr
  class API
    class Server < Base
      def info(id)
        client.get('ServerGetExtendedInformation', ServerID: id)
      end
    end
  end
end
