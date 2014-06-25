%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xyz2_grd_mask_obstr.m
%
% Script to take an .xyz file and creates the following files in a 
% specified output directory:
%       .grd from the Z column
%       .mask generated and cleaned using WW3
%       .obstr generated using WW3
%
% NOTE:
%   .xyz must be a three column array arranged      | lon | lat |  z  |
%   Script must be initialized
%
% Created:  John Goertz
%           May 2013 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
fnamein = 'ATL_level1_30m';     %Name of file (omit extension .xyz)
fnameout = 'ATL_L1_30m';           %Prefix name for output files
out_dir = './';                     %Location for output files
depth_scale = 1000;                 %Scale for .grd depth file
obstr_scale = 100;                  %Scale for .obstr file

ref_dir = '/home/thesser1/My_Matlab/gridgen/reference_data/';     %Location of boundary files
boundary = 'full';                  %Boundary resolution wanted

% Input .xyz and convert to lat/lon/depth variables
[lat,lon,depth] = xyz2grd(load([fnamein,'.xyz']));
if lon <=0
    lon = lon + 360;
end

% Read in boundary
if ~exist('bound')
    fprintf(1,'.........Reading Boundaries..................\n');
    load([ref_dir,'/coastal_bound_',boundary,'.mat']); 
end

% Compute boundaries within the domain
fprintf(1,'.........Computing Boundaries..................\n');
coord = [lat(1)-2 lon(1)-2 lat(end)+2 lon(end)+2];
[b,N1] = compute_boundary(coord,bound);

fprintf(1,'.........Splitting Boundaries..................\n');
b_split = split_boundary(b,2);

% Set up and generate cleaned mask
m = ones(size(depth)); 
loc = depth >= 0;
m(loc) = 0;

fprintf(1,'.........Cleaning Mask..................\n');
m2 = clean_mask(lon,lat,m,b_split,0.5);

fprintf(1,'.........Separating Water Bodies..................\n');
[m3,mask_map] = remove_lake(m2,-1,0);

% Generate sub-grid obstructions
fprintf(1,'.........Creating Obstructions..................\n');
[sx1,sy1] = create_obstr(lon,lat,b_split,m3,1,1);

% Create output files .grd, .mask, and .obstr
write_ww3file([out_dir,'/',fnameout,'.grd'],round(depth.*depth_scale));
write_ww3file([out_dir,'/',fnameout,'.mask'],m3);
write_ww3obstr([out_dir,'/',fnameout,'.obstr'],...
               round((sx1).*obstr_scale),round((sy1).*obstr_scale));
write_ww3meta([out_dir,'/',fnameout],lon,lat,1/depth_scale,1/obstr_scale);

% End of Script