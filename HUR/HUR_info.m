% EXP_info
%
% template for *_info.m file to identify parameters in WIS plotting routine
%    created by TJ Hesser
%
%    adjust all extensions for each computer and basin
%
% -------------------------------------------------------------------------
title1 = ['Lake Huron Hindcast Study [CFSR Winds]'];  % Title for 
%plotloc = 'C:\Users\rdchlrej\Documents\MATLAB\matlab_2011\Wis_plot\HUR\';  % Location of Matlab directory for basin
plotloc = '/home/thesser1/My_Matlab/Wis_plot/HUR/';
%rdir = 'Z:\';  % Top level location of WIS raid
rdir = '/mnt/CHL_WIS_1/';
%bdir = 'Z:\LAKE_HURON\Production\Buoy_Locs\'; % Buoy Loc Directory
bdir = '/mnt/CHL_WIS_1/LAKE_HURON/Production/Buoy_Locs/';
%localdir='G:\DATA\WIS-LAKE-HURON\Production\outdat';  % Local directory of files
localdir = '/home/thesser1/HURON/';
modelnm = 'WAM-CY451C';  % Model information
gridid = 'LEVEL';  % Indentifier of subgrids i.e. LEVEL/level/nest/grid