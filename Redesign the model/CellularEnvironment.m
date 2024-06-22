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


classdef CellularEnvironment < ChannelLink

    properties (Constant)
        % Center Site Specification
        CenterSite = txsite('Name', 'Tanta University', 'Latitude', 30.0787, 'Longitude', 31.0178);

        % Sector Angles
        CellSectorAngles = [30, 150, 270];
        
        % Number of cell sites without the center cell
        NumCellSites = 6;
    end

    properties
        NumUsers           % Number of User Equipments served by a faulted Cell
        SiteLatitudes      % Latitude values of the compensated sites
        SiteLongitudes     % Longitude values of the compensated sites
        InterSiteDistance  % The inter-site distance in meters
        ReceiverLatitudes  % Latitude values of the UEs (Rx)
        ReceiverLongitudes % Longitude values of the UEs (Rx)
        TransmitterLocations % Transmitter Location
        TransmitterPowers  % Transmitter Powers
        TransmitterTilts    % Transmitter Angle Tilt
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
function obj = CellularEnvironment(antennaTilt, frequency, environment, transmitPower, numUsers, interSiteDistance)
    % Constructor for CellularEnvironment objects.

    if nargin == 0
        % Default values if no inputs are provided
        antennaTilt = 90;
        frequency = 2.6;
        environment = 'urban';
        transmitPower = 43;
        numUsers = 500;
        interSiteDistance = 300;
    end
    obj@ChannelLink(antennaTilt, frequency, environment, transmitPower); % Call superclass constructor

    % Initialize other properties...
    obj.InterSiteDistance = interSiteDistance;
    obj.NumUsers = numUsers;
    obj.SiteLatitudes = zeros(1, obj.NumCellSites);
    obj.SiteLongitudes = zeros(1, obj.NumCellSites);
    obj.ReceiverLatitudes = zeros(obj.NumUsers, 1);
    obj.ReceiverLongitudes = zeros(obj.NumUsers, 1);
    [obj.ReceiverLatitudes, obj.ReceiverLongitudes] = obj.GenerateReceiverLocations();
    obj.TransmitterLocations = obj.GenerateTransmitterLocations();
    obj.TransmitterPowers = ones(obj.NumCellSites, 1) * obj.TransmitPower; % Use TransmitPower from superclass
    obj.TransmitterTilts = ones(obj.NumCellSites, 1) * obj.AntennaTilt; % Use AntennaTilt from superclass
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

function [receiverLatitudes, receiverLongitudes] = GenerateReceiverLocations(obj)
    % Generates random locations for users within the coverage area of the center BS.
    
    % Generate random values for r and theta inside this circle
    r = sqrt(rand(obj.NumUsers, 1)) * (obj.InterSiteDistance / 2); % Square root to ensure uniform distribution
    theta = 2 * pi * rand(obj.NumUsers, 1);

    % Convert polar coordinates to Cartesian coordinates
    x = r .* cos(theta);
    y = r .* sin(theta);

    % Convert Cartesian coordinates to latitude and longitude offsets
    scale = 1 / 111320; % 1 degree lat/long = 111.32km
    receiverLatitudes = obj.CenterSite.Latitude + y * scale;
    receiverLongitudes = obj.CenterSite.Longitude + x * scale;
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

function transmitterLocations = GenerateTransmitterLocations(obj)

    % Generates transmitter locations around the BS based on the inter-site distance.
    transmitterLocations = zeros(obj.NumCellSites, 2);
    siteAngles(1:6) = 30:60:360;

    for i = 1:obj.NumCellSites
        [transmitterLocations(i, 1), transmitterLocations(i, 2)] = ...
            location(obj.CenterSite, obj.InterSiteDistance, siteAngles(i));
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
function [AGap, AOverlap] = assessPerformance(obj)
    % Evaluates the performance of the system based on AGap and AOverlap.

    AGap = 0;
    AOverlap = 0;
    
    % Compute main beam locations for each sector
    mainBeamLocations = zeros(obj.NumCellSites / 2, 2);
    for i = 1:3
        idx = 2 * i;
        txSite = txsite('Name', 'txsite', 'Latitude', obj.TransmitterLocations(idx, 1), ...
            'Longitude', obj.TransmitterLocations(idx, 2));
        [mainBeamLocations(i, 1), mainBeamLocations(i, 2)] = location(txSite, 1000, obj.CellSectorAngles(i));
    end
    
    % Evaluate each user
    for j = 1:obj.NumUsers
        count_g = 0;
        count_o = 0;
        for i = 1:3
            idx = 2 * i;
            obj.TransmitPower = obj.TransmitterPowers(idx, 1);
            obj.AntennaTilt = obj.TransmitterTilts(idx, 1);
            obj.BaseStationLatitude = obj.TransmitterLocations(idx, 1);
            obj.BaseStationLongitude = obj.TransmitterLocations(idx, 2);
            obj.ReceiverLatitude = mainBeamLocations(i, 1);
            obj.ReceiverLongitude = mainBeamLocations(i, 2);
            obj.ReceiverLatitude = obj.ReceiverLatitudes(j);
            obj.ReceiverLongitude = obj.ReceiverLongitudes(j);
            power = obj.calculateReceivedPower();
            if power < obj.UEsensitivity
                count_g = count_g + 1;
            else
                count_o = count_o + 1;
            end
        end
        if count_g == 3
            AGap = AGap + 1;
        end
        if count_o == 3
            AOverlap = AOverlap + 1;
        end
    end
    
    
    % Normalize results
    AGap = AGap / obj.NumUsers;
    AOverlap = AOverlap / obj.NumUsers;
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

function displaySitesAndUsers(obj)
    % Displays transmitter sites and users in the site viewer window in MATLAB.

    % Convert transmitter power from dBm to W
    txPower = 10.^((obj.TransmitterPowers - 30) / 10);

    % Create transmitter sites
    transmitterSites = txsite('Name', 'Transmitter Sites', ...
        'Latitude', obj.TransmitterLocations(:, 1), ...
        'Longitude', obj.TransmitterLocations(:, 2), ...
        'AntennaHeight', obj.BaseStationAntennaHeight, ...
        'TransmitterFrequency', obj.Frequency, ...
        'TransmitterPower', transpose(txPower));

    % Create receiver sites
    receiverSites = rxsite('Name', 'Receiver Users', ...
        'Latitude', obj.ReceiverLatitudes, ...
        'Longitude', obj.ReceiverLongitudes, ...
        'AntennaHeight', obj.MobileStationAntennaHeight, ...
        'ReceiverSensitivity', obj.UEsensitivity);

    % Launch Site Viewer
    viewer = siteviewer;

    % Show sites on a map
    show(transmitterSites);
    show(receiverSites);

    % Set basemap
    viewer.Basemap = 'satellite';
end
    end
end

%{
---------------------------------------------------------------------------
%% END OF THE CLASS IMPLEMENTATION
---------------------------------------------------------------------------
%}