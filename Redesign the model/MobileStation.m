classdef MobileStation

    properties (Constant)
        ANTENNA_GAIN = 5;
        ANTENNA_HEIGHT = 1.5;
        SENSITIVITY = -110;
    end

    properties
        id                        % Unique identifier for the user
        location                  % Location of the user (e.g., [x, y] coordinates)
        is_connected
        connected_base_station
    end
    
    methods
        % Constructor method to create a new User object
        function obj = MobileStation(id)
            if nargin > 0
                obj.id = id;
                obj.location = [0,0];
                obj.is_connected = false;
            end
        end

        function cellsInfo = cellSearch(BaseStationsArray)

            % Ensure the input is an array of MyClass objects
            if ~isa(BaseStationsArray, 'BaseStation')
                error('Input must be an array of MyClass objects');
            end
            
            % Preallocation
            cellsInfo = zeros(50,3);

            for i = 1:length(objArray)
                cellsInfo(i,1) = BaseStationsArray(i).id;
                cellsInfo(i,2) = BaseStationsArray(i).cells.id;
                cellsInfo(i,3) = BaseStationsArray(i).cells.power;
            end

        end

        function selectedCell = cellSelection(cellsInfo)
            % cellSelection function selects the best cell based on signal strength

            numCells = numel(cellsInfo); % Number of cells

            % Initialize variables to track the best cell
            bestSignalStrength = -inf;
            bestCells = zeros(50,3);
            selectedCell = []; % Initially no cell selected

            bestCells_Index  = 0;

            for cell_Index = 1:numCells

                signalStrength = cellsInfo(cell_Index,3);
               
                if (signalStrength > obj.SENSITIVITY)
                bestCells(bestCells_Index,1) =  cellsInfo(cell_Index,1);
                bestCells(bestCells_Index,2) =  cellsInfo(cell_Index,2);
                bestCells(bestCells_Index,3) =  cellsInfo(cell_Index,3);
                bestCells_Index = bestCells_Index + 1; 
                end

            end

            numBestCells = numel(bestCells); % Number of cells

            for bestCells_Index = 0 : numBestCells

                if (bestSignalStrength<signalStrength)
                    bestSignalStrength = signalStrength;
                    selectedCell(1,1) = bestCells(bestCells_Index,1);
                    selectedCell(1,2) = bestCells(bestCells_Index,2);
                    selectedCell(1,3) = bestCells(bestCells_Index,3);
                end

            end

        end

        function displayUserDetails(obj)
            fprintf('User ID: %d\n', obj.id);
            fprintf('Location: [%f, %f]\n', obj.location(1), obj.location(2));
            fprintf('Mobile Station Antenna Height: %f meters\n', obj.antennaHeight);
            fprintf('Receiver Antenna Gain: %f dB\n', obj.antennaGain);
            fprintf('UE Sensitivity: %f dBm\n', obj.sensitivity);
        end

    end
end
