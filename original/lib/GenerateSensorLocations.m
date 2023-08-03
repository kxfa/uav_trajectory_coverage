function [xySensorLocations] = GenerateSensorLocations(S_sens,num_receivers)
%     [xySensorLocations] = GenerateSensorLocations(S_sens,num_receivers)
%
%     numberOfAllSensors = size(struct2table(S_sens),1);
%     probability = rand([numberOfAllSensors,1]);
%     sensorMask = probability <= pecentageOfSensors;
%         
%     % Use binary array to select points
%     xySensorLocations_idx = [1:1:size(struct2table(S_sens),1)];
%     xSensorLocations = [S_sens(xySensorLocations_idx((sensorMask))).LocationX];
%     ySensorLocations = [S_sens(xySensorLocations_idx((sensorMask))).LocationY];
%     xySensorLocations = horzcat(xSensorLocations',ySensorLocations');

    num_all_possible = size(S_sens.XLocation,1);
    xy_all_possible = zeros([num_all_possible,2]);
    for idx = 1:1:num_all_possible
        xy_all_possible(idx,:) = [S_sens.XLocation(idx),S_sens.YLocation(idx)];
    end
    
    xySensorLocations = zeros([num_receivers,2]);
    for idx = 1:1:num_receivers
        
        select_idx = round(rand(1)*size(xy_all_possible,1));
        if select_idx == 0
            select_idx = 1;
        end
        xySensorLocations(idx,:) = [xy_all_possible(select_idx,1),xy_all_possible(select_idx,2)];
        xy_all_possible(select_idx,:) = [];

    end
end