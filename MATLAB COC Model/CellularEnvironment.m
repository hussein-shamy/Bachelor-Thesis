%{
---------------------------------------------------------------------------
%% Class Name: CellularEnvironment
---------------------------------------------------------------------------
DESCRIPTION: Represents the environment inwhich cellular communication
takes place. It provides a simulation of the physical characteristics and
conditions within the cellular network, allowing for analysis and
evaluation of various scenarios.

NOTES:

CONTRIBUTORS: Mohamed Shalaby, Hossam Hassainen, Hussein El-Shamy

DATE: 25 June 2023
---------------------------------------------------------------------------
%}

classdef CellularEnvironment<ChannelLink

    properties(Constant)

        % Center Site Specification
        centerSite = txsite('Name','Tanta University','Latitude',30.791,...
            'Longitude',30.997);

        % Sector Angles
        cellSectorAngles = [30 150 270];

        % Number of cell sites without the center cell
        numCellSites = 6;
    end

    properties

        NumU;                   % Number of User Equipments served by a faulted Cell
        siteLats;               % Latitude values of the compensated sites
        siteLons;               % Longitude values of the compensated sites
        isd;                    % The inter-site distance in meters
        rx_lat;                 % Latitude values of the UEs (Rx)
        rx_long;                % Longitude values of the UEs (Rx)
        tx_loc;                 % Transmitter Location
        txs_power;              % Transmitter Powers
        txs_tilt                % Transmitter Angle Tilt

    end

    methods

        %{
---------------------------------------------------------------------------
%% Method Name: CellularEnvironment
---------------------------------------------------------------------------
DESCRIPTION: Creates a new 'CellularEnvironment' object with the specified
tilt, frequency, type of environment, and transmitter power, Number of
Users, Inter-Site Distance [Constructor]. 

INPUT ARGUMENTS:
- tilt: Angle tilit of compansated site
- freq: Operating frequency of system
- tx_power: Transmitted Power
- NumU: Number of users
- isd: inter-side distance

OUTPUT ARGUMENTS:
- obj: modify object parameter 

NOTES: 

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023 
---------------------------------------------------------------------------
        %}
        function obj = CellularEnvironment(tilt,freq,env,tx_power,NumU,isd)
            obj@ChannelLink(tilt,freq,env,tx_power);
            obj.NumU = NumU;
            obj.siteLats = zeros(1,obj.numCellSites);
            obj.siteLons = zeros(1,obj.numCellSites);
            obj.isd = isd;
            obj.rx_lat = zeros(NumU,1);
            obj.rx_long = zeros(NumU,1);
            [obj.rx_lat, obj.rx_long] = obj.GenerateRxsLocation;
            obj.tx_loc = zeros(obj.numCellSites,2);
            obj.tx_loc = obj.GenerateTxsLocation;
            obj.txs_power = ones(obj.numCellSites,1)*obj.tx_power;
            obj.txs_tilt = ones(obj.numCellSites,1)*obj.tilt;
        end
        %{
---------------------------------------------------------------------------
%% Method Name: GenerateRxsLocation
---------------------------------------------------------------------------
DESCRIPTION: Generation of random location of users in the coverage area of
the center BS

INPUT ARGUMENTS:
- obj

OUTPUT ARGUMENTS: 
- Rx_lat
- Rx_long

NOTES: 

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023 
---------------------------------------------------------------------------
        %}
        function [Rx_lat,Rx_long] = GenerateRxsLocation(obj)
            %(generate random values for r and theta inside this circle)
            r = 0 + (obj.isd/2) .* rand(obj.NumU,1);
            theta = 0 + (360) .* rand(obj.NumU,1);
            % add the randomized values
            delta_lat  = r .* sin(theta);
            delta_long = r .* cos(theta);
            %scale as 1degree lat/long = 111.32km
            scale = 1/111320;
            Rx_lat  = obj.centerSite.Latitude  + delta_lat  * scale;
            Rx_long = obj.centerSite.Longitude + delta_long * scale;
        end
        %{
---------------------------------------------------------------------------
%% Method Name: GenerateTxsLocation
---------------------------------------------------------------------------
DESCRIPTION: Generate Txs Location aroud the BS based on the ISD

INPUT ARGUMENTS:
- obj: object

OUTPUT ARGUMENTS: 
- Tx_loc: the locations of Txs

NOTES: 

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023 
---------------------------------------------------------------------------
        %}
        function Tx_loc = GenerateTxsLocation(obj)
            Tx_loc = zeros(obj.numCellSites,2);
            siteAngles(1:6) = 30:60:360;
            for i = 1:obj.numCellSites
                [Tx_loc(i,1),Tx_loc(i,2)] = location(obj.centerSite, obj.isd, siteAngles(i));
            end
        end
        %{
---------------------------------------------------------------------------
%% Method Name: evaluation
---------------------------------------------------------------------------
DESCRIPTION: Evaluate the performance of the system based on AGap, Aoverla

INPUT ARGUMENTS:
- obj: object

OUTPUT ARGUMENTS:
- AGap: Number of unconnected user
- AOverlap: Number of connected user

NOTES: 

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023 
---------------------------------------------------------------------------
        %}
        function [AGap,AOverlap] = evaluation(obj)
            AGap = 0;
            AOverlap = 0;
            main_beam_loc = zeros(obj.numCellSites/2,2);
            txSite = txsite('Name','txsite','Latitude',obj.tx_loc(2,1),'Longitude',obj.tx_loc(2,2));
            [main_beam_loc(1,1),main_beam_loc(1,2)] = location(txSite, 1000, 270);
            txSite = txsite('Name','txsite','Latitude',obj.tx_loc(4,1),'Longitude',obj.tx_loc(4,2));
            [main_beam_loc(2,1),main_beam_loc(2,2)] = location(txSite, 1000, 30);
            txSite = txsite('Name','txsite','Latitude',obj.tx_loc(6,1),'Longitude',obj.tx_loc(6,2));
            [main_beam_loc(3,1),main_beam_loc(3,2)] = location(txSite, 1000, 150);
            for j = 1:obj.NumU
                count_g = 0;
                count_o = 0;
                for i = [2,4,6]
                    obj.tx_power = obj.txs_power(i,1);
                    obj.tilt = obj.txs_tilt(i,1);
                    obj.latb = obj.tx_loc(i,1);
                    obj.lonb = obj.tx_loc(i,2);
                    obj.lat1 = main_beam_loc(i/2,1);
                    obj.lon1 = main_beam_loc(i/2,2);
                    obj.lat2 = obj.rx_lat(j);
                    obj.lon2 = obj.rx_long(j);
                    power = obj.GetReceivedPower;
                    if (power<obj.UE_sensitivity)
                        count_g = count_g + 1;
                    else
                        count_o = count_o + 1;
                    end
                end
                if (count_g == 3)
                    AGap = AGap + 1;
                end
                if (count_o== 3)
                    AOverlap = AOverlap + 1;
                end
            end
            AGap = AGap/obj.NumU;
            AOverlap = AOverlap/obj.NumU;
        end
        %{
---------------------------------------------------------------------------
%% Method Name: show
---------------------------------------------------------------------------
DESCRIPTION: Display sites and users in the site viewer window in MATLAB.

INPUT ARGUMENTS:
- obj: object

OUTPUT ARGUMENTS:

NOTES: 

AUTHOR: Mohamed Shalaby

DATE: 25 June 2023 
---------------------------------------------------------------------------
        %}
        function [] = show(obj)
            txPower = 10.^((obj.tx_power-30)/10); % Convert dBm to W
            % Create transmitter sites
            Txs = txsite('Name','sites', ...
                'Latitude',obj.tx_loc(:,1), ...
                'Longitude',obj.tx_loc(:,2), ...
                'AntennaHeight',obj.ht, ...
                'TransmitterFrequency',obj.freq, ...
                'TransmitterPower',txPower);
            Rxs = rxsite('Name','RX_User','Latitude',obj.rx_lat,...
                'Longitude',obj.rx_long,'AntennaHeight',obj.hr,...
                'ReceiverSensitivity',obj.UE_sensitivity);
            % Launch Site Viewer
            viewer = siteviewer;
            % Show sites on a map
            show(Txs);
            show (Rxs);
            viewer.Basemap = 'topographic';
        end
    end
end
%{
---------------------------------------------------------------------------
%% END OF THE CLASS IMPLEMENTATION
---------------------------------------------------------------------------
%}