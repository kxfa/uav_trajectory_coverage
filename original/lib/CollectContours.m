function [S_contour_convex, S_contours] = CollectContours(excerptData, lat2meters, long2meters)
% [S_contour_convex, S_contours] = CollectContours(excerptData, lat2meters, long2meters)
% Reformulated by Yuxuan Fang on 08/02/2023.
%
% The excerptData is a string struct, which includes:
% minX_map_lat, minY_map_long, city_contours_file, convex_contour_file


    S_contour_convex = load(excerptData.convex_contour_file).S_out;
    S_contours       = load(excerptData.city_contours_file).S_out;

    minX_map_m = excerptData.minX_map_lat * lat2meters;
    minY_map_m = excerptData.minY_map_long * long2meters;

    S_contour_convex.contour(:,1) = round(S_contour_convex.contour(:,1)*lat2meters - minX_map_m);
    S_contour_convex.contour(:,2) = round(S_contour_convex.contour(:,2)*long2meters - minY_map_m);
    
    for idx = 1:size(S_contours,2)
        S_contours(idx).contour(:,1) = round(S_contours(idx).contour(:,1)*lat2meters - minX_map_m);
        S_contours(idx).contour(:,2) = round(S_contours(idx).contour(:,2)*long2meters - minY_map_m);
    end
end