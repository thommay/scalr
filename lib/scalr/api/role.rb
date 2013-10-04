class Scalr
  class API
    class Role < Base
      def list(params={})
        client.get('RolesList', params)
      end

      def clone(server, name)
        client.get('ServerImageCreate', ServerID: server, RoleName: name)
      end
    end
  end
end
