function [S_out,num] = PolygonXYLocation(filePath, S_contour, config, oneContour)
% [S_out,num] = PolygonXYLocation(filePath, S_contour, config, oneContour)
% config is the output struct of OSM_Initialization().
% Yuxuan Fang 08/03/2023
    
    % save shape file to struct
    disp("Loading OSM File ...")
    [~, ~, ext] = fileparts(filePath);
    if ext == ".mat"
        load_buildings = load(filePath);
        S_raw = load_buildings.S_out;
        disp("Loading OSM Shape File Complete!")
    elseif ext == ".shp"
        S_raw = shaperead(filePath);
        disp("Loading OSM Mat File Complete!")
    end
    numTableRows_raw = size(struct2table(S_raw),1)

    % convert coordiantes to meters and normalize map dat to global 
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
    if oneContour
        S_contour.contour(:,1) = ...
            round(S_contour.contour(:,1)*config.lat2meters - config.minX_map_m);
        S_contour.contour(:,2) = ...
            round(S_contour.contour(:,2)*config.long2meters - config.minY_map_m);
    else
        for contour_idx = 1:size(struct2table(S_contour),1)
            S_contour(contour_idx).contour(:,1) = ...
                round(S_contour(contour_idx).contour(:,1)*config.lat2meters - config.minX_map_m);
            S_contour(contour_idx).contour(:,2) = ...
                round(S_contour(contour_idx).contour(:,2)*config.long2meters - config.minY_map_m);
        end
    end
    disp("Normalizing Map Complete!")

    xy_polygon_locations = zeros(size(struct2table(S_temp),1),2);
    for idx = 1:size(struct2table(S_temp),1)
        xy_polygon_locations(idx,1) = mean(S_temp(idx).X);
        xy_polygon_locations(idx,2) = mean(S_temp(idx).Y);   
    end

    xLocations = xy_polygon_locations(:,1);
    yLocations = xy_polygon_locations(:,2);
    disp("Number of Points In and Out of Contour(s): " ...
        + num2str(length(xLocations)))
    % confirm locations are within city boundaries
    in_city_mask = zeros([size(xLocations),1]);
    if oneContour
        in_contour_mask = inpolygon(xLocations,yLocations, ...
                                S_contour.contour(:,1), ...
                                S_contour.contour(:,2));
        in_city_mask = in_city_mask + in_contour_mask;
    else
        for contour_idx = 1:size(struct2table(S_contour),1)
            in_contour_mask = inpolygon(xLocations,yLocations, ...
                                S_contour(contour_idx).contour(:,1), ...
                                S_contour(contour_idx).contour(:,2));
            in_city_mask = in_city_mask + in_contour_mask;
        end
    end
    xLocations = xLocations(in_city_mask>0);
    yLocations = yLocations(in_city_mask>0);
    num = length(xLocations);

    disp("Number of Valid Points found: " + num2str(num))

    S_out.XLocation = xLocations;
    S_out.YLocation = yLocations;

end