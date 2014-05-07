class ScalrApi
  class Calls
    class Role < Base
      def list(params = {})
        client.get('RolesList', params)['RolesListResponse']
      end

      def clone(server, name)
        client.get('ServerImageCreate', ServerID: server,
                                        RoleName: name)['ServerImageCreateResponse']
      end
    end
  end
end
