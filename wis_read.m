function wis_read(bas,slash,fillm,varargin)
%
%    ww3_read
%      reads WIS post processing scripts and runs figure creators
%      created by TJ Hesser 03/20/2013
%
%    INPUT:
%      bas   STRING : 3 charater id for basin i.e. GOM, ATL, PAC
% -------------------------------------------------------------------------
% run EXP_info.m to load in directory listings
p = inputParser;
p.addRequired('bas');
p.addRequired('slash');
p.addRequired('fillm');
p.addOptional('year',9999);
p.addOptional('mon',99);
p.addOptional('iceC','OOO');
p.addOptional('storm','blah');
p.addOptional('units','m');
parse(p,bas,slash,fillm,varargin{:});

year = p.Results.year;
mon = p.Results.mon;
iceC = p.Results.iceC;
stormn = p.Results.storm;
unts = p.Results.units;

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
fclose(fid);
time1 = num2str(data{1});time2 = num2str(data{2});
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
% grab year month
year1 = str2double(time1(1:4));
mon1 = str2double(time1(5:6));
day1 = str2double(time1(7:8));
year2 = str2double(time2(1:4));
mon2 = str2double(time2(5:6));
day2 = str2double(time2(7:8));
date = [year1 mon1 day1 year2 mon2 day2];
% evaluation names taken from file name
% track = year-mon
%track = [filename1(1:4),'-',filename1(5:6)];
if ~strcmp(stormn,'blah')
    track = stormn;
else
    track = [year,'-',mon];
end
bbop = pwd;
%ii = strfind(bbop,gridid);
%if ~isempty(ii)
%level = bbop(ii:end);
%else
%    level = 'LEVEL1';
%end
ii = regexp(bbop,slash);
level = bbop(ii(end)+1:end);
    % level = year-mon-level
    track = [track,'-',level];

% call contour plot of max mean
%
% -------------------------------------------------------------------
wis_cont(track,modelnm,plotloc,bas,'trackp',1,'iceC',iceC)
% -------------------------------------------------------------------
loc = pwd;

% go out to raid and grab any validation data sets
%timeseries_get(date,level, ...
%   localdir,plotloc,rdir,storm)

%year = str2num(filename1(1:4));
%mon = str2num(filename1(5:6));
% load in plot information from -plot.mat file
ff = [plotloc,slash,bas,'-',level,'-plot.mat'];
if ~exist(ff,'file')
    return
end
load(ff);

file = dir('*ST-onlns.tgz');
if size(file,1) == 0
   file = dir('*STNS_*_onlns.tgz');
end
if size(file,1) == 0
    file = dir('*STNS*ONLNS.tgz');
end
if size(file,1) == 0
    file = dir('*ST_ONLNS.tgz');
end
if size(file,1) == 0
    file = dir('*STNS*onlns.tgz');
end
if size(file,1) == 0
    return
end
untar(file.name)
fname = dir('*.onlns');

dirname = [pwd,'/Validation',slash];
if ~exist(dirname,'dir')
    mkdir(dirname);
end
movefile('*.onlns',dirname);
cd(dirname)

load([plotloc,slash,bas,'-',level,'-buoy.mat']);
stations = buoy(:,3);

% identify validation data sets 
%stats = dir('n4*.onlns');
nn = 0;
locb = zeros(size(compend));
loci = locb;
for zz = 1:length(stations)
    % identify name of buoy
    %buoyc = stats(zz).name(2:6);
    buoyc = num2str(stations(zz));
    [buoy,flag] = timeseries_read(date,rdir,buoyc);
    if flag == 0
        continue
    end
    % load in buoy data
    %buoy = read_NDBC_onlns(stats(zz).name);
    % search directory for location file added 2013/05/06 
    fbdir = [bdir,level];
    if ~exist(fbdir,'dir');
        fbdir = bdir;
    end
    fb = [fbdir,slash,'n',buoyc,'.locs'];
    if exist(fb,'file') %%%%%%%%%NOT DONE
        ab = load(fb);
        if ab(1,1) >= 40000
            ibou = 1;
            ilon = 2;
            ilat = 3;
        else
            ilon = 1;
            ilat = 2;
            ibou = 3;
        end
        vv1 = abs(repmat(str2num(buoy.lonc),[size(ab,1) 1]) ...
            - ab(:,ilon));
        vv2 = abs(repmat(str2num(buoy.latc),[size(ab,1) 1]) ...
            - ab(:,ilat));
        [vv, idx] = min(sqrt(vv1.^2 + vv2.^2));
        buoycw = num2str(ab(idx,ibou));
    else
        buoycw = buoyc;
    end
    % load in model results for buoy
    wis = read_WIS_onlns(['ST',buoycw,'.onlns']);
    if ~isstruct(wis)
        continue
    end
    % load in plotting information 
    eval(['[tit1,saven,tit2] = ',bas,'_names(buoyc,buoy,wis,track,level,res);']);
    % call plotting routine for timeplots
    %--------------------------------------------------------------
    timeplot_WIS(buoyc,buoy,wis,coord,tit1,saven,unts,1,fillm);
    % -------------------------------------------------------------
    % calculate and plot statistics 
    %--------------------------------------------------------------
    stats_calc(buoyc,buoy,wis,modelnm,saven,track,unts);
    %--------------------------------------------------------------
    % identify if buoy is part of a compendium plot
    ii = str2num(buoyc) == compend;
    if ~isempty(ii)
        % if so, store information in structured array
        imb = buoy.time >= wis.time(1) & buoy.time <= wis.time(end); 
        if ~isempty(buoy.time(imb))
            nn = nn + 1;
            loci(ii) = 1;
            locb(ii) = nn;
            comp(nn) = struct('btime',buoy.time(imb),'bwvht',buoy.wvht(imb), ...
            'time',wis.time,'mwvht',wis.wvht,'mlat',buoy.lat,'mlon',buoy.lon);
        end
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
        compplot_data(zz,stations,data,compc(zz,:),tit2,track,saven,fillm)
    end
end
delete *.onlns
close all

%% -----------------------------------------------------------------
% Plot single stats for each level in a run
% ------------------------------------------------------------------
%data = conc_mat_files(dirname);

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
