function [xLattice,yLattice] = GenerateLatticePoints(bbox,xContourPoints,yContourPoints)
    % [xLattice,yLattice] = GenerateLatticePoints(bbox,xContourPoints,yContourPoints)
    %   Generate lattice points for each building to surve as occupancy
    %   points, accounting for buildings with irregular footprints
    %
    %   Args:
    %       bbox:     array of building footprint [xmin,ymin;xmax,ymax]
    %       xPoints:  array of postive x coords of building contour points
    %       yPoints:  array of postive y coords of building contour points
    %   Returns:
    %       xLattice: integer array of x coords of the occupancy points
    %       yLattice: integer array of y coords of the occupancy points

    % scale down large coordinate values (found was necessary for values 
    % on the order of 1e12)
    minXY = [min(xContourPoints),min(yContourPoints)];
    bbox = bbox - minXY;
    xContourPoints  = xContourPoints - minXY(1);
    yContourPoints = yContourPoints  - minXY(2);

    % find all points within and on the edge of the bounding box
    [xAllPoints,yAllPoints] = meshgrid(bbox(1):bbox(2),bbox(3):bbox(4));

    % find all points within and on the edge of irregular building 
    % footprint + scale-up the coordiantes to their original magnitudes
    inPoints = inpolygon(xAllPoints,yAllPoints,xContourPoints,yContourPoints);
    xLattice = xAllPoints(inPoints) + minXY(1);
    yLattice = yAllPoints(inPoints) + minXY(2);

%     % view for testing
%     figure(99)
%     hold on
%     scatter(xAllPoints,yAllPoints,40,'r','filled')
%     scatter(xAllPoints(inPoints),yAllPoints(inPoints),40,'g','filled')
%     plot(xContourPoints,yContourPoints,'b','linewidth',3)
%     scatter(xContourPoints,yContourPoints,40,'b','filled')
%     hold off

end