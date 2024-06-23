classdef Visualization

    methods (Static)


        function visualize(Basestations,Mobilestations)
            
            numBS = numel(Basestations);
            numUser = numel(Mobilestations);

            for i = 1 : numBS            
            % Create transmitter sites
            Txs(1,i) = txsite('Name','sites', ...
                'Latitude',Basestations(i).location(1), ...
                'Longitude',Basestations(i).location(2), ...
                'AntennaHeight',Basestations(i).height);      
            end

            for i = 1 : numUser

            Rxs(i) = rxsite('Name','RX_User', ...
                'Latitude',Mobilestations(i).location(1),...
                'Longitude',Mobilestations(i).location(2), ...
                'AntennaHeight',Mobilestations(i).ANTENNA_HEIGHT,...
                'ReceiverSensitivity',Mobilestations(i).SENSITIVITY);

            end

            % Launch Site Viewer
            viewer = siteviewer;

            % Show sites on a map
            show(Txs);

            show (Rxs);

            viewer.Basemap = 'topographic';
        end




    end
end