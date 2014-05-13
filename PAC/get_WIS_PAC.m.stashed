function get_WIS_PAC(outfile)
plotloc = '/home/thesser1/My_Matlab/Wis_plot/PAC/';
%get_file = ['X:\Atlantic\Evaluation\WW3\Model\',outfile(end-6:end),'\'];
get_file = ['/mnt/CHL_WIS_1/Pacific/Production/Model/',outfile(end-6:end),'/'];
if ~exist(outfile,'dir')
    mkdir(outfile);
end
cd(outfile);
loc{1} = [outfile,'/grd1'];
loc{2} = [outfile,'/grd2'];
loc{3} = [outfile,'/grd3'];
loc{4} = [outfile,'/grd4'];

for zz = 1:length(loc)
%     if ~exist(loc{zz},'dir')
%         mkdir(loc{zz});
%     end
    cd (loc{zz})
%     ii = strfind(loc{zz},'level');
%    copyfile([get_file,'*-LEVEL',loc{zz}(ii+5:end),'-MMt.tgz'],'.');
%    copyfile([get_file,'*-LEVEL',loc{zz}(ii+5:end),'-ST-onlns.tgz'],'.');
    ww3_read_PAC
    
end
sdir = outfile(1:end-7);
year = outfile(end-6:end-3);
mon = outfile(end-1:end);
timeseries_Arun(year,mon);
cd([sdir,'Validation/WIS/',year,'-',mon]);
track = [year,'-',mon];level = '';res = 0.5;
title1 = ['Pacific Hindcast Study [OWI Winds]'];

ff = [plotloc,'/PAC-plot.mat'];
if ~exist(ff,'file')
    return
end
load(ff);

stats = dir('n4*.onlns');
nn = 0;
locb = zeros(size(compend));
loci = locb;
for zz = 1:length(stats)
    buoyc = stats(zz).name(2:6);
    [wis,fflag] = read_WIS_onlns(['ST',buoyc,'.onlns']);
    if fflag == 0
        continue
    end
    buoy = read_NDBC_onlns(stats(zz).name);
    [tit1,saven] = PAC_names(buoyc,buoy,wis,track,level,res);
    timeplot_data(buoyc,buoy,wis,coord,tit1,saven,'m');
    stats_calc(buoyc,buoy,wis,'WW3-ST4','PAC',level,'m');
    ii = str2num(buoyc) == compend;
    if ~isempty(ii)
        nn = nn + 1;
        loci(ii) = 1;
        locb(ii) = nn;
        comp(nn) = struct('btime',buoy.time,'bwvht',buoy.wvht, ...
            'mtime',wis.time,'mwvht',wis.wvht,'mlat',wis.lat,'mlon',wis.lon);
    end
end
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
title1 = ['Pacific Hindcast Study [OWI Winds]'];
% year = outfile(end-6:end-3);
% mon = outfile(end-1:end);
archive_pac(year,mon);

end