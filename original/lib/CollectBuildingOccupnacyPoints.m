function xyBuildings = CollectBuildingOccupnacyPoints(occupancy_files, altitude)
% xyBuildings = CollectBuildingOccupnacyPoints(occupancy_files, altitude)
    
    altitude_fieldname = "altitude_" + num2str(altitude);
    xyBuildings_old = [];

    for occupancy_file_idx = 1:length(occupancy_files.(altitude_fieldname))
        filename = occupancy_files.(altitude_fieldname)(occupancy_file_idx);
        S_building_occ = load(filename).S_out;
        xy_data = cell2mat(struct2cell(S_building_occ));
        xyBuildings_old = [xyBuildings_old; [xy_data(1:size(xy_data,1)/2),xy_data(1+size(xy_data,1)/2:end)]];
    end

    xyBuildings = unique(xyBuildings_old,'rows');

end