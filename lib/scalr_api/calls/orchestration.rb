class ScalrApi
  class Calls
    class Orchestration < Base
      def scripts_list
        client.get('ScriptsList')['ScriptsListResponse']
      end

      def script_details(id)
        client.get('ScriptGetDetails', ScriptID: id)['ScriptGetDetailsResponse']
      end

      def script_execute(id, farm_id, timeout, async, farm_role_id = nil,
                         server_id = nil, revision = nil, config_variables = {})
        client.get('ScriptExecute', ScriptID: id, FarmID: farm_id,
                   ServerID: server_id, Timeout: timeout, Async: async,
                   Revision: revision,
                   ConfigVariables: config_variables)['ScriptExecuteResponse']
      end

      def global_variables_list(farm_id: nil, farm_role_id: nil, role_id: nil,
                                server_id: nil)
        client.get('GlobalVariablesList', FarmID: farm_id,
                   FarmRoleID: farm_role_id, RoleID: role_id,
                   ServerID: server_id)['GlobalVariablesListResponse']
      end

      def global_variable_set(name, value, farm_id: nil, farm_role_id: nil,
                              role_id: nil, server_id: nil)
        client.get('GlobalVariableSet', ParamName: name, ParamValue: value,
                   FarmID: farm_id, FarmRoleID: farm_role_id, RoleID: role_id,
                   ServerID: server_id)['GlobalVariableSetResponse']
      end

      def fire_custom_event(id, event, params = {})
        client.get('FireCustomEvent', ServerID: id, EventName: event,
                   Params: params)['FireCustomEventResponse']
      end

      def events_list(id, start=0, limit=20, paginate=false)
        client.get('EventsList', FarmID: id, StartFrom: start,
                   RecordsLimit: limit)['EventsListResponse']
      end
    end
  end
end
