%{
---------------------------------------------------------------------------
%% Class Name: QLearning
---------------------------------------------------------------------------
DESCRIPTION: represents an implementation of the Q-Learning algorithm for
cell outage compensation. It provides a mechanism to autonomously optimize 
the compensation strategy in a cellular network to mitigate the impact of 
cell outages.

NOTES:

CONTRIBUTORS: Mohamed Shalaby

DATE: 25 June 2023
---------------------------------------------------------------------------
%}

classdef QLearning<CellularEnvironment

    properties(Constant)
        
        % Number of episodes
        numEpisodes = 10;                                                    
        
        % Number of steps per episode
        stepsPerEpisode = 100;                                               
        
        % Discount factor
        discountFactor = 0.1;                                                
        
        % Number of actions
        numActions = 9;                                                      
        
        % Action names
        actionNames = {'increase_power & increase_tilt', ...                 
                        'increase_power & decrease_tilt', ...
                        'increase_power & const_tilt', ...
                        'decrease_power & increase_tilt', ...
                        'decrease_power & decrease_tilt', ...
                        'decrease_power & const_tilt', ...
                        'const_power & increase_tilt', ...
                        'const_power & decrease_tilt', ...
                        'const_power & const_tilt'};   

        % Action power values
        actionTable_power = [0.2 0.2 0.2 -0.2 -0.2 -0.2 0 0 0];    
        
        % Action tilt values
        actionTable_tilt = [0.2 -0.2 0 0.2 -0.2 0 0.2 -0.2 0];               
        
        % State names
        stateNames = {'0%AGap', 'AGap<20%', 'AGap<40%', 'AGap<60%', ...
                      'AGap<80%', 'AGap<100%', '100% AGap'};  

        % Number of states
        numStates = 7;     

    end

    properties

        % Current state
        state;

        % Q-Value
        Q;

        % Exploration-exploitation trade-off factor
        epsilon = 0.5;

        % Learning rate
        learningRate = 0.7;

        % Intermediate site information
        inter_site;

    end

    methods

        %{
---------------------------------------------------------------------------
%% Method Name: QLearning
---------------------------------------------------------------------------
Description: This constructor initializes a new 'QLearning' object with
the provided tilt, frequency, environment type, transmitter power,
number of users, and inter-site distance. The object inherits these
attributes from the parent classes (ChannelLink and CellularEnvironment).

Input Arguments:
- tilt
- freq
- env
- tx_power
- NumU
- inter_site

Output Arguments:
- obj

Notes: 

Author: Mohamed Shalaby

Date: 25 June 2023 
---------------------------------------------------------------------------
        %}
        function obj = QLearning(tilt,freq,env,tx_power,NumU,inter_site)
            obj@CellularEnvironment(tilt,freq,env,tx_power,NumU,inter_site);
            obj.txs_tilt = ones(obj.numCellSites,1)*obj.tilt;
            obj.Q = rand(obj.numStates*3, obj.numActions);
        end
        %{
---------------------------------------------------------------------------
%% Method Name: q_learning
---------------------------------------------------------------------------
Description: 

Input Arguments: 
- obj

Output Arguments:
- q

Notes: 

Author: Mohamed Shalaby

Date: 25 June 2023 
---------------------------------------------------------------------------
        %}
        function q = q_learning(obj)
            [AGap,AOverlap] = obj.evaluation;
            if AGap == 0
                obj.state = 1;
            elseif AGap*100 < 20 && AGap*100 > 0
                obj.state = 2;
            elseif AGap*100 < 40 && AGap*100 >= 20
                obj.state = 3;
            elseif AGap*100 < 60 && AGap*100 >= 40
                obj.state = 4;
            elseif AGap*100 < 80 && AGap*100 >= 60
                obj.state = 5;
            elseif AGap*100 < 100 && AGap*100 >= 80
                obj.state = 6;
            else
                obj.state = 7;
            end
            for episode = 1:obj.numEpisodes
                for step = 1:obj.stepsPerEpisode
                    for i = 1:3
                        % Choose action based on epsilon-greedy policy
                        if rand < obj.epsilon
                            action = randi(obj.numActions);
                        else
                            [~, action] = max(obj.Q(obj.state + 7*(i-1), :));
                        end
                        % Take action and observe new state and reward
                        obj.txs_power(2*i) = obj.txs_power(2*i) + obj.actionTable_power(action);
                        obj.txs_tilt(2*i) = obj.txs_tilt(2*i) + obj.actionTable_tilt(action);
                        AGap_old = AGap;
                        AOverlap_old = AOverlap;
                        obj.tx_power = obj.txs_power(2*i);
                        obj.tilt = obj.txs_tilt(2*i);
                        [AGap,AOverlap] = obj.evaluation;
                        state_old = obj.state;
                        if AGap == 0
                            obj.state = 1;
                        elseif AGap*100 < 20 && AGap*100 > 0
                            obj.state = 2;
                        elseif AGap*100 < 40 && AGap*100 >= 20
                            obj.state = 3;
                        elseif AGap*100 < 60 && AGap*100 >= 40
                            obj.state = 4;
                        elseif AGap*100 < 80 && AGap*100 >= 60
                            obj.state = 5;
                        elseif AGap*100 < 100 && AGap*100 >= 80
                            obj.state = 6;
                        else
                            obj.state = 7;
                        end
                        if AGap<AGap_old && AOverlap <= 1.04*AOverlap_old
                            reward = 6;
                        elseif AGap<AGap_old && AOverlap > 1.04*AOverlap_old
                            reward = 3;
                        elseif AGap>AGap_old
                            reward = -2;
                        else
                            if obj.state == 1
                                obj.Q(1 + 7*(i-1),find(strcmp(obj.actionNames, 'const_power & const_tilt'))) = 10;
                                obj.epsilon = 0;
                            else
                                reward = 1;
                            end
                        end
                        obj.Q(state_old + 7*(i-1), action) = obj.Q(state_old + 7*(i-1), action) +...
                            obj.learningRate * (reward + obj.discountFactor * max(obj.Q(obj.state + 7*(i-1), :))...
                            - obj.Q(state_old + 7*(i-1), action));
                    end
                end
            end
            q = obj.Q;
        end
        %{
---------------------------------------------------------------------------
%% Method Name: results
---------------------------------------------------------------------------
Description: Test Final Policy

Input Arguments:
- obj

Output Arguments: 

Notes: 

Author: Mohamed Shalaby

Date: 25 June 2023 
---------------------------------------------------------------------------
        %}
        function []=results(obj)
            step_i = 0;
            AGap = obj.evaluation;
            q = obj.q_learning;
            tx_power_vec = zeros(obj.stepsPerEpisode,3);
            tx_tilt_vec = zeros(obj.stepsPerEpisode,3);
            AGap_vec = zeros(obj.stepsPerEpisode*3,1);
            AOverlap_vec = zeros(obj.stepsPerEpisode*3,1);
            % Determine state index based on AGap value
            if AGap == 0
                obj.state = 1;
            elseif AGap*100 < 20 && AGap*100 > 0
                obj.state = 2;
            elseif AGap*100 < 40 && AGap*100 >= 20
                obj.state = 3;
            elseif AGap*100 < 60 && AGap*100 >= 40
                obj.state = 4;
            elseif AGap*100 < 80 && AGap*100 >= 60
                obj.state = 5;
            elseif AGap*100 < 100 && AGap*100 >= 80
                obj.state = 6;
            else
                obj.state = 7;
            end
            for step = 1:obj.stepsPerEpisode
                for i = 1:3
                    step_i = step_i + 1;
                    [~, action] = max(q(obj.state + 7*(i-1), :));
                    obj.txs_power(2*i) = obj.txs_power(2*i) + obj.actionTable_power(action);
                    obj.txs_tilt(2*i) = obj.txs_tilt(2*i) + obj.actionTable_tilt(action);
                    obj.tx_power = obj.txs_power(2*i);
                    obj.tilt = obj.txs_tilt(2*i);
                    [AGap_vec(step_i),AOverlap_vec(step_i)] = obj.evaluation;
                    tx_power_vec(step,i) = obj.txs_power(2*i);
                    tx_tilt_vec(step,i) = obj.txs_tilt(2*i);
                    if AGap_vec(step_i) == 0
                        obj.state = 1;
                    elseif AGap_vec(step_i)*100 < 20 && AGap_vec(step_i)*100 > 0
                        obj.state = 2;
                    elseif AGap_vec(step_i)*100 < 40 && AGap_vec(step_i)*100 >= 20
                        obj.state = 3;
                    elseif AGap_vec(step_i)*100 < 60 && AGap_vec(step_i)*100 >= 40
                        obj.state = 4;
                    elseif AGap_vec(step_i)*100 < 80 && AGap_vec(step_i)*100 >= 60
                        obj.state = 5;
                    elseif AGap_vec(step_i)*100 < 100 && AGap_vec(step_i)*100 >= 80
                        obj.state = 6;
                    else
                        obj.state = 7;
                    end
                end
            end
            subplot(3,3,[1,2]);
            plot(1:obj.stepsPerEpisode*3, AGap_vec);
            title('Testing Final Policy w.r.t AGap');
            xlabel('Steps');
            ylabel('AGap');
            subplot(3,3,3);
            plot(1:obj.stepsPerEpisode*3, AOverlap_vec);
            title('Testing Final Policy w.r.t AOverlap');
            xlabel('Steps');
            ylabel('AOverlap');
            subplot(3,3,4);
            plot(1:obj.stepsPerEpisode, tx_power_vec(:,1));
            title('1st Compensating Cell Power');
            xlabel('Steps');
            ylabel('Power In dBm');
            subplot(3,3,5);
            plot(1:obj.stepsPerEpisode, tx_power_vec(:,2));
            title('2nd Compensating Cell Power');
            xlabel('Steps');
            ylabel('Power In dBm');
            subplot(3,3,6);
            plot(1:obj.stepsPerEpisode, tx_power_vec(:,3));
            title('3rd Compensating Cell Power');
            xlabel('Steps');
            ylabel('Power In dBm');
            subplot(3,3,7);
            plot(1:obj.stepsPerEpisode, tx_tilt_vec(:,1));
            title('1st Compensating Cell Tilt');
            xlabel('Steps');
            ylabel('Tilt In Degrees');
            subplot(3,3,8);
            plot(1:obj.stepsPerEpisode, tx_tilt_vec(:,2));
            title('2nd Compensating Cell Tilt');
            xlabel('Steps');
            ylabel('Tilt In Degrees');
            subplot(3,3,9);
            plot(1:obj.stepsPerEpisode, tx_tilt_vec(:,3));
            title('3rd Compensating Cell Tilt');
            xlabel('Steps');
            ylabel('Tilt In Degrees');
        end
    end
end
%{
---------------------------------------------------------------------------
%% END OF THE CLASS IMPLEMENTATION
---------------------------------------------------------------------------
%}