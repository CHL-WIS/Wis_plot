function ww3_read(bas,year,mon)
%
%    ww3_read
%      reads WIS post processing scripts and runs figure creators
%      created by TJ Hesser 03/20/2013
%
%    INPUT:
%      bas   STRING : 3 charater id for basin i.e. GOM, ATL, PAC
% -------------------------------------------------------------------------
% run EXP_info.m to load in directory listings
eval([bas,'_info']);
storm = bas;
% finds name of MMt.tgz file
files1 = dir('*MMt.tgz');
if size(files1,1) == 0
    files1 = dir('*MMd.tgz');
end
filename1 = getfield(files1,'name');
% untar MMt.tgz file
untar(filename1);
% read in Max-mean file (file name needs to change depending on model)
ffn = dir('Max*.dat');
fid = fopen(ffn.name);
data = textscan(fid,'%f%f%f%f%f%f%f%f',1);
% identify lat and lon coordinates from header
if ~isempty(strfind(ffn.name,'ww3'))
    lonw = data{3};
    lone = data{4};
    nlon = data{5};
    lats = data{6};
    latn = data{7};
    nlat = data{8};
    res = (latn - lats)/(nlat-1);
else
    res = data{3};
    lats = data{5};
    latn = data{6};
    lonw = data{7};
    lone = data{8};
    nlon = (lone - lonw)/res + 1;
    nlat = (latn - lats)/res + 1;
end

% evaluation names taken from file name
% track = year-mon
%track = [filename1(1:4),'-',filename1(5:6)];
track = [year,'-',mon];
bbop = pwd;
ii = strfind(bbop,gridid);
if ~isempty(ii)
    level = bbop(ii:end);
else
    level = 'L1';
end
    % level = year-mon-level
    track = [track,'-',level];

% call contour plot of max mean
ww3_cont(track,modelnm,plotloc,bas)
loc = pwd;

% go out to raid and grab any validation data sets
timeseries_get(year,mon,level, ...
   localdir,plotloc,rdir,storm)

year = str2num(filename1(1:4));
mon = str2num(filename1(5:6));
% load in plot information from -plot.mat file
ff = [plotloc,'/',bas,'-',level,'-plot.mat'];
if ~exist(ff,'file')
    return
end
load(ff);

% identify validation data sets 
stats = dir('n4*.onlns');
nn = 0;
locb = zeros(size(compend));
loci = locb;
for zz = 1:length(stats)
    % identify name of buoy
    buoyc = stats(zz).name(2:6);
    % load in model results for buoy
    wis = read_WIS_onlns(['ST',buoyc,'.onlns']);
    % load in buoy data
    buoy = read_NDBC_onlns(stats(zz).name);
    if ~isstruct(wis)
        continue
    end
    % load in plotting information 
    eval(['[tit1,saven] = ',bas,'_names(buoyc,buoy,wis,track,level,res);']);
    % call plotting routine for timeplots
    timeplot_WIS(buoyc,buoy,wis,coord,tit1,saven,'m');
    % calculate and plot statistics 
    stats_calc(buoyc,buoy,wis,modelnm,saven,'m');
    % identify if buoy is part of a compendium plot
    ii = str2num(buoyc) == compend;
    if ~isempty(ii)
        % if so, store information in structured array
        nn = nn + 1;
        loci(ii) = 1;
        locb(ii) = nn;
        comp(nn) = struct('btime',buoy.time,'bwvht',buoy.wvht, ...
            'mtime',wis.time,'mwvht',wis.wvht,'mlat',wis.lat,'mlon',wis.lon);
    end
end
% plot compedium plots identified previously
loci = logical(loci);
for zz = 1:size(compend,1)
    id = locb(zz,loci(zz,:));
    if ~isempty(id)
        data = comp(id);
        stations = compend(zz,loci(zz,:));
        compc(zz,compc(zz,1:2) < 0) = compc(zz,compc(zz,1:2) < 0) + 360;
        compplot_data(zz,stations,data,compc(zz,:),title1,track,saven)
    end
end
delete *.onlns
close all

%or_val_set(filename1(1:4),filename1(5:6));
%cd('C:/IMEDS 3.1/src/process');
%imeds

% date1 = [filename1(1:6),'01000000'];
% mon2 = str2double(filename1(5:6)) + 1;
% year2 = str2double(filename1(1:4));
% if mon2 > 12
%     mon2 = 1;
%     year2 = str2double(filename(1:4)) + 1;
% end
% if mon2 < 10
%     mon2s = ['0',num2str(mon2)];
% else
%     mon2s = num2str(mon2);
% end
% date2 = [num2str(year2),mon2s,'01000000'];
% alt_data = read_alt(date1,date2,lonw,lone,lats,latn,res);
% ww3_alt(alt_data,loc);
% close all
% delete ww3.*.hs
