clc;
clear;


for i = 1:6
  CompensatingSites(1:i) = BaseStation(i,[0,0], 50);
end

  OutagedSite = BaseStation(8,[0,0], 50);

% Create Cells
SectorA = Cell(1, 49, false);
SectorB = Cell(2, 49, false);
SectorC = Cell(3, 49, false);

CompensatingSites(1,4).addCell(SectorA);






