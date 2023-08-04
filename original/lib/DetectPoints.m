function path_coordinates_detected = DetectPoints(path_coordinates, xyBuildingSensorLocations, D_rad)
% path_coordinates_detected = DetectPoints(path_coordinates, xyBuildingSensorLocations, D_rad)
    
    num_trajecotry_pnts = size(path_coordinates,1);

    % comptue trajectory coverage
    x1 = path_coordinates(:,1);
    y1 = path_coordinates(:,2);
    x2 = xyBuildingSensorLocations(:,1);
    y2 = xyBuildingSensorLocations(:,2);
    
    Z = zeros(num_trajecotry_pnts,1);
    for traj_pnt = 1:num_trajecotry_pnts
        Z(traj_pnt) = min((x1(traj_pnt)-x2).^2 + (y1(traj_pnt)-y2).^2);
    end
%     % vecotrized distance equation (that runs slower?)
%     Z = min(x1.^2 - 2*x1*x2' + x2'.^2 + y1.^2 - 2*y1*y2' + y2'.^2,[],2);
    
    path_coordinates_detected = [x1(Z<=D_rad.^2),y1(Z<=D_rad.^2)];
end