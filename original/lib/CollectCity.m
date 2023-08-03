function mapPoints = CollectCity(urbanData, altitude, lat2meters, long2meters)
    % mapPoints = CollectCity(urbanData, altitude, latInMeters, longInMeters)
    % Reformulated by Yuxuan Fang on 08/02/2023.
    %
    % Struct outputs include: S_building_sens, xyCustomers, xyVendors, xyBuildings,
    %                         S_contour_convex, S_contours.
    %
    % Struct inputs include: 
    % In struct:    receiver_files, customer_file, vendor_file, occupancy_files,
    %               minX_map_lat, minY_map_long, city_contours_file, convex_contour_file.
    % Other inputs: altitude, lat2meters, long2meters.

    mapPoints.S_building_sens                          = CollectSensorLocations(urbanData.receiver_files);
    mapPoints.xyCustomers                              = CollectCustomerVendorLocations(urbanData.customer_file);
    mapPoints.xyVendors                                = CollectCustomerVendorLocations(urbanData.vendor_file);
    mapPoints.xyBuildings                              = CollectBuildingOccupnacyPoints(urbanData.occupancy_files, altitude);

    excerptData.minX_map_lat                           = urbanData.minX_map_lat;
    excerptData.minY_map_long                          = urbanData.minY_map_long;
    excerptData.city_contours_file                     = urbanData.city_contours_file;
    excerptData.convex_contour_file                    = urbanData.convex_contour_file;

    [mapPoints.S_contour_convex, mapPoints.S_contours] = CollectContours(excerptData, lat2meters, long2meters);

end