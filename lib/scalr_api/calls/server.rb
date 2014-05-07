class ScalrApi
  class Calls
    class Server < Base
      def info(id)
        client.get('ServerGetExtendedInformation',
                   ServerID: id)['ServerGetExtendedInformationResponse']
      end

      def launch(role, increase = true)
        client.get('ServerLaunch', FarmRoleID: role,
                   IncreaseMaxInstances: increase)['ServerLaunchResponse']
      end

      def terminate(id, decrease = true)
        client.get('ServerTerminate', ServerID: id,
                   DecreaseMinInstancesSetting: decrease)['TerminateInstanceResponse']
      end

      def reboot(id)
        client.get('ServerReboot', ServerID: id)['ServerRebootResponse']
      end
    end
  end
end
