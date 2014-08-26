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
[date, res, type] = get_date;

if ~strcmp(stormn,'blah')
    track = stormn;
else
    track = [year,'-',mon];
end
bbop = pwd;

ii = regexp(bbop,slash);
level = bbop(ii(end)+1:end);
    % level = year-mon-level
    track = [track,'-',level];

% call contour plot of max mean
%
fprintf(1,'Creating contours\n')
% -------------------------------------------------------------------
if strcmp(type,'*.nc')
    wis_cont_nc(track,modelnm,plotloc,bas,'trackp',1,'iceC',iceC)
else
    wis_cont(track,modelnm,plotloc,bas,'trackp',1,'iceC',iceC)
end
% -------------------------------------------------------------------
loc = pwd;

% load in plot information from -plot.mat file
ff = [plotloc,slash,bas,'-',level,'-plot.mat'];
if ~exist(ff,'file')
    return
end
load(ff);
file = dir('*points.tgz');
if size(file,1) == 0
    file = dir('*ST-onlns.tgz');
end
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
fname = dir('ST*.nc');
if size(fname,1) == 0
    fname = dir('*.onlns');
end
dirname = [pwd,'/Validation',slash];
if ~exist(dirname,'dir')
    mkdir(dirname);
end

movefile(['ST',type],dirname);
cd(dirname)

buoyfile = [plotloc,slash,bas,'-',level,'-buoy.mat'];
if exist(buoyfile,'file')
    load([plotloc,slash,bas,'-',level,'-buoy.mat']);
    stations = buoy(:,3);
else
    fdd = dir([bdir,'Buoy_Locs',slash,level,slash,'*.locs']);
    for ii = 1:length(fdd)
        stations(ii,1) = str2num(fdd(ii).name(2:6));
    end
end

fprintf(1,'Running point source validation\n')
% identify validation data sets 
nn = 0;
locb = zeros(size(compend));
loci = locb;
for zz = 1:length(stations)
    % identify name of buoy
    buoyc = num2str(stations(zz));
    [buoy,flag] = timeseries_read(date,rdir,buoyc);
    if flag == 0
        continue
    end
    % search directory for location file added 2013/05/06 
    fbdir = [bdir,'Buoy_Locs',slash,level];
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
    if strcmp(type,'*.nc')
        wis = read_WIS_nc_stat(['ST',buoycw,'_',year,'_',mon,'.nc']);
    else
        wis = read_WIS_onlns(['ST',buoycw,'.onlns']);
    end
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
            comp(nn) = struct('btime',buoy.time(imb),'bwvht',buoy.wavhs(imb), ...
            'time',wis.time,'mwvht',wis.wavhs,'mlat',buoy.lat,'mlon',buoy.lon);
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
