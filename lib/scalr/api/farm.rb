class Scalr
  class API
    class Farm < Base
      def list
        client.get('FarmsList')
      end

      def details(farm)
        client.get('FarmGetDetails', FarmID: farm)
      end

      def launch(farm)
        client.get('FarmLaunch', FarmID: farm)
      end

      def terminate(farm, ebs=1, eip=1, dns=0)
        client.get('FarmTerminate', FarmID: farm, KeepEBS: ebs, KeepEIP: eip, KeepDNSZone: dns)
      end

      def clone(farm)
        client.get('FarmClone', FarmID: farm)
      end

      def stats(farm)
        client.get('FarmGetStats', FarmID: farm)
      end
    end
  end
end
