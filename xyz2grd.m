function [lat,lon,z] = xyz2grd(xyz,fname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [lat,lon,z] = xyz2grd(xyz,fname)
%
% Takes xyz geographic file and returns a lat, lon and z array
% Optionally creates a .grd and .mask file from the z array. 
%
% INPUT
%   xyz     -   (2D Array) Three column array     | lon | lat |  z  |
% optional:
%   fname   -   (String) Filename for .grd and .mask, no files will be
%                        created if no input
%
% OUTPUT
%   lat     -   (1D Array) Latitude Array
%   lon     -   (1D Array) Longitude Array
%   z       -   (2D Array) Matrix of size (ny rows,nx columns)
%
% Created:  John Goertz
%           May 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if xyz(2,1)-xyz(1,1) == 0
    disp('Longitude and Latitude columns appear to be switched')
    disp('Please make sure xyz columns are orderd    | lon | lat |  z  | ')
    return
else
    dx = xyz(2,1) - xyz(1,1);
end

nx = round((max(xyz(:,1)) - min(xyz(:,1)))/dx + 1);
ny = round((max(xyz(:,2)) - min(xyz(:,2)))/dx + 1);

if max(xyz(:,1)) == xyz(nx,1)
else
    disp('Check Longitude column in .xyz file for rounding errors')
    return
end

lon = xyz(1:nx,1);
lat = xyz(1:nx:end,2);

z = zeros(ny,nx);
for ii = 1:ny
    z(ii,(1:nx)) = xyz((1:nx)+(ii-1)*nx,3);
end

mask = ones(size(z)); 
loc = z >= 0;
mask(loc) = 0;

if exist('fname')
    dlmwrite([fname,'.grd'],z,'precision','%.6f','delimiter', ' ')
    dlmwrite([fname,'.mask'],mask,'delimiter',' ')
end
end