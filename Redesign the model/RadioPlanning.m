classdef RadioPlanning

    methods (Static)

        function mobileStations = allocateMobileStationsFromCenter(mobileStations, centerBaseStation, interSiteDistance)
            % Function to assign random locations to mobile stations around a center base station
            % Returns the updated mobileStations array with locations assigned

            % Constants for cell radius calculation
            cellRadius = interSiteDistance * sqrt(3) / 2; % Hexagonal cell radius

            % Extract center base station location
            centerLocation = centerBaseStation.location;

            % Generate random offsets within the cell radius
            for i = 1:length(mobileStations)
                % Generate random radial distance within the cell radius
                r = cellRadius * sqrt(rand());

                % Generate random angle
                theta = 2 * pi * rand();

                % Calculate random offset in Cartesian coordinates
                offsetLat = r * cos(theta);
                offsetLon = r * sin(theta);

                % Calculate random location around the center base station
                randomLocation = centerLocation + [offsetLat, offsetLon];

                % Assign the random location to the mobile station
                mobileStations(i).location = randomLocation;
            end

        end


        function neighbouringSites = allocateNeighbouringSitesFromCenter(centerBaseStation, neighbouringSites, interSiteDistance)
            % Function to allocate neighboring sites around a center base station in a hexagonal shape
            % Inputs:
            %   - centerBaseStation: object with 'location' property [Latitude, Longitude]
            %   - neighbouringSites: array of objects with 'location' properties [Latitude, Longitude]
            %   - interSiteDistance: desired distance between neighboring sites
            % Output:
            %   - neighbouringSites: array of updated objects with assigned 'location' properties

            % Extract center location from center base station object
            centerLocation = centerBaseStation.location;

            % Constants for hexagonal shape
            hexDist = interSiteDistance; % Distance between center and neighboring sites

            % Calculate positions based on hexagonal grid
            % Sites are numbered clockwise from 1 to 6 around the center
            theta = pi/3 * (0:5); % Angles for hexagon points

            for i = 1:numel(neighbouringSites)
                % Calculate coordinates of each neighbouring site
                neighbouringSites(i).location = centerLocation + hexDist * [cos(theta(i)), sin(theta(i))];
            end
        end

        function site = calculateMaxRadiationDirection(site, isd)

            % Earth's radius in kilometers
            R = 6371;

            % Convert degrees to radians for base station location
            baseLat = deg2rad(site.location(1));
            baseLon = deg2rad(site.location(2));

            % Iterate over each cell in the site
            numCells = numel(site.cellList);
            for Cell_ID = 1:numCells
                azimuth = deg2rad(site.cellList{Cell_ID}.azimuth);
                tilt = deg2rad(site.cellList{Cell_ID}.tilt);

                % Calculate the displacement in the local tangent plane
                deltaX = isd / sqrt(3) * cos(tilt) * sin(azimuth);
                deltaY = isd / sqrt(3) * cos(tilt) * cos(azimuth);

                % Convert local tangent plane displacement to latitude and longitude
                deltaLat = deltaY / R;
                deltaLon = deltaX / (R * cos(baseLat));

                % Calculate the new latitude and longitude for max power location
                maxLat_rad = baseLat + deltaLat;
                maxLon_rad = baseLon + deltaLon;

                % Convert radians back to degrees
                maxLat_deg = rad2deg(maxLat_rad);
                maxLon_deg = rad2deg(maxLon_rad);

                % Assign max power location to the cell
                site.cellList{Cell_ID}.maxPowerLocation = [maxLat_deg, maxLon_deg];
            end
        end

    end
end
