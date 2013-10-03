class Scalr
  class API
    class Farm < Base
      def list(environment)
        client.get('FarmsList', EnvID: environment)
      end

      def details(environment, farm)
        client.get('FarmGetDetails', EnvID: environment, FarmID: farm)
      end

      def launch(environment, farm)
        client.get('FarmLaunch', EnvID: environment, FarmID: farm)
      end

      def clone(environment, farm)
        client.get('FarmClone', EnvID: environment, FarmID: farm)
      end

      def stats(environment, farm)
        client.get('FarmGetStats', EnvID: environment, FarmID: farm)
      end
    end
  end
end
