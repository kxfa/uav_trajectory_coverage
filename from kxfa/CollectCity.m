function [S_building_sens,xyCustomers,xyVendors,xyBuildings,S_contour_convex, S_contours] = CollectCity(receiver_files,customer_file,vendor_file,occupancy_files,altitude,lat2meters,long2meters,minX_map_lat,minY_map_long,city_contours_file,convex_contour_file)

    S_building_sens = CollectSensorLocations(receiver_files);
    xyCustomers = CollectCustomerVendorLocations(customer_file);
    xyVendors = CollectCustomerVendorLocations(vendor_file);
    xyBuildings = CollectBuildingOccupnacyPoints(occupancy_files,altitude);
    [S_contour_convex, S_contours] = CollectContours(lat2meters,long2meters,minX_map_lat,minY_map_long,city_contours_file,convex_contour_file);

end
