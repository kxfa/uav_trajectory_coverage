function mapPointsNormal = NormalizeData(mapPoints)
    % mapPointsN = NormalizeData(mapPoints)
    % Normalize the previous calculated map points.
    % Reformulated by Yuxuan Fang on 08/02/2023.
    % 
    % Input is the the struct computed by function CollectCity.m
    % Including: S_building_sens, xyCustomers,xyVendors, xyBuildings, S_contour_convex, S_contours.
    % 
    % Output is the normalized struct including: entireMapEdges_local, xyBuildings, xyCustomers,
    %                                            xyVendors, S_building_sens, S_contour_convex, S_contours.



    % Find edges of customer, vendor, and building sensor maps in global coords
    % Map edges
    buildingSensMapEdges = FindMapEdges(mapPoints.S_building_sens);
    
    
    % Find edges of customer, vendor, and building location/occupancy maps in global coords
    % Customer
    minXY_map_C = [min(mapPoints.xyCustomers(:,1)), min(mapPoints.xyCustomers(:,2))];
    maxXY_map_C = [max(mapPoints.xyCustomers(:,1)), max(mapPoints.xyCustomers(:,2))];
    customerLocsMapEdges = [minXY_map_C, maxXY_map_C];
    
    % Vendor
    minXY_map_V = [min(mapPoints.xyVendors(:,1)), min(mapPoints.xyVendors(:,2))];
    maxXY_map_V = [max(mapPoints.xyVendors(:,1)), max(mapPoints.xyVendors(:,2))];
    vendorLocsMapEdges = [minXY_map_V, maxXY_map_V];
    
    % Building
    minXY_map_B = [min(mapPoints.xyBuildings(:,1)), min(mapPoints.xyBuildings(:,2))];
    maxXY_map_B = [max(mapPoints.xyBuildings(:,1)), max(mapPoints.xyBuildings(:,2))];
    buildingLocsMapEdges = [minXY_map_B, maxXY_map_B];
    
    % Find edges of city contour in global coords
    minXY_map_contour = [min(mapPoints.S_contour_convex.contour(:,1)), min(mapPoints.S_contour_convex.contour(:,2))];
    maxXY_map_contour = [max(mapPoints.S_contour_convex.contour(:,1)), max(mapPoints.S_contour_convex.contour(:,2))];
    contourMapEdges = [minXY_map_contour, maxXY_map_contour];
    
    
    % Total/encompassing map edges
    edges = vertcat(buildingSensMapEdges, customerLocsMapEdges, ...
                    vendorLocsMapEdges, buildingLocsMapEdges, contourMapEdges);
    entireMapEdges_global = [min(edges(:,1:2),[],1), max(edges(:,3:4),[],1)];
    
    
    % Normalize building sensor struct
    for idx = 1:size(struct2table(mapPoints.S_building_sens),1)        
        mapPointsNormal.S_building_sens.XLocation(idx) = ...
                mapPoints.S_building_sens.XLocation(idx) - entireMapEdges_global(1);
        mapPointsNormal.S_building_sens.YLocation(idx) = ...
                mapPoints.S_building_sens.YLocation(idx) - entireMapEdges_global(2);
    end
    
    % Normalize building occupancy and vendor/customer location arrays
    mapPointsNormal.xyBuildings = mapPoints.xyBuildings - [entireMapEdges_global(1),entireMapEdges_global(2)];
    mapPointsNormal.xyCustomers = mapPoints.xyCustomers - [entireMapEdges_global(1),entireMapEdges_global(2)];
    mapPointsNormal.xyVendors   = mapPoints.xyVendors   - [entireMapEdges_global(1),entireMapEdges_global(2)];
    
    % Normalize city contour
    mapPointsNormal.S_contour_convex.contour    = mapPoints.S_contour_convex.contour - [entireMapEdges_global(1), entireMapEdges_global(2)];
    for idx = 1:size(mapPoints.S_contours, 2)
        mapPointsNormal.S_contours(idx).contour = mapPoints.S_contours(idx).contour  - [entireMapEdges_global(1), entireMapEdges_global(2)];
    end

    % Find edges of normalized Customer, Vendor, Building sensor map
    buildingSensMapEdges = FindMapEdges(mapPointsNormal.S_building_sens);

    % Occupancy/locations
    customerLocsMapEdges = [min(mapPointsNormal.xyCustomers(:,1)), min(mapPointsNormal.xyCustomers(:,2)), ...
                            max(mapPointsNormal.xyCustomers(:,1)), max(mapPointsNormal.xyCustomers(:,2))];

    vendorLocsMapEdges   = [min(mapPointsNormal.xyVendors(:,1)),   min(mapPointsNormal.xyVendors(:,2)), ...
                            max(mapPointsNormal.xyVendors(:,1)),   max(mapPointsNormal.xyVendors(:,2))];

    buildingLocsMapEdges = [min(mapPointsNormal.xyBuildings(:,1)), min(mapPointsNormal.xyBuildings(:,2)), ...
                            max(mapPointsNormal.xyBuildings(:,1)), max(mapPointsNormal.xyBuildings(:,2))];


    minXY_map_contour = max(mapPointsNormal.S_contour_convex.contour, [], 1);
    maxXY_map_contour = min(mapPointsNormal.S_contour_convex.contour, [], 1);
    contourMapEdges   = [minXY_map_contour, maxXY_map_contour];
    
    edges = vertcat(buildingSensMapEdges, customerLocsMapEdges, ...
                    vendorLocsMapEdges, buildingLocsMapEdges, contourMapEdges);
    
    mapPointsNormal.entireMapEdges_local = [min(edges(:,1:2), [], 1), max(edges(:,3:4), [], 1)];

end