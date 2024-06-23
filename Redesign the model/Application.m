clc;
clear;

% Create compensating base stations with IDs from 1 to 6
for i = 1:6
    CompensatingSites(1:i) = BaseStation(i);
end

% Create the outaged base station with ID = 8 and set its location
OutagedSite = BaseStation(8);
OutagedSite.location = [30.791, 30.997]; % Example location (New York City)

% Create 3 conventional sectors
SectorA = Cell(1); SectorA.azimuth = 30;
SectorB = Cell(2); SectorB.azimuth = 180;
SectorC = Cell(3); SectorC.azimuth = 360;

% Add these sectors to all compensating base stations
for i = 1:numel(CompensatingSites)
    CompensatingSites(i) = CompensatingSites(i).addCell([SectorA, SectorB, SectorC]);
end

% Add these sectors to the outaged base station
OutagedSite = OutagedSite.addCell([SectorA, SectorB, SectorC]);

% Create an array of mobile stations
numStations = 100;
mobileStations = MobileStation.empty(0, numStations);
for i = 1:numStations
    mobileStations(i) = MobileStation(i);  % IDs will be 0, 1, 2, ..., 99
end

% Assign random locations to mobile stations around the outaged base station
mobileStations = RadioPlanning.allocateMobileStationsFromCenter(mobileStations, OutagedSite,0.5);

% Allocate neighboring sites around the center location of the outaged base station
CompensatingSites = RadioPlanning.allocateNeighbouringSitesFromCenter(OutagedSite, CompensatingSites, 0.5);

% Caculate the maximum radiation direction for each cell
for i = 1:6
CompensatingSites(i) = RadioPlanning.calculateMaxRadiationDirection(CompensatingSites(i), 1.5);
end

% Calculate the recevied power for each mobile station form each compensating cell
RX_Power = zeros(numStations,18);
for i = 1:3:18
j = 1;
RX_Power(:,i:i+2) = MobileWirelessChannel.calculateReceivedPower(CompensatingSites(j), mobileStations, 'urban');
j=j+1;
end

% assign the received power list from compensating cell to each user
for i = 1:numStations
    mobileStations(i).CellsInfo = RX_Power(i,:);
    mobileStations(i) = mobileStations(i).cellSelection();
    mobileStations(i) = mobileStations(i).getReadyConnectedBS();
end

Visualization.visualize(CompensatingSites,mobileStations);

