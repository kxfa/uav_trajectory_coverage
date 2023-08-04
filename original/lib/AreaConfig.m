function urbanData = AreaConfig(city)
% urbanData = AreaConfig(city)
% Reformulated by Yuxuan Fang on 08/02/2023.
% 
% The output urbanData is a string struct, which includes: 1. minX_map_lat,
% 2. minY_map_long, 3. receiver_files, 4. customer_file, 5. vendor_file,
% 6. occupancy_files (a struct with two altitudes), 7. convex_contour_file,
% 8. city_contours_file.

switch(city)
    % if city == "San Francisco"

    case "San Francisco"
        %--- map calibration parameters ---%
        % only being used for calibrating contours at the moment; could be
        % moved to the contour file preparation script instead
        urbanData.minX_map_lat                 = -130;
        urbanData.minY_map_long                = 0;

        %------------------- SAN FRANCISCO DATASETS -------------------%
        % sensor locations
        urbanData.receiver_files               = "../datasets/FormattedDatasets/SF_formatted/2_3_23_SF_buidings_1_sensors_N160927.mat";
        % customer/stop locations
        urbanData.customer_file                = "../datasets/FormattedDatasets/SF_formatted/2_3_23_SF_customers_N125446.mat";
        % vendor/start locations
        urbanData.vendor_file                  = "../datasets/FormattedDatasets/SF_formatted/2_3_23_SF_vendors_N159.mat";
        % building occupancy map data
        urbanData.occupancy_files.altitude_200 = ...
            "../datasets/FormattedDatasets/SF_formatted/2_3_23_SF_buidings_1_occupancy_H200ft_N154.mat";
        urbanData.occupancy_files.altitude_400 = ...
            "../datasets/FormattedDatasets/SF_formatted/2_3_23_SF_buidings_1_occupancy_H400ft_N48.mat";
        % convex city contour
        urbanData.convex_contour_file          = "../datasets/FormattedDatasets/SF_formatted/SF_border_convex.mat";
        % city contour(s)
        urbanData.city_contours_file           = "../datasets/FormattedDatasets/SF_formatted/SF_border.mat";


    case "Los Angeles"

        %--- map calibration parameters ---%
        % only being used for calibrating contours at the moment; could be
        % moved to the contour file preparation script instead
        urbanData.minX_map_lat                 = -130;
        urbanData.minY_map_long                = 0;

        % ------------------- LOS ANGELES DATASETS ------------------- %
        % sensor locations
        urbanData.receiver_files               = ["../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_1_sensors_N538415.mat";
                                                  "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_2_sensors_N542339.mat";
                                                  "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_3_sensors_N695004.mat";
                                                  "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_4_sensors_N227406.mat"];
        % customer/stop locations
        urbanData.customer_file                = "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_customers_N360183.mat";
        % vendor/start locations
        urbanData.vendor_file                  = "../datasets/FormattedDatasets/LA_formatted/2_3_23_LA_vendors_N453.mat";
        % building occupancy map data
        urbanData.occupancy_files.altitude_200 = ...
            ["../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_1_occupancy_H200ft_N20.mat";
            "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_2_occupancy_H200ft_N224.mat";
            "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_3_occupancy_H200ft_N144.mat";
            "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_4_occupancy_H200ft_N21.mat"];
        urbanData.occupancy_files.altitude_400 = ...
            ["../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_1_occupancy_H400ft_N0.mat";
            "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_2_occupancy_H400ft_N57.mat";
            "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_3_occupancy_H400ft_N53.mat";
            "../datasets/FormattedDatasets/LA_formatted/2_2_23_LA_buidings_4_occupancy_H400ft_N0.mat"];
        % convex city contour
        urbanData.convex_contour_file          = "../datasets/FormattedDatasets/LA_formatted/LA_border_convex.mat";
        % city contour(s)
        urbanData.city_contours_file           = "../datasets/FormattedDatasets/LA_formatted/LA_border.mat";


    case "New York City"

        % only being used for calibrating contours at the moment; could be
        % moved to the contour file preparation script instead
        %--- map calibration parameters ---%
        urbanData.minX_map_lat                 = -100;
        urbanData.minY_map_long                = 15;

        % ------------------- NEY YORK CITY DATASETS ------------------- %
        % sensor locations
        urbanData.receiver_files               = ["../datasets/FormattedDatasets/NYC_formatted/2_3_23_NYC_buidings_1_sensors_N685639.mat";
                                                  "FormattedDatasets/NYC_formatted/2_3_23_NYC_buidings_2_sensors_N688024.mat"];
        % customer/stop locations
        urbanData.customer_file                = "../datasets/FormattedDatasets/NYC_formatted/2_3_23_NYC_customers_N958747.mat";
        % vendor/start locations
        urbanData.vendor_file                  = "../datasets/FormattedDatasets/NYC_formatted/2_3_23_NYC_vendors_N838.mat";
        % building occupancy map data
        urbanData.occupancy_files.altitude_200 = ...
            "../datasets/FormattedDatasets/NYC_formatted/2_3_23_NYC_buidings_1_occupancy_H200ft_N1388.mat";
        urbanData.occupancy_files.altitude_400 = ...
            "../datasets/FormattedDatasets/NYC_formatted/2_3_23_NYC_buidings_2_occupancy_H200ft_N55.mat";
        % convex city contour
        urbanData.convex_contour_file          = "../datasets/FormattedDatasets/NYC_formatted/NYC_border_convex.mat";
        % city contour(s)
        urbanData.city_contours_file           = "../datasets/FormattedDatasets/NYC_formatted/NYC_border.mat";

    otherwise

        error('Invalid string input.');

end

disp(city + " Datasets Loading ...")

end