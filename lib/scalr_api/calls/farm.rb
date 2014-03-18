class Scalr
  class API
    class Farm < Base
      def list
        client.get('FarmsList')['FarmsListResponse']
      end

      def details(farm)
        client.get('FarmGetDetails', FarmID: farm)['FarmGetDetailsResponse']
      end

      def launch(farm)
        client.get('FarmLaunch', FarmID: farm)['FarmLaunchResponse']
      end

      def terminate(farm, ebs = 1, eip = 1, dns = 0)
        client.get('FarmTerminate', FarmID: farm, KeepEBS: ebs,
                                    KeepEIP: eip,
                                    KeepDNSZone: dns)['FarmTerminateResponse']
      end

      def clone(farm)
        client.get('FarmClone', FarmID: farm)['FarmCloneResponse']
      end

      def stats(farm)
        client.get('FarmGetStats', FarmID: farm)['FarmGetStatsResponse']
      end
    end
  end
end
