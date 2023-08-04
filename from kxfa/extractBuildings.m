
function inReachableSet = extractBuildings(theReachableSet, xyQuery)
    inReachableSet = inpolygon(xyQuery(:, 1), xyQuery(:, 2), theReachableSet(:, 1), theReachableSet(:, 2));
end