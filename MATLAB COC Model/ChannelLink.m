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

        R = 6371;               % Earth's radius in kilometers
        HPBW_H = 120;           % Horizontal HPBW in degrees
        HPBW_V = 10;            % Vertical HPBW in degrees
        SLL_H = -20;            % Horizontal SLL in dB
        SLL_V = -18;            % Vertical SLL in dB
        ht = 40;                % BS antenna height in meters
        hr = 2;                 % MS antenna height in meters
        G0 = 18;                % Max antenna gain in both directions in dB
        Gr = 5;                 % Receiver antenna gain in dBi
        UE_sensitivity = -70;   % The user equipment's sensitivity in dBm

    end

    properties

        latb = 0;               % Base station latitude
        lonb = 0;               % Base station longitude
        lat1 = 0;               % Maximum power latitude from BS
        lon1 = 0;               % Maximum power longitude from BS
        lat2 = 0;               % Receiver latitude
        lon2 = 0;               % Receiver longitude
        tilt = 0;               % Antenna tilt angle
        freq = 0;               % Frequency of operation (in GHz)
        env = "";               % Environment (urban, suburban, rural, or open)
        tx_power = 0;           % Power transmitted from the BS in dBm

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

        function obj = ChannelLink(tilt,freq,env,tx_power)
            if nargin == 0
                % If no inputs are provided during execution, use these
                ... values as initial values
                    obj.tilt=90;
                obj.freq=3;
                obj.env='urban';
                obj.tx_power=49;
            else
                % Otherwise, obtain them from the user.
                obj.tilt = tilt;
                obj.freq=freq;
                obj.env=env;
                obj.tx_power=tx_power;
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

        function dist = haversine(obj)

            % Convert latitudes and longitudes to radians
            lat2_rad = deg2rad(obj.lat2);
            lon2_rad = deg2rad(obj.lon2);
            latb_rad = deg2rad(obj.latb);
            lonb_rad = deg2rad(obj.lonb);

            % Calculate differences in latitudes and longitudes
            dlat = latb_rad - lat2_rad;
            dlon = lonb_rad - lon2_rad;

            % Haversine formula
            a = sin(dlat/2)^2 + cos(lat2_rad)*cos(latb_rad)*sin(dlon/2)^2;
            c = 2*atan2(sqrt(a), sqrt(1-a));
            dist = obj.R*c;

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

        function angle_degrees = CalculateAngleBetweenLines(obj)
            % Convert degrees to radians
            latb_rad = deg2rad(obj.latb);
            lonb_rad = deg2rad(obj.lonb);
            lat1_rad = deg2rad(obj.lat1);
            lon1_rad = deg2rad(obj.lon1);
            lat2_rad = deg2rad(obj.lat2);
            lon2_rad = deg2rad(obj.lon2);

            % Calculate bearings from point b to point 1 and from point b
            % to point 2
            y = sin(lon1_rad-lonb_rad) * cos(lat1_rad);
            x = cos(latb_rad)*sin(lat1_rad) - sin(latb_rad)*cos(lat1_rad)*cos(lon1_rad-lonb_rad);
            theta1 = atan2(y, x);
            if theta1 < 0
                theta1 = theta1 + 2*pi;
            end

            y = sin(lon2_rad-lonb_rad) * cos(lat2_rad);
            x = cos(latb_rad)*sin(lat2_rad) - sin(latb_rad)*cos(lat2_rad)*cos(lon2_rad-lonb_rad);
            theta2 = atan2(y, x);
            if theta2 < 0
                theta2 = theta2 + 2*pi;
            end

            % Calculate the angle between the two lines
            delta_theta = abs(theta1 - theta2);
            if delta_theta > pi
                delta_theta = 2*pi - delta_theta;
            end

            % Convert angle to degrees
            angle_degrees = rad2deg(delta_theta);
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

        function GT = CalculateTotalGainTx(obj)
            %Calculate the Horizontal Gain of Transmitter's Antenna
            pi = obj.CalculateAngleBetweenLines;
            GH = max(-12*(pi/obj.HPBW_H)^2,obj.SLL_H);

            %Calculate the Vertical Gain of Transmitter's Antenna
            theta = atan((obj.ht-obj.hr)/(obj.haversine*1000));
            GV = max(-12*((theta - obj.tilt)/obj.HPBW_V)^2,obj.SLL_V);

            %Calculate the total Gain
            GT = max(GH+GV,obj.SLL_H + obj.SLL_V) + obj.G0;
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

        function [PL] = CalculatePathLoss(obj)
            % PROPAGATIONMODEL Calculates the path loss according to the
            % 3GPP 3D channel model for 5G [PL] =
            % propagationModel(distance, frequency, heightTX, heightRX,
            % scenario) given the distance between the transmitter and
            % receiver (in meters), the frequency of operation (in GHz),
            % the heights of the transmitter and receiver (in meters), and
            % the scenario of operation (urban, suburban, rural, or open).
            % The function returns the path loss in dB.

            % Calculate path loss based on scenario
            switch lower(obj.env)
                case 'urban'
                    % Urban Macro Cell (UMa)
                    PL = 28 + 22*log10(obj.haversine*1000) + 20*log10(obj.freq) + ...
                        10*log10((obj.ht*obj.hr)/((1.5)^2)) - (3.2*(log10(11.75*obj.hr))^2) - 0.5;
                case 'suburban'
                    % Suburban Macro Cell (UMi)
                    PL = 28 + 40*log10(obj.haversine*1000) + 20*log10(obj.freq) + ...
                        10*log10((obj.ht*obj.hr)/((1.5)^2)) - (9*(log10((obj.hr)^2/3.5))^2) - 0.5;
                case 'rural'
                    % Rural Macro Cell (RMa)
                    PL = 28 + 20*log10(obj.haversine*1000) + 20*log10(obj.freq) + ...
                        10*log10((obj.ht*obj.hr)/((1.5)^2)) - (2*(log10((obj.hr/3)^2))^2) - 0.5;
                case 'open'
                    % Open Area (Oa)
                    PL = 32.4 + 20*log10(obj.haversine*1000) + 20*log10(obj.freq) - ...
                        10*log10((obj.ht*obj.hr)/((1.5)^2));
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

        function rx_power = GetReceivedPower(obj)
            rx_power = obj.tx_power + obj.CalculateTotalGainTx + obj.Gr...
                - obj.CalculatePathLoss;
        end
                %{
---------------------------------------------------------------------------
%% METHOD NAME: 
---------------------------------------------------------------------------
DESCRIPTION: calculate the power at the receiver in dB

INPUT ARGUMENTS:

OUTPUT ARGUMENTS: rx_power

NOTES:

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023
---------------------------------------------------------------------------
                %}
        function Output_Validation(obj)

        m1 = "1) Recived Power= " + obj.CalculatePathLoss ;
        msgbox(m1,"Output Validation");
            

        end


    end
end
%{
---------------------------------------------------------------------------
%% END OF THE CLASS IMPLEMENTATION
---------------------------------------------------------------------------
%}