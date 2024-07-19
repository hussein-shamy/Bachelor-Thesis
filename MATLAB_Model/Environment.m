classdef Environment
    properties
        % State and action spaces for the environment
        states
        actions
    end
    
    methods
        % Constructor to initialize the environment
        function obj = Environment(stateSpace, actionSpace)
            % Ensure both stateSpace and actionSpace are provided and not empty
            if nargin < 2
                error('State space and action space must be provided.');
            end
            
            if isempty(stateSpace) || isempty(actionSpace)
                error('State space and action space cannot be empty.');
            end
            
            obj.states = stateSpace;
            obj.actions = actionSpace;
        end
        
        % Method to get reward and next state based on current state and action
        function [reward, nextState] = getReward(obj, state, action)
            % Validate state and action
            if ~ismember(state, obj.states)
                error('Invalid state.');
            end
            
            if ~ismember(action, obj.actions)
                error('Invalid action.');
            end
            
            % Example reward and state transition logic
            reward = -abs(state - action); % Example reward function
            nextState = state + action; % Example state transition function
            
            % Ensure nextState is within stateSpace bounds
            if ~ismember(nextState, obj.states)
                nextState = obj.reset(); % Reset if out of bounds
            end
        end
        
        % Method to get possible actions for a given state
        function actions = getPossibleActions(obj, state)
            % Validate state
            if ~ismember(state, obj.states)
                error('Invalid state.');
            end
            
            % Define possible actions based on the state
            actions = obj.actions; % Example: all actions are possible
        end
        
        % Method to reset the environment to a starting state
        function initialState = reset(obj)
            % Define the logic to reset the environment
            initialState = obj.states(1); % Reset to the first state as default
        end
    end
end
