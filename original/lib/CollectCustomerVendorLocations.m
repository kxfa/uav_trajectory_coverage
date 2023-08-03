function xyCustVend = CollectCustomerVendorLocations(cust_vend_file)
% xyCustVend = CollectCustomerVendorLocations(cust_vend_file)
    
    load_buildings = load(cust_vend_file);
    S_location = load_buildings.S_out;
    xy_data = cell2mat(struct2cell(S_location));
    xyCustVend = [xy_data(1:size(xy_data,1)/2),xy_data(1+size(xy_data,1)/2:end)];
end