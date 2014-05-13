function timeseries_get(year,mon,level,mdir,pdir,rdir,basin)
%
if isunix
    slash = '/';
else
    slash = '\';
end
month = {'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct'; ...
    'nov';'dec'};
%  year and mon are characters
if ~ischar(year)
    year = num2str(year);
end
if ~ischar(mon)
    if mon < 10
        mon = ['0',num2str(mon)];
    else
        mon = num2str(mon);
    end
end
yearm = [year,'-',mon];

    dir1 = [mdir,slash,yearm,slash,level,slash];
    try
        cd(dir1);
    catch
        dir1 = [mdir,slash,yearm,slash];
        cd(dir1);
    end
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
    return
end
untar(file.name)
fname = dir('*.onlns');

dirname = [dir1,'Validation',slash];
if ~exist(dirname,'dir')
    mkdir(dirname);
end
movefile('*.onlns',dirname);
%delete *.onlns
cd(dirname)

load([pdir,slash,basin,'-',level,'-buoy.mat']);
stations = buoy(:,3);

cd([rdir,'NDBC',slash,year,slash,month{str2num(mon)}]);
for zz = 1:size(stations,1)
    %cd(num2str(stations(zz,1)));
    fname=['n',num2str(stations(zz,1)),'_',year,'_',mon,'.onlns'];
    if exist(fname,'file');
        copyfile(fname,dirname);
    end
    %cd('../')q
    
end

candir = [rdir,'NDBC_Canada',slash,year,slash,month{str2num(mon)}];
if exist(candir,'dir');
  cd(candir);
for zz = 1:size(stations,1)
    %cd(num2str(stations(zz,1)));
    fname=['n',num2str(stations(zz,1)),'_',year,'_',mon,'.onlns'];
    if exist(fname,'file');
        copyfile(fname,dirname);
    end
    %cd('../')q
    
end
end
% cd([rdir,'/CANADIAN_BUOY_GOM/']);
% for zz = 1:size(stations,1)
%     if exist(num2str(stations(zz,1)),'dir')
%         cd(num2str(stations(zz,1)));
%         fname = ['n',num2str(stations(zz,1)),'_',year,'.onlns'];
%         if exist(fname,'file')
%             copyfile(fname,dirname);
%         end
%         cd ../
%     end
% end
cdipdir = [rdir,slash,'NDBC_CDIP',slash,year,slash,month{str2num(mon)}];
if exist(cdipdir,'dir')
    cd([rdir,slash,'NDBC_CDIP',slash,year,slash,month{str2num(mon)}]);
    for zz = 1:size(stations,1)
        fname=['n',num2str(stations(zz,1)),'_',year,'_',mon,'.onlns'];
        if exist(fname,'file');
            copyfile(fname,dirname);
        end
    end
else
    
    cd([rdir,slash,'CDIP',slash,'spc_',year]);
    istats = buoy(:,4) ~= 999;
    stats = buoy(istats,4);
    statsnd = buoy(istats,3);
    for zz = 1:size(stats,1)
        if stats(zz,1) < 10
            statst = ['00',num2str(stats(zz,1))];
        elseif stats(zz,1) < 100
            statst = ['0',num2str(stats(zz,1))];
        else
            statst = num2str(stats(zz,1));
        end
        if exist(statst,'dir')
            cd(statst);
            if exist(month{str2num(mon)},'dir')
                cd(month{str2num(mon)});
                cd('01')
                aa = read_cdip_sp;
                savename = [dirname,'s',num2str(statsnd(zz,1)),'_',year,'_',mon,'.mat'];
                save(savename,'aa');
                cd(['..',slash,'..',slash,'..',slash]);
            else
                cd(['..',slash]);
            end
        end
    end
end
cd(dirname);