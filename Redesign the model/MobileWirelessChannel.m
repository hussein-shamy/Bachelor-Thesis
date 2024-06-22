classdef MobileWirelessChannel

    methods (Static)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Function
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function receivedPower = calculateReceivedPower(BaseStation, mobileStationArray, Environment)
            % Calculate the received power from each sector of the base station
            % Inputs:
            %   - BaseStation: object with 'location' and 'cellList' properties
            %   - MobileStation: object with 'location' and 'ANTENNA_GAIN' property
            %   - Environment: string indicating the type of environment (e.g., 'urban', 'suburban', 'rural', 'open')
            % Output:
            %   - receivedPower: array of received power values from each sector

            numCells = numel(BaseStation.cellList);
            numUsers = numel(mobileStationArray);

            BS_Height = BaseStation.height;
            MS_Height = mobileStationArray(1).ANTENNA_HEIGHT;
            receiverAntennaGain = mobileStationArray(1).ANTENNA_GAIN;
            receivedPower = zeros(numUsers, numCells); % Preallocate an array for efficiency
            transmitPower = zeros(numCells,1);
            Cells_Freq = zeros(numCells,1);
            BS_Location = BaseStation.location;
            MS_Array_Locations = zeros(numUsers,2);

            for User_ID = 1:numUsers
                MS_Array_Locations(User_ID, :) = mobileStationArray(User_ID).location;
            end

            for Cell_ID = 1:numCells
                transmitPower(Cell_ID) = BaseStation.cellList{Cell_ID}.power;
                Cells_Freq(Cell_ID)= BaseStation.cellList{Cell_ID}.frequecny;
            end

            Users_Distance = MobileWirelessChannel.calculateDistance(BS_Location, MS_Array_Locations, numUsers);

            pathloss = MobileWirelessChannel.calculatePathLoss(BS_Height,MS_Height,Users_Distance,Cells_Freq,numUsers,numCells, Environment);

            transimtterGain = MobileWirelessChannel.calculateTotalTransmitterGain(BaseStation, mobileStationArray,Users_Distance,MS_Array_Locations);

            % Calculate received power for the current cell
            for User_ID = 1 : numUsers
                for Cell_ID = 1:numCells
                    receivedPower(User_ID,Cell_ID) = transmitPower(Cell_ID) + transimtterGain(User_ID,Cell_ID) + receiverAntennaGain - pathloss(User_ID,Cell_ID);
                end
            end

        end
    end

    methods (Static, Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Function
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function distance = calculateDistance(BS_Location, MS_Array_Locations, NumofUsers)
            % Calculate the distance between the base station and mobile stations
            % Inputs:
            %   - BaseStation: object with 'location' property [Latitude, Longitude]
            %   - MobileStations: array of objects with 'location' properties [Latitude, Longitude]
            % Output:
            %   - distance: array of distances between base station and each mobile station

            R = 6371; % Radius of Earth in kilometers
            distance = zeros(NumofUsers,1);

            % Loop through each mobile station and calculate distance
            for i = 1:NumofUsers

                mobileLocation = MS_Array_Locations(i,:);

                % Convert latitude and longitude from degrees to radians
                lat1 = deg2rad(BS_Location(1));
                lon1 = deg2rad(BS_Location(2));
                lat2 = deg2rad(mobileLocation(1));
                lon2 = deg2rad(mobileLocation(2));

                dLat = lat2 - lat1;
                dLon = lon2 - lon1;

                a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
                c = 2 * atan2(sqrt(a), sqrt(1 - a));

                distance(i,1) = R * c; % Distance in kilometers

            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Function
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function pathLoss = calculatePathLoss(BS_Height,MS_Height,Users_Distance,Cells_Freq,NumUsers,NumCells, Environment)
            % Calculate the path loss based on environment

            pathLoss = zeros(NumUsers,NumCells);

            % Convert environment name to lowercase for case-insensitive comparison
            scenario = lower(Environment);


            for User_ID = 1:NumUsers

                for Cell_ID = 1:NumCells

                    % Calculate path loss based on scenario
                    switch scenario
                        case 'urban'
                            % Urban Macro Cell (UMa)
                            pathLoss(User_ID,NumCells) = 28 + 22 * log10(Users_Distance(NumUsers)) + 20 * log10(Cells_Freq(Cell_ID)) + ...
                                10 * log10((BS_Height * MS_Height) / (1.5^2)) - ...
                                (3.2 * (log10(11.75 * MS_Height))^2) - 0.5;

                        case 'suburban'
                            % Suburban Macro Cell (UMi)
                            pathLoss(User_ID,NumCells) = 32.5 + 20 * log10(Users_Distance(NumUsers)) + 20 * log10(Cells_Freq(Cell_ID)) + ...
                                10 * log10((BS_Height * MS_Height) / (1.5^2)) - ...
                                (9 * (log10((MS_Height)^2 / 3.5))^2) - 0.5;

                        case 'rural'
                            % Rural Macro Cell (RMa)
                            pathLoss(User_ID,NumCells) = 28 + 20 * log10(Users_Distance(NumUsers)) + 20 * log10(Cells_Freq(Cell_ID)) + ...
                                10 * log10((BS_Height * MS_Height) / (1.5^2)) - ...
                                (2 * (log10((MS_Height / 3)^2))^2) - 0.5;

                        case 'open'
                            % Open Area (Oa)
                            pathLoss(User_ID,NumCells) = 32.4 + 20 * log10(Users_Distance(NumUsers)) + 20 * log10(Cells_Freq(Cell_ID)) - ...
                                10 * log10((BS_Height * MS_Height) / (1.5^2));

                        otherwise
                            error('Invalid scenario');
                    end

                end

            end

        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Function
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function totalGainTx = calculateTotalTransmitterGain(BaseStation, mobileStationArray,Users_Distance,MS_Array_Locations)
            % Calculate the total transmitter gain based on horizontal and vertical gains

            horizontalSLL = BaseStation.SLL_HORIZONTAL;
            verticalSLL = BaseStation.SLL_VERTICAL;
            horizontalHPBW = BaseStation.HPBW_HORIZONTAL;
            verticalHPBW = BaseStation.HPBW_VERTICAL;
            MS_Height = mobileStationArray(1).ANTENNA_HEIGHT;
            BS_Height = BaseStation.height;
            BS_AntennaGain = BaseStation.MAX_ANTENNA_GAIN;
            numCells = numel(BaseStation.cellList);
            numUsers = numel(mobileStationArray);


            theta = zeros(numUsers,1);
            totalGainTx = zeros(numUsers,numCells);

            angleBetweenLines = MobileWirelessChannel.calculateAngleBetweenLines(BaseStation,MS_Array_Locations);

            for UserID = 1:numUsers
                theta(UserID) = atan((BS_Height - MS_Height) / Users_Distance(UserID));
            end

            for CellID = 1:numCells
                for UserID = 1:numUsers
                    verticalGain = max(-12 * ((theta(UserID) - BaseStation.cellList{CellID}.tilt) /verticalHPBW)^2, verticalSLL);
                    horizontalGain = max(-12 * (angleBetweenLines(UserID,CellID) / horizontalHPBW)^2, horizontalSLL);
                    totalGainTx(UserID,CellID)  = max(horizontalGain + verticalGain, horizontalSLL + verticalSLL) + BS_AntennaGain;
                end
            end

        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Function
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function angleDegrees = calculateAngleBetweenLines(BaseStation,MS_Array_Locations)
            % Calculate the angle between two lines defined by three points.
            
            NumCells = numel(BaseStation.cellList);
            NumUsers = numel(MS_Array_Locations)/2;
            BS_Location = BaseStation.location;
            deltaLat1 = zeros(1,NumCells);
            deltaLon1 = zeros(1,NumCells);
            deltaLat2 = zeros(1,NumUsers);
            deltaLon2 = zeros(1,NumUsers);
            angleDegrees = zeros(NumUsers,NumCells);

            for Cell_ID = 1:NumCells
                % Calculate the differences in latitudes and longitudes
                deltaLat1(Cell_ID) = BaseStation.cellList{Cell_ID}.maxPowerLocation(1) - BS_Location(1);
                deltaLon1(Cell_ID) = BaseStation.cellList{Cell_ID}.maxPowerLocation(2) - BS_Location(2);
            end

            for UserID = 1:NumUsers
                deltaLat2(UserID) = MS_Array_Locations(UserID,1) - BS_Location(1);
                deltaLon2(UserID) = MS_Array_Locations(UserID,2) - BS_Location(2);
            end

            for UserID = 1:NumUsers
                for Cell_ID = 1:NumCells
                    % Calculate the angles of the lines relative to the x-axis
                    theta1 = atan2(deltaLon1(Cell_ID), deltaLat1(Cell_ID));
                    theta2 = atan2(deltaLon2(UserID), deltaLat2(UserID));
                    % Calculate the angle between the two lines
                    deltaTheta = abs(theta1 - theta2);
                    % Ensure the angle is within the range [0, pi)
                    if deltaTheta >= pi
                        deltaTheta = 2 * pi - deltaTheta;
                    end
                    % Convert angle to degrees
                    angleDegrees(UserID,Cell_ID) = rad2deg(deltaTheta);
                end
            end
        end
    end
end
