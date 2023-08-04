function total_distance = ComputeTotalDistance(path_coordinates)
% total_distance = ComputeTotalDistance(path_coordinates)

    total_distance = 0;
    for idx = 1:1:size(path_coordinates,1)-1
        line_distance = sqrt((path_coordinates(idx,1)-path_coordinates(idx+1,1))^2 ...
        + (path_coordinates(idx,2)-path_coordinates(idx+1,2))^2);
        total_distance = total_distance + line_distance;
    end
end