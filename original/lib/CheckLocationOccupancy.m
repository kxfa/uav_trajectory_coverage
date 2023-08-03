function xy_out = CheckLocationOccupancy(omap, xy_locations)
% xy_out = CheckLocationOccupancy(omap, xy_locations)

    occ_check_cust = checkOccupancy(omap,xy_locations);
    % Seperate positions on unoppupied and occupied space
    xy_unoccupied = xy_locations(occ_check_cust==0,:);
    xy_out = zeros([size(xy_locations)]);
    num_unoccupied_initially = size(xy_unoccupied,1);
    xy_out(1:num_unoccupied_initially,:) = xy_unoccupied;
    xy_occupied = xy_locations(occ_check_cust==1,:);
    % Randomly move positions on occupied spaces until they are no longer on 
    % occupied spaces
    if size(xy_occupied,1) > 0
        for idx = 1:size(xy_occupied,1)
            occupied = true;
            pos = xy_occupied(idx,:);
            while occupied
                % Pick random direction and allow max movement of 2 steps
                r = 2;
                theta_rand = rand(1)*2*pi - pi;
                xy_rand = [r*cos(theta_rand),r*sin(theta_rand)];
                pos = pos + xy_rand;
                occupied = checkOccupancy(omap,pos);
            end
            xy_out(num_unoccupied_initially+idx,:) = pos;
        end
    end
end