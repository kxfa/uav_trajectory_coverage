function path_coordinates = OriginDesitnation(start, goal, num_trajectroy_pnts)
% path_coordinates = OriginDesitnation(start,goal,num_trajectroy_pnts)

    x_coords = linspace(start(1), goal(1), num_trajectroy_pnts);
    y_coords = linspace(start(2), goal(2), num_trajectroy_pnts);
    path_coordinates = [x_coords(:), y_coords(:)];
    
end