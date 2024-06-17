%{
---------------------------------------------------------------------------
%% Class Name: ChannelLink
---------------------------------------------------------------------------
DESCRIPTION: represent a radio frequency link between a gNodeB
(transmitter) and a UE (receiver) in a Downlink scenario.

NOTES:

CONTRIBUTORS: Mohamed Shalaby, Hossam Hassainen, Hussein El-Shamy

DATE: 25 June 2023
---------------------------------------------------------------------------
%}

classdef ChannelLink

    properties (Constant)

        EarthRadius = 6371;         % Earth's radius in kilometers
        HorizontalHPBW = 120;       % Horizontal HPBW in degrees
        VerticalHPBW = 10;          % Vertical HPBW in degrees
        HorizontalSLL = -20;        % Horizontal SLL in dB
        VerticalSLL = -18;          % Vertical SLL in dB
        BaseStationAntennaHeight = 40;  % Base station antenna height in meters
        MobileStationAntennaHeight = 1.5; % Mobile station antenna height in meters
        MaxAntennaGain = 18;        % Maximum antenna gain in both directions in dB
        ReceiverAntennaGain = 5;    % Receiver antenna gain in dBi
        UEsensitivity = -110;        % The user equipment's sensitivity in dBm

    end

    properties

        BaseStationLatitude = 0;    % Base station latitude
        BaseStationLongitude = 0;   % Base station longitude
        MaxPowerLatitude = 0;       % Maximum power latitude from BS
        MaxPowerLongitude = 0;      % Maximum power longitude from BS
        ReceiverLatitude = 0;       % Receiver latitude
        ReceiverLongitude = 0;      % Receiver longitude
        AntennaTilt = 0;            % Antenna tilt angle
        Frequency = 0;              % Frequency of operation (in GHz)
        Environment = "";           % Environment (urban, suburban, rural, or open)
        TransmitPower = 0;          % Power transmitted from the BS in dBm

    end

    methods

        %{
---------------------------------------------------------------------------
%% METHOD NAME: path
---------------------------------------------------------------------------
DESCRIPTION: Creates a new 'ChannelLink' object with the specified tilt,
frequency, type of environment, and transmitter power
[Constructor].

INPUT ARGUMENTS:
- tilt: Antenna tilt angle in degrees.
- freq: The frequency of operation in GHz.
- env: The environment type (urban, suburban, rural, or open).
- tx_power: Power transmitted from the transmitter in dBm.

OUTPUT ARGUMENTS:
- obj: The newly created 'path' object.

NOTES:

AUTHOR: Hussein El-Shamy

DATE: 25 June 2023
---------------------------------------------------------------------------
        %}

        function obj = ChannelLink(antennaTilt, frequency, environment, transmitPower)
            % Constructor for ChannelLink objects.
            %   Initializes the properties with provided inputs or default values.

            if nargin == 0
                % Default values if no inputs are provided
                obj.AntennaTilt = 90;
                obj.Frequency = 3;
                obj.Environment = 'urban';
                obj.TransmitPower = 49;
            else
                % Assign provided inputs to object properties
                obj.AntennaTilt = antennaTilt;
                obj.Frequency = frequency;
                obj.Environment = environment;
                obj.TransmitPower = transmitPower;
            end
        end


        %{
---------------------------------------------------------------------------
%% METHOD NAME: haversine
---------------------------------------------------------------------------
DESCRIPTION: Calculates the distance between two points on the
Earth's surface using the Haversine formula.

INPUT ARGUMENTS: - obj

OUTPUT ARGUMENTS: - dist

NOTES:

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023
---------------------------------------------------------------------------
        %}

        function distance = calculateUserBaseDistance(obj)
            % Calculate the Euclidean distance between the user and the base station.

            % Convert latitudes and longitudes to meters (assuming 1 degree = 111,139 meters)
            userLatitude_m = obj.ReceiverLatitude * 111139;
            userLongitude_m = obj.ReceiverLongitude * 111139;
            baseStationLatitude_m = obj.BaseStationLatitude * 111139;
            baseStationLongitude_m = obj.BaseStationLongitude * 111139;

            % Calculate the distance using the Euclidean distance formula
            distance = sqrt((baseStationLatitude_m - userLatitude_m)^2 + (baseStationLongitude_m - userLongitude_m)^2);
        end
        %{
---------------------------------------------------------------------------
%% METHOD NAME: CalculateAngleBetweenLines
---------------------------------------------------------------------------
DESCRIPTION: Calculates the angle between two lines formed by three
points on the Earth's surface.

INPUT ARGUMENTS: - obj

OUTPUT ARGUMENTS: - angle_degrees

NOTES:

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023
---------------------------------------------------------------------------
        %}

        function angleDegrees = calculateAngleBetweenLines(obj)
            % Calculate the angle between two lines defined by three points.

            % Calculate the differences in latitudes and longitudes
            deltaLat1 = obj.MaxPowerLatitude - obj.BaseStationLatitude;
            deltaLon1 = obj.MaxPowerLongitude - obj.BaseStationLongitude;
            deltaLat2 = obj.ReceiverLatitude - obj.BaseStationLatitude;
            deltaLon2 = obj.ReceiverLongitude - obj.BaseStationLongitude;

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



        %{
---------------------------------------------------------------------------
%% METHOD NAME: CalculateTotalGainTx
---------------------------------------------------------------------------
DESCRIPTION: Calculate transmitter's antenna toatal gain

INPUT ARGUMENTS: - obj

OUTPUT ARGUMENTS: - GT: Total antenna gain

NOTES:

AUTHOR: Hossam Hassanein

DATE: 25 June 2023
---------------------------------------------------------------------------
        %}
        function totalGainTx = calculateTotalTransmitterGain(obj)
            % Constants
            horizontalSLL = obj.HorizontalSLL;
            verticalSLL = obj.VerticalSLL;

            % Calculate the horizontal gain of the transmitter's antenna
            angleBetweenLines = obj.calculateAngleBetweenLines();
            horizontalGain = max(-12 * (angleBetweenLines / obj.HorizontalHPBW)^2, horizontalSLL);

            % Calculate the vertical gain of the transmitter's antenna
            theta = atan((obj.BaseStationAntennaHeight - obj.MobileStationAntennaHeight) / (obj.calculateUserBaseDistance * 1000));
            verticalGain = max(-12 * ((theta - obj.AntennaTilt) / obj.VerticalHPBW)^2, verticalSLL);

            % Calculate the total gain
            totalGainTx = max(horizontalGain + verticalGain, horizontalSLL + verticalSLL) + obj.MaxAntennaGain;
        end
        %{
---------------------------------------------------------------------------
%% METHOD NAME: CalculatePathLoss
---------------------------------------------------------------------------
DESCRIPTION: Calculates the path loss according to the 3GPP 3D
channel model for 5G

INPUT ARGUMENTS:distance(m), Frequency(GHz), heightTx(m),
heightRx(m), scenario

OUTPUT ARGUMENTS: PL(Path Loss in dB)

NOTES:

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023
---------------------------------------------------------------------------
        %}

        function pathLoss = calculatePathLoss(obj)

            % Constants
            baseStationHeight = obj.BaseStationAntennaHeight;
            mobileStationHeight = obj.MobileStationAntennaHeight;
            frequency = obj.Frequency;
            distance = obj.calculateUserBaseDistance() * 1000;

            % Convert environment name to lowercase for case-insensitive comparison
            scenario = lower(obj.Environment);

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
       
        %{
---------------------------------------------------------------------------
%% METHOD NAME: GetReceivedPower
---------------------------------------------------------------------------
DESCRIPTION: calculate the power at the receiver in dB

INPUT ARGUMENTS:

OUTPUT ARGUMENTS: rx_power

NOTES:

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023
---------------------------------------------------------------------------
        %}

        function receivedPower = calculateReceivedPower(obj)
            % Constants
            transmitPower = obj.TransmitPower;
            receiverAntennaGain = obj.ReceiverAntennaGain;

            % Calculate received power using the Friis transmission equation
            receivedPower = transmitPower + obj.calculateTotalTransmitterGain() + receiverAntennaGain - obj.calculatePathLoss();
        end

    end

end

%{
---------------------------------------------------------------------------
%% END OF THE CLASS IMPLEMENTATION
---------------------------------------------------------------------------
%}