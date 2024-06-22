classdef Cell
   
    properties
        id                        % Unique identifier for the cell
        power                     % Signal strength of the cell
        tilt
        maxPowerLocation
        frequecny
        is_active                 % Boolean flag indicating if the cell is in outage
    end
    
    methods
        % Constructor method to create a new Cell object
        function obj = Cell(id)
            if nargin > 0
                obj.id = id;
                obj.power = 40;
                obj.tilt = 90;
                obj.frequecny = 3.5;
                obj.is_active = 1;
            end
        end
        
        % Method to adjust power level of the cell
        function obj = adjust_power(obj, level)
            obj.power = level;
            fprintf('Cell ID %d: Signal strength adjusted to %f\n', obj.id, obj.power);
        end
        
        % Method to reroute traffic of the cell
        function obj = reroute_traffic(obj)
            if obj.is_active
                obj.capacity = 0;
                fprintf('Cell ID %d: Traffic rerouted due to outage\n', obj.id);
            else
                fprintf('Cell ID %d: No outage, traffic rerouting not required\n', obj.id);
            end
        end
        
        % Method to display cell details
        function displayCellDetails(obj)
            fprintf('Cell ID: %d\n', obj.id);
            fprintf('Signal Strength: %f\n', obj.power);
            fprintf('Is Outage: %d\n', obj.is_active);
        end
    end
end
