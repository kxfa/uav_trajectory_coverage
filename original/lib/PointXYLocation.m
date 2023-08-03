function [S_out,num] = PointXYLocation(shapeFilePath, S_contour, config)
% [S_out,num] = PointXYLocation(shapeFilePath, S_contour, config)
% config is the output of the function OSM_Initialization.m
% Yuxuan Fang 08/03/2023
    
    disp("Loading OSM Shape File ...")
    S_raw = shaperead(shapeFilePath);
    disp("Loading OSM Shape File Complete")
    numTableRows_raw = size(struct2table(S_raw),1);

    % convert coordiantes to meters and normalize map dat to to minXY 
    % reference point map_min_meters
    disp("Normalizing Map Data Coordinates ...")
    temp_idx = 1;
    for raw_idx = 1:numTableRows_raw        
        S_temp(temp_idx).X = ...
            round(rmmissing(S_raw(raw_idx).X) * ...
            config.lat2meters - config.minX_map_m);
        S_temp(temp_idx).Y = ...
            round(rmmissing(S_raw(raw_idx).Y) * ...
            config.long2meters - config.minY_map_m);
        temp_idx = temp_idx + 1;
    end
    % convert contour coordinates to meters and normalize map to minXY
    for contour_idx = 1:size(struct2table(S_contour),1)
        S_contour(contour_idx).contour(:,1) = ...
            round(S_contour(contour_idx).contour(:,1)*config.lat2meters - config.minX_map_m);
        S_contour(contour_idx).contour(:,2) = ...
            round(S_contour(contour_idx).contour(:,2)*config.long2meters - config.minY_map_m);
    end
    disp("Normalizing Map Complete!")
    
    xy_point_locations = zeros(size(struct2table(S_temp),1),2);
    for idx = 1:size(struct2table(S_temp),1)
        xy_point_locations(idx,1) = S_temp(idx).X;
        xy_point_locations(idx,2) = S_temp(idx).Y;   
    end

    
    xLocations = xy_point_locations(:,1);
    yLocations = xy_point_locations(:,2);
    disp("Number of Points In and Out of Contour(s): " ...
        + num2str(length(xLocations)))
    % confirm locations are within city boundaries
    in_city_mask = zeros([size(xLocations),1]);
    for contour_idx = 1:size(struct2table(S_contour),1)

        in_contour_mask = inpolygon(xLocations,yLocations, ...
                            S_contour(contour_idx).contour(:,1), ...
                            S_contour(contour_idx).contour(:,2));
        in_city_mask = in_city_mask + in_contour_mask;
    end
    xLocations = xLocations(in_city_mask>0);
    yLocations = yLocations(in_city_mask>0);
    num = length(xLocations);
    disp("Number of Points In Contour(s): " + num2str(num))

    S_out.XLocation = xLocations;
    S_out.YLocation = yLocations;
end
