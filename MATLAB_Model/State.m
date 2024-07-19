classdef State
    properties
        stateId % Unique identifier for the state
        stateDescription % Description of the state
    end
    
    methods
        % Constructor to initialize the state with an ID and description
        function obj = State(stateId, stateDescription)
            obj.stateId = stateId;
            obj.stateDescription = stateDescription;
        end
        
        % Method to get the state ID
        function id = getStateId(obj)
            id = obj.stateId;
        end
        
        % Method to get a description of the state
        function desc = getStateDescription(obj)
            desc = obj.stateDescription;
        end
    end
end
