function [xLocations,yLocations] = CustomerVendorDistribution(density,xLattice,yLattice)
% [xLocations,yLocations] = CustomerVendorDistribution(density,xLattice,yLattice)
%   Randomly select points in customer regions (polygons) to serve as 
%   customer sensor and delivery locations
% 
%   Args:
%       density:    points (locations)/polygon_area (area [m^2])
%       xLattice:   integer array of x coords of the occupancy points i.e.
%                   the lattice/polygon points
%       yLattice:   integer array of y coords of the occupancy points i.e.
%                   the lattice/polygon points
%   Returns:
%       xLocations: integer array of x coords of customer locations
%       yLocations: integer array of y coords of customer locations
    
    totalNumberOfPoints = size(xLattice,1);
    
    % create binary array for random index selection
    D_uniform_rand = rand([totalNumberOfPoints,1]);
    D_uniform_hasD = D_uniform_rand <= density;

    % use binary array to select points
    xLocations = xLattice(D_uniform_hasD);
    yLocations = yLattice(D_uniform_hasD);
    
    % view for testing
    close all
    figure(98)
    hold on
    scatter(xLocations,yLocations,40,'b','filled')
    hold off
    xlabel('Longitude [meters]')
    ylabel('Lattitude [meters]')

    axis('equal')
end
