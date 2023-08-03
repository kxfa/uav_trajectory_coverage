function [S_out,num_customers] = CustomerStopLocations(shapeFilePath, numTableRows_raw, density,...
                                        S_contour, config)
% [S_out,num_customers] = CustomerStopLocations(shapeFilePath, numTableRows_raw, density,...
%                                               S_contour, config)
%
% `config` is the initialization function output.

    map_minXY_meters = [config.minX_map_m, config.minY_map_m;
                        config.minX_map_m, config.minY_map_m];

    S_raw = shaperead(shapeFilePath);
    
    if numTableRows_raw == 0
        numTableRows_raw = size(struct2table(S_raw),1);
    end
    
    % convert coordiantes to meters and normalize map dat to global 
    % reference point map_min_meters
    disp("Normalizing Map Data Coordinates ...")
    temp_idx = 1;
    S_temp.X = [];
    S_temp.Y = [];
    S_temp.BoundingBox = [];
    for raw_idx = 1:numTableRows_raw
        S_temp(temp_idx).BoundingBox = ...
            round(S_raw(raw_idx).BoundingBox.* ...
            [config.lat2meters,config.long2meters]) - map_minXY_meters;
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
    disp("Normalizing Map Data Coordinates Complete!")
    

    % compute mesh coords
    disp("Computing Mesh Coordinates ...")
    for idx = 1:numTableRows_raw
        disp(num2str(idx) + " of " + num2str(numTableRows_raw))
        [S_temp(idx).XMesh,S_temp(idx).YMesh] = ...
            GenerateLatticePoints(S_temp(idx).BoundingBox, ...
                                    S_temp(idx).X, ...
                                    S_temp(idx).Y);
    end
    disp("Computing Mesh Coordinates Complete!")
    
    numXYMesh_coords = 0;
    for idx = 1:numTableRows_raw
        numXYMesh_coords = numXYMesh_coords + size(S_temp(idx).XMesh,1);
        
    end
    allLatticeX = zeros([numXYMesh_coords,1]);
    allLatticeY = zeros([numXYMesh_coords,1]);
    
    disp("Collecting Mesh Coordinates ...")
    idx_pos = 1;
    for idx = 1:numTableRows_raw
        space = size(S_temp(idx).XMesh,1);
        allLatticeX(idx_pos:idx_pos+space-1) = S_temp(idx).XMesh;
        allLatticeY(idx_pos:idx_pos+space-1) = S_temp(idx).YMesh;
        idx_pos = idx_pos + size(S_temp(idx).XMesh,1);
    end
    disp("Collecting Mesh Coordinates Complete!")

    % select drone stops
    disp("Choosing Customer Stop Locations ...")
    [xLocations,yLocations] = ...
        CustomerVendorDistribution(density,allLatticeX,allLatticeY);
    

    % confirm customer locations are within city boundaries
    in_city_mask = zeros([size(xLocations),1]);
    for contour_idx = 1:size(struct2table(S_contour),1)
        in_contour_mask = inpolygon(xLocations,yLocations, ...
                            S_contour(contour_idx).contour(:,1), ...
                            S_contour(contour_idx).contour(:,2));
        in_city_mask = in_city_mask + in_contour_mask;
    end
    xLocations = xLocations(in_city_mask>0);
    yLocations = yLocations(in_city_mask>0);
    disp("Choosing Customer Stop Locations Complete!")
    
    num_customers = size(xLocations,1);
    disp("Numer of Customers/Vendors Chosen: " + num2str(num_customers))
    S_out.XLocation = xLocations;
    S_out.YLocation = yLocations;
end