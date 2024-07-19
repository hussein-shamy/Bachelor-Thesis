classdef BaseStation
    
    properties (Constant)
        HPBW_HORIZONTAL     = 120;       % Horizontal HPBW in degrees
        HPBW_VERTICAL       = 10;        % Vertical HPBW in degrees
        SLL_HORIZONTAL      = -20;       % Horizontal SLL in dB
        SLL_VERTICAL        = -18;       % Vertical SLL in dB
        MAX_ANTENNA_GAIN    = 18;        % Maximum antenna gain in both directions in dB
    end

    properties
        id            % Unique identifier for the site
        location      % Location of the site (e.g., city or coordinates)
        height        % Height of the base station
        cellList      % List of cells associated with the base station
    end
    
    methods
        % Constructor method to create a new BaseStation object
        function obj = BaseStation(id)
            if nargin > 0
                obj.id = id;
                obj.location = [0,0];
                obj.height = 50;
                obj.cellList = {}; % Initialize cell list as empty cell array
            end
        end

        % Method to add cell(s) to the base station
        function obj = addCell(obj, cells)
            if isa(cells, 'Cell')
                if isscalar(cells)
                    obj.cellList = vertcat(obj.cellList, {cells}); % Add single Cell object
                else
                    obj.cellList = vertcat(obj.cellList, num2cell(cells)); % Add array of Cell objects
                end
            else
                error('Input must be a Cell object or an array of Cell objects');
            end
        end

        % Method to remove a cell from the base station by ID
        function obj = removeCell(obj, cell_id)
            % Find index of cells with matching id
            idx = find(cellfun(@(c) c.id == cell_id, obj.cellList));
            % Check if any matching cells are found
            if isempty(idx)
                error('No cell with the specified ID found.');
            else
                % Remove cells at found indices
                obj.cellList(idx) = [];
            end
        end
        
        % Method to display the list of cells in the base station
        function displayCells(obj)
            if isempty(obj.cellList)
                disp('No cells in the base station.');
            else
                disp('Cells in the base station:');
                for i = 1:length(obj.cellList)
                    cell = obj.cellList{i};
                    fprintf('Cell ID: %d\n', cell.id);
                end
            end
        end
        
        % Method to print details of all cells associated with the base station
        function printCellDetails(obj)
            fprintf('Cells associated with Base Station %s:\n', obj.id);
            for i = 1:numel(obj.cellList)
                fprintf('Cell ID: %d\n', obj.cellList{i}.id);
                fprintf('Signal Strength: %f\n', obj.cellList{i}.power);
                fprintf('Tilt: %f\n', obj.cellList{i}.tilt);
                fprintf('Is Outage: %d\n', obj.cellList{i}.is_active);
                fprintf('\n');
            end
        end
    end
end
