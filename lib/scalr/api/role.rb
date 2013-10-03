class Scalr
  class API
    class Role < Base
      def list(environment, params={})
        client.get('RolesList', params.merge(EnvID: environment))
      end

      def clone(environment, server, name)
        client.get('ServerImageCreate', EnvID: environment, ServerID: server, RoleName: name)
      end
    end
  end
end
