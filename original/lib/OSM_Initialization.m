function config = OSM_Initialization(city)
% config = OSM_Initialization(city)
% Yuxuan Fang 08/03/2023
% Supported cities are 'SF', 'LA', 'NYC'.

switch(city)
     case 'SF'
            minX_map_lat  = -130;
            minY_map_long = 0;
     case 'LA'
            minX_map_lat  = -130;
            minY_map_long = 0;
     case 'NYC'
            minX_map_lat  = -100;
            minY_map_long = 15;
     otherwise
            error('Invalid city.')
end

config.lat2meters  = 10000000/90;
config.long2meters = 40075161.2/360;
config.minX_map_m  = minX_map_lat * config.lat2meters;
config.minY_map_m  = minY_map_long * config.long2meters;

end