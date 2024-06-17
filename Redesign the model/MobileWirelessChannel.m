classdef MobileWirelessChannel
    properties
        mobileStation % Mobile station object
        baseStation % Base station object
        environment
    end

    methods
        function obj = MobileWirelessChannel(mobileStation,baseStation,environment)
            % Constructor to initialize the properties
            obj.mobileStation = mobileStation;
            obj.baseStation = baseStation;
            obj.environment = environment;
        end

        function distance = calculateDistance(obj)
            % Calculate the distance between the mobile station and base station
            RX_Distance = [obj.mobileStation.location(1) * 111139 , obj.mobileStation.location(2) * 111139 ] ;

            TX_Distance = [obj.baseStation.location(1) * 111139 , obj.baseStation.location(2) * 111139];

            % Calculate the distance using the Euclidean distance formula
            distance = sqrt((TX_Distance(1) - RX_Distance(1))^2 + (TX_Distance(1) - RX_Distance(2))^2);
        end


        function angleDegrees = calculateAngleBetweenLines(obj)
            % Calculate the angle between two lines defined by three points.

            % Calculate the differences in latitudes and longitudes
            deltaLat1 = obj.baseStation.cell.maxPowerLocation(1) - obj.baseStation.location(1);
            deltaLon1 = obj.baseStation.cell.maxPowerLocation(2) - obj.baseStation.location(2);
            deltaLat2 = obj.mobileStation.location(1) - obj.baseStation.location(1);
            deltaLon2 = obj.mobileStation.location(2) - obj.baseStation.location(2);

            % Calculate the angles of the lines relative to the x-axis
            theta1 = atan2(deltaLon1, deltaLat1);
            theta2 = atan2(deltaLon2, deltaLat2);

            % Calculate the angle between the two lines
            deltaTheta = abs(theta1 - theta2);

            % Ensure the angle is within the range [0, pi)
            if deltaTheta >= pi
                deltaTheta = 2 * pi - deltaTheta;
            end

            % Convert angle to degrees
            angleDegrees = rad2deg(deltaTheta);
        end

        function totalGainTx = calculateTotalTransmitterGain(obj)
            % Constants
            horizontalSLL = obj.baseStation.SLL_HORIZONTAL;
            verticalSLL = obj.baseStation.SLL_VERTICAL;

            % Calculate the horizontal gain of the transmitter's antenna
            angleBetweenLines = obj.calculateAngleBetweenLines();
            horizontalGain = max(-12 * (angleBetweenLines / obj.baseStation.HPBW_HORIZONTAL)^2, SLL_VERTICAL);

            % Calculate the vertical gain of the transmitter's antenna
            theta = atan((obj.baseStation.height - obj.mobileStation.tilt) / (obj.calculateAngleBetweenLines() * 1000));
            verticalGain = max(-12 * ((theta - obj.baseStation.cell.tilt) / obj.baseStation.HPBW_VERTICAL)^2,obj.baseStation.SLL_VERTICAL);

            % Calculate the total gain
            totalGainTx = max(horizontalGain + verticalGain, horizontalSLL + verticalSLL) + obj.baseStation.MAX_ANTENNA_GAIN;
        end


        function pathLoss = calculatePathLoss(obj)
            % Constants
            baseStationHeight = obj.baseStation.height;
            mobileStationHeight = obj.mobileStation.height;
            frequency = obj.baseStation.cell.frequency;
            distance = obj.calculateDistance() * 1000;

            % Convert environment name to lowercase for case-insensitive comparison
            scenario = lower(obj.environment);

            % Calculate path loss based on scenario
            switch scenario
                case 'urban'
                    % Urban Macro Cell (UMa)
                    pathLoss = 28 + 22*log10(distance) + 20*log10(frequency) + ...
                        10*log10((baseStationHeight * mobileStationHeight) / (1.5^2)) - (3.2*(log10(11.75 * mobileStationHeight))^2) - 0.5;

                case 'suburban'
                    % Suburban Macro Cell (UMi)
                    pathLoss = 32.5 + 20*log10(distance) + 20*log10(frequency) + ...
                        10*log10((baseStationHeight * mobileStationHeight) / (1.5^2)) - (9*(log10((mobileStationHeight)^2 / 3.5))^2) - 0.5;

                case 'rural'
                    % Rural Macro Cell (RMa)
                    pathLoss = 28 + 20*log10(distance) + 20*log10(frequency) + ...
                        10*log10((baseStationHeight * mobileStationHeight) / (1.5^2)) - (2*(log10((mobileStationHeight / 3)^2))^2) - 0.5; %}

                case 'open'
                    % Open Area (Oa)
                    pathLoss = 32.4 + 20*log10(distance) + 20*log10(frequency) - ...
                        10*log10((baseStationHeight * mobileStationHeight) / (1.5^2));
                otherwise
                    error('Invalid scenario');
            end

        end


        function receivedPower = calculateReceivedPower(obj)
            % Constants
            transmitPower = obj.baseStation.cell.power;
            receiverAntennaGain = obj.mobileStation.ANTENNA_GAIN;

            % Calculate received power using the Friis transmission equation
            receivedPower = transmitPower + obj.calculateTotalTransmitterGain() + receiverAntennaGain - obj.calculatePathLoss();
        end
    end
end