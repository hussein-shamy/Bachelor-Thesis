classdef RadioPlanning

    properties
        
    end

    methods (Static)

        function mobileStations = allocateMobileStationsFromCenter(mobileStations, centerBaseStation)
            % Function to assign random locations to mobile stations around a center base station
            % Returns the updated mobileStations array with locations assigned

            % Extract center base station location
            centerLocation = centerBaseStation.location;

            % Generate random offsets for latitude and longitude (for example, within ±0.01 degrees)
            maxOffset = 0.01;
            for i = 1:length(mobileStations)
                % Generate random offsets
                offsetLat = (rand() * 2 - 1) * maxOffset;
                offsetLon = (rand() * 2 - 1) * maxOffset;

                % Calculate random location around the center base station
                randomLocation = centerLocation + [offsetLat, offsetLon];

                % Assign the random location to the mobile station
                mobileStations(i).location = randomLocation;
            end

        end


        function neighbouringSites = allocateNeighbouringSitesFromCenter(centerBaseStation, neighbouringSites)
            % Function to allocate 6 neighboring sites in a hexagonal shape around a center base station
            % Inputs:
            %   - centerBaseStation: object with 'location' property [Latitude, Longitude]
            %   - neighbouringSites: array of objects with 'location' properties [Latitude, Longitude]
            % Output:
            %   - neighbouringSites: array of updated objects with assigned 'location' properties
            
            % Extract center location from center base station object
            centerLocation = centerBaseStation.location;
            
            % Constants for hexagonal shape
            hexDist = 0.01; % Distance between center and neighboring sites (adjust as needed)
            
            % Calculate positions based on hexagonal grid
            % Sites are numbered clockwise from 1 to 6 around the center
            theta = pi/3 * (0:5); % Angles for hexagon points
            
            for i = 1:numel(neighbouringSites)
                % Calculate coordinates of each neighbouring site
                neighbouringSites(i).location = centerLocation + hexDist * [cos(theta(i)), sin(theta(i))];
            end
        end
    end
end
