function [S_out, num_buildings] = PolygonMapCoords(filePath, numTableRows_raw, altitude, ...
                                                   S_contour_convex, config,...
                                                   decimate, makeMeters)
% function [S_out, num_buildings] = PolygonMapCoords(filePath, numTableRows_raw, altitude, ...
%                                                   S_contour_convex, config,...
%                                                   decimate, makeMeters)
%
% filePath, numTableRows_raw, altitude are string or numbers.
% S_contour_convex and config are structs. struct is from initialization.
% decimate and makeMeters are bools.

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
        
    % number of rows in struct
    if numTableRows_raw == 0
        numTableRows_raw = size(struct2table(S_raw),1);
    end
     
    
    % convert coordiantes to meters and normalize map dat to global 
    % reference point map_min_meters
    disp("Normalizing Map Data Coordinates ...")
    S_temp = struct;
    if makeMeters
        temp_idx = 1;
        for raw_idx = 1:numTableRows_raw
            height = str2double(S_raw(raw_idx).height);
            if ~isnan(height) && height > altitude
                S_temp(temp_idx).X = ...
                    round(rmmissing(S_raw(raw_idx).X) * ...
                    config.lat2meters - config.minX_map_m);
                S_temp(temp_idx).Y = ...
                    round(rmmissing(S_raw(raw_idx).Y) * ...
                    config.long2meters - config.minY_map_m);
                temp_idx = temp_idx + 1;
            end
        end
    else
        temp_idx = 1;
        for raw_idx = 1:numTableRows_raw
            height = str2double(S_raw(raw_idx).height);
            if ~isnan(height) && height > altitude
                disp(raw_idx)
                S_temp(temp_idx).X = rmmissing(S_raw(raw_idx).X);
                S_temp(temp_idx).Y = rmmissing(S_raw(raw_idx).Y);
                temp_idx = temp_idx + 1;
            else
                disp(raw_idx)
            end
    
        end
    end
    
    S_contour_convex.contour(:,1) = round(S_contour_convex.contour(:,1)*config.lat2meters - config.minX_map_m);
    S_contour_convex.contour(:,2) = round(S_contour_convex.contour(:,2)*config.long2meters - config.minY_map_m);
    disp("Normalizing Map Complete ...")
    numTableRows_temp = size(struct2table(S_temp),1);
    
    
    % confirm building locations are within convex contour of city
    S_temp2 = struct;
    temp2_idx = 1;
    for temp_idx = 1:numTableRows_temp
        xLocations = S_temp(temp_idx).X;
        yLocations = S_temp(temp_idx).Y;
        in_city_mask = inpolygon(xLocations,yLocations, ...
                            S_contour_convex.contour(:,1), ...
                            S_contour_convex.contour(:,2));
        if length(xLocations) - length(xLocations(in_city_mask==1)) == 0
            S_temp2(temp2_idx).X = xLocations;
            S_temp2(temp2_idx).Y = yLocations;
            temp2_idx = temp2_idx + 1;
        end
    end
    
    S_temp = S_temp2;
    numTableRows_temp = size(struct2table(S_temp),1);
    num_buildings = numTableRows_temp;
    disp("Number of Buildings Above " + num2str(altitude*3.281) ...
        + "ft and in Contour: " + num_buildings)

    disp("Collecting Polygon Coordinates ...")
    % count number of polygon coordinates
    num_poly_coords = 0;
    for idx = 1:numTableRows_temp
        num_poly_coords = num_poly_coords + size(S_temp(idx).X,2);   
    end
    if decimate
        vertices_RPS = [];
    else
        vertices_RPS = zeros([num_poly_coords,3]);
    end
    
    % save and index polygon points for visibility graph
    row_idx = 1;
    count = 0;
    for polygon_idx = 1:numTableRows_temp
        if decimate
            if size(S_temp(polygon_idx).X,2) > 10 % decimate large polygons
                polygon = DecimatePoly([[S_temp(polygon_idx).X';S_temp(polygon_idx).X(1)], ...
                                [S_temp(polygon_idx).Y';S_temp(polygon_idx).Y(1)]],[0.5 2], 0);
                count = count + 1;
            elseif size(S_temp(polygon_idx).X,2) > 20 % decimate large polygons
                polygon = DecimatePoly([[S_temp(polygon_idx).X';S_temp(polygon_idx).X(1)], ...
                                    [S_temp(polygon_idx).Y';S_temp(polygon_idx).Y(1)]],[0.25 2], 0);
                count = count + 1;
            else
                polygon = [[S_temp(polygon_idx).X';S_temp(polygon_idx).X(1)], ...
                                    [S_temp(polygon_idx).Y';S_temp(polygon_idx).Y(1)]];
            end
        else
            polygon = [[S_temp(polygon_idx).X';S_temp(polygon_idx).X(1)], ...
                                    [S_temp(polygon_idx).Y';S_temp(polygon_idx).Y(1)]];
        end
        num_pnts = size(polygon,1);
        vertices_RPS(row_idx:row_idx+num_pnts-1,:) = ...
                                   [polygon, polygon_idx*ones(num_pnts,1)];
        row_idx = row_idx + num_pnts;
    end
    disp("Collecting Polygon Coordinates Complete!")
    
    
    S_out(1).vertices_RPS = vertices_RPS;
    disp("Number of Decimations: " + num2str(count))

end