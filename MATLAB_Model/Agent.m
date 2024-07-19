classdef Agent
    properties
        currentState % Current state of the agent
        qLearning % Instance of the QLearning class
    end
    
    methods
        % Constructor to initialize the Agent with an initial state and QLearning instance
        function obj = Agent(initialState, qLearning)
            % Validate the QLearning instance
            if ~isa(qLearning, 'QLearning')
                error('Invalid QLearning instance.');
            end
            
            % Validate the initial state (assuming state should be a non-negative integer)
            if ~isnumeric(initialState) || initialState <= 0 || floor(initialState) ~= initialState
                error('Initial state must be a positive integer.');
            end
            
            obj.currentState = initialState;
            obj.qLearning = qLearning;
        end
        
        % Method to take an action and update the state
        function obj = takeAction(obj, action, environment)
            % Validate the action
            if ~isnumeric(action) || action <= 0 || floor(action) ~= action
                error('Action must be a positive integer.');
            end
            
            % Validate the environment
            if ~isa(environment, 'Environment')
                error('Invalid Environment instance.');
            end
            
            % Get reward and next state from the environment
            [reward, nextState] = environment.getReward(obj.currentState, action);
            
            % Check validity of reward and nextState
            if isnan(reward) || isnan(nextState)
                error('Invalid reward or next state.');
            end
            
            % Update Q-value
            obj.qLearning = obj.qLearning.updateQValue(obj.currentState, action, reward, nextState);
            
            % Update current state
            obj.currentState = nextState;
        end
        
        % Method to learn from the environment
        function obj = learn(obj, environment)
            % Validate the environment
            if ~isa(environment, 'Environment')
                error('Invalid Environment instance.');
            end
            
            % Choose an action based on the current state
            possibleActions = environment.getPossibleActions(obj.currentState);
            
            % Check if possibleActions is not empty
            if isempty(possibleActions)
                error('No possible actions available for the current state.');
            end
            
            % Choose an action
            action = obj.qLearning.chooseAction(obj.currentState, possibleActions);
            
            % Take the action and update state
            obj = obj.takeAction(action, environment);
            
            % Optionally, decrease exploration rate
            obj.qLearning = obj.qLearning.decreaseExplorationRate();
        end
    end
end
