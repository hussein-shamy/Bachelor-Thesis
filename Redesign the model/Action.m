classdef Action
    properties
        actionId % Unique identifier for the action
        actionDescription % Description of the action
    end
    
    methods
        % Constructor to initialize the action with an ID and description
        function obj = Action(actionId, actionDescription)
            obj.actionId = actionId;
            obj.actionDescription = actionDescription;
        end
        
        % Method to get the action ID
        function id = getActionId(obj)
            id = obj.actionId;
        end
        
        % Method to get a description of the action
        function desc = getActionDescription(obj)
            desc = obj.actionDescription;
        end
    end
end
