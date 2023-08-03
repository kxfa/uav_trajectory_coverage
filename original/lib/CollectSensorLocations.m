function S_building_sens = CollectSensorLocations(sensor_files)
        % S_building_sens = CollectSensorLocations(sensor_files)
        % Input: 
        % sensor_files (list): list of .mat files that each stores 1 struct
        %                      "S_out" with fields XLocaiton and YLocation;
        %                      stores the (x,y) locations of receivers
        % Output:
        % S_buildings_sens (struct): struct that saves all (x,y) locations of
        %                            thed receivers with zero duplicate
        %                            locations        

    xy_data_all = [];
    for sensor_file_idx = 1:length(sensor_files)
        sensor_region = load(sensor_files(sensor_file_idx)).S_out;
        xy_data = [sensor_region.XLocation, sensor_region.YLocation];
        xy_data_all = [xy_data_all; [xy_data(:,1),xy_data(:,2)] ];
    end

    % Remove duplicate coordiantes
    xy_data_unique = unique(xy_data_all,'rows');

    S_building_sens.XLocation = xy_data_unique(:,1);
    S_building_sens.YLocation = xy_data_unique(:,2);

end