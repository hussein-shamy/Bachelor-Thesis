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
        function obj = BaseStation(id, location, height)
            if nargin > 0
                obj.id = id;
                obj.location = location;
                obj.height = height;
                obj.cellList = {}; % Initialize cell list as empty cell array
            end
        end
        
        % Method to add cell(s) to the base station
        function obj = addCell(obj, cells)
            if isa(cells, 'Cell')
                % If cells is a single Cell object
                obj.cellList{end+1} = cells;
            elseif iscell(cells)
                % If cells is a cell array of Cell objects
                obj.cellList = [obj.cellList, cells];
            elseif isnumeric(cells) && numel(cells) > 1 && isa(cells(1), 'Cell')
                % If cells is an array of Cell objects
                obj.cellList = [obj.cellList, cells];
            else
                error('Invalid input. Expected Cell object, cell array of Cell objects, or array of Cell objects.');
            end
        end
        
        % Method to remove a cell from the base station by ID
        function obj = removeCell(obj, cell_id)
            % Find index of cells with matching id
            idx = find(cellfun(@(c) c.id == cell_id, obj.cellList));
            % Remove cells at found indices
            obj.cellList(idx) = [];
        end
        
        % Method to get the list of cells in the base station
        function cells = getCells(obj)
            cells = obj.cellList; % Return the cellList
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
