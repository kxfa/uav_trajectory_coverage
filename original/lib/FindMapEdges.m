function mapEdges = FindMapEdges(S_input)
% mapEdges = FindMapEdges(S_input)
% Where mapEdges = [minX_map, minY_map, maxX_map, maxY_map];
% Find the edge of a map in a given area.
    
    minX_map = 1e12;
    minY_map = 1e12;
    maxX_map = -1e12;
    maxY_map = -1e12;

    for idx = 1:size(struct2table(S_input),1)
        
        if(minX_map > S_input.XLocation(idx))
            minX_map = round(S_input.XLocation(idx));
        end
        if(minY_map > S_input.YLocation(idx))
            minY_map = round(S_input.YLocation(idx));
        end
        if(maxX_map < S_input.XLocation(idx))
            maxX_map = round(S_input.XLocation(idx));
        end
        if(maxY_map < S_input.YLocation(idx))
            maxY_map = round(S_input.YLocation(idx));
        end
    end

    mapEdges = [minX_map, minY_map, maxX_map, maxY_map];

end