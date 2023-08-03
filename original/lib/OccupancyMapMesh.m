function [S_out,num_buildings] = OccupancyMapMesh(filePath, numTableRows_raw, altitude, S_contour_convex, config)
% [S_out,num_buildings] = OccupancyMapMesh(filePath, numTableRows_raw, altitude, S_contour_convex, config)
%  
%       Args:
%            shapeFilePath = "SF_residential/residential_polygon.shp";
%            numTableRows:              first X number of regions from raw database to 
%                                       extract data from; set to 0 to extract from 
%                                       all rows          
%            minX_map_lat  (in config): minimum lattitue you'd expect (in degrees) to
%                                       ensure that all lattitude values are postive
%            minY_map_long (in config): minimum longitude you'd expect (in degrees) to
%                                       ensure that all lattitude values are postive
%            outputFilePath:            file destination to save output struct "S_out"
%            LocationType:              customer, vendor, or building
%
%        Returns:
%            S_out: for idx ranging 1 to numTables*percentage
%                - S_out(idx).XMesh
%                - S_out(idx).YMesh
%
%        `config` is the output struct of OSM_Initialization(). 

    map_minXY_meters = [config.minX_map_m, config.minY_map_m;
                        config.minX_map_m, config.minY_map_m];

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
        
    % number of rows in struct
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
        if altitude < 0
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
        else
            height = str2double(S_raw(raw_idx).height);
            if ~isnan(height) && height >= altitude
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
            else
                disp("!!! DELETED HEIGHT FOR SOME REASEON ???")
                disp(height)
                disp(S_raw(raw_idx).height)
            end
        end
    end
    S_contour_convex.contour(:,1) = round(S_contour_convex.contour(:,1)*config.lat2meters - config.minX_map_m);
    S_contour_convex.contour(:,2) = round(S_contour_convex.contour(:,2)*config.long2meters - config.minY_map_m);
    disp("Normalizing Map Data Coordinates Complete!")
    numTableRows_temp = size(struct2table(S_temp),1);
    num_buildings = numTableRows_temp;
    disp("Number of Buildings Above " + num2str(altitude*3.281) ...
        + "ft: " + num_buildings)
   
    % compute mesh coords
    disp("Computing Mesh Coordinates ...")
    for idx = 1:numTableRows_temp
        [S_temp(idx).XMesh,S_temp(idx).YMesh] = ...
            GenerateLatticePoints(S_temp(idx).BoundingBox, ...
                                    S_temp(idx).X, ...
                                    S_temp(idx).Y);
    end

    % count number of x and y coordinates
    disp("Initilziing Mesh Arrays ...")
    numXYMesh_coords = 0;
    for idx = 1:numTableRows_temp
        numXYMesh_coords = numXYMesh_coords + size(S_temp(idx).XMesh,1);   
    end
    allLatticeX = zeros([numXYMesh_coords,1]);
    allLatticeY = zeros([numXYMesh_coords,1]);
    
    disp("Adding Mesh Coordinates to Arrays ...")
    idx_pos = 1;
    for idx = 1:numTableRows_temp
        space = size(S_temp(idx).XMesh,1);
        try
            allLatticeX(idx_pos:idx_pos+space-1) = S_temp(idx).XMesh;
            allLatticeY(idx_pos:idx_pos+space-1) = S_temp(idx).YMesh;
        catch ME
            disp(ME)
            disp("Size of LeftX")
            disp(size(allLatticeX(idx_pos:idx_pos+space-1)))
            disp("Size of RightX")
            disp(size(S_temp(idx).XMesh))
            disp(ME)
            disp("Size of LeftY")
            disp(size(allLatticeY(idx_pos:idx_pos+space-1)))
            disp("Size of RightY")
            disp(size(S_temp(idx).YMesh))
        end
        idx_pos = idx_pos + size(S_temp(idx).XMesh,1);
    end

    allLatticeX = allLatticeX(allLatticeX ~= 0);
    allLatticeY = allLatticeY(allLatticeY ~= 0);

    % ensure points are within the convex contour
    xLocations = allLatticeX;
    yLocations = allLatticeY;

    % confirm building locations are within convex contour of city    
    in_city_mask = inpolygon(xLocations,yLocations, ...
                        S_contour_convex.contour(:,1), ...
                        S_contour_convex.contour(:,2));

    xLocations = xLocations(in_city_mask>0);
    yLocations = yLocations(in_city_mask>0);

    allLatticeX = xLocations;
    allLatticeY = yLocations;

    % store mesh arrays in output struct
    S_out(1).ObstacleLocationX = allLatticeX;
    S_out(1).ObstacleLocationY = allLatticeY;

end
