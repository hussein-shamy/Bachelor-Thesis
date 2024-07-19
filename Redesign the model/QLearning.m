classdef QLearning
    properties
        learningRate % Alpha (α)
        discountFactor % Gamma (γ)
        explorationRate % Epsilon (ε)
        qTable % containers.Map to store Q-values
    end
    
    methods
        % Constructor to initialize the QLearning parameters
        function obj = QLearning(learningRate, discountFactor, explorationRate)
            % Validate input parameters
            if learningRate < 0 || learningRate > 1
                error('Learning rate must be between 0 and 1.');
            end
            if discountFactor < 0 || discountFactor > 1
                error('Discount factor must be between 0 and 1.');
            end
            if explorationRate < 0 || explorationRate > 1
                error('Exploration rate must be between 0 and 1.');
            end
            
            obj.learningRate = learningRate;
            obj.discountFactor = discountFactor;
            obj.explorationRate = explorationRate;
            obj.qTable = containers.Map('KeyType', 'char', 'ValueType', 'double');
        end
        
        % Method to update the Q-value for a given state-action pair
        function obj = updateQValue(obj, currentState, action, reward, nextState)
            % Create key for current state-action pair
            currentKey = obj.createKey(currentState, action);
            
            % Initialize Q-value if not already in the table
            if ~isKey(obj.qTable, currentKey)
                obj.qTable(currentKey) = 0;
            end
            
            % Get maximum Q-value for the next state
            nextActions = obj.getPossibleActions(nextState);
            maxQNext = -inf; % Start with a very low value
            
            for i = 1:numel(nextActions)
                nextKey = obj.createKey(nextState, nextActions(i));
                if isKey(obj.qTable, nextKey)
                    maxQNext = max(maxQNext, obj.qTable(nextKey));
                end
            end
            
            % Handle case where maxQNext remains -inf (no actions available)
            if isinf(maxQNext)
                maxQNext = 0;
            end
            
            % Update Q-value using the Q-learning formula
            oldQValue = obj.qTable(currentKey);
            newQValue = oldQValue + obj.learningRate * (reward + obj.discountFactor * maxQNext - oldQValue);
            
            % Check for NaN in the new Q-value
            if isnan(newQValue)
                error('NaN detected in Q-value calculation.');
            end
            
            obj.qTable(currentKey) = newQValue;
        end
        
        % Method to choose an action based on the exploration-exploitation trade-off
        function action = chooseAction(obj, state, possibleActions)
            % Validate possibleActions
            if isempty(possibleActions)
                error('Possible actions cannot be empty.');
            end
            
            % Exploration vs. exploitation
            if rand < obj.explorationRate
                % Exploration: choose a random action
                action = possibleActions(randi(numel(possibleActions)));
            else
                % Exploitation: choose the action with the highest Q-value
                maxQValue = -inf;
                bestActions = [];
                
                for i = 1:numel(possibleActions)
                    key = obj.createKey(state, possibleActions(i));
                    if isKey(obj.qTable, key)
                        qValue = obj.qTable(key);
                        if qValue > maxQValue
                            maxQValue = qValue;
                            bestActions = possibleActions(i);
                        elseif qValue == maxQValue
                            bestActions = [bestActions, possibleActions(i)];
                        end
                    end
                end
                
                % Handle case where bestActions is empty
                if isempty(bestActions)
                    action = possibleActions(randi(numel(possibleActions)));
                else
                    action = bestActions(randi(numel(bestActions)));
                end
            end
        end
        
        % Method to decrease the exploration rate over time
        function obj = decreaseExplorationRate(obj)
            % Ensure exploration rate is non-negative and does not go below 0.01
            obj.explorationRate = max(obj.explorationRate * 0.99, 0.01);
        end
        
        % Helper method to get possible actions for a given state
        function actions = getPossibleActions(~, ~)
            % This method should be overridden based on the specific environment
            % Example: Define a set of possible actions
            actions = 1:4; % Example: 4 possible actions
        end
    end
    
    methods (Access = private)
        % Helper method to create a unique key for state-action pair
        function key = createKey(~, state, action)
            key = strcat(num2str(state), '-', num2str(action));
        end
    end
end
