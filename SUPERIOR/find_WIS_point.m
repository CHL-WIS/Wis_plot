function [buoyc,kout]=find_WIS_point(buoyci,buoy,plotloc)
%
%
lon = buoy.lon;
lat = buoy.lat;
%
% Load in the WAM File
%  And find the closest location to the buoy site.
%
aname = [plotloc,'\LKSUPERIOR-',buoyci(2:6),'.txt'];
if ~exist(aname,'file');
    kout = 0;
    buoyc = 0;
else
    A=load(aname);
    kout = 1;
end

ii = kNearestNeighbors(A(:,2:3),[str2num(lon) str2num(lat)],1);

buoyc = num2str(A(ii,1));