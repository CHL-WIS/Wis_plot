function [buoy,flag] = timeseries_read(date,rdir,station)
%
if isunix
    slash = '/';
else
    slash = '\';
end
month = {'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct'; ...
    'nov';'dec'};
%  year and mon are characters

% 
% if ~ischar(year)
%     year = num2str(year);
% end
% if ~ischar(mon)
%     if mon < 10
%         mon = ['0',num2str(mon)];
%     else
%         mon = num2str(mon);
%     end
% end
% yearm = [year,'-',mon];


%load([pdir,slash,basin,'-',level,'-buoy.mat']);
%stations = buoy(:,3);
jr = 0;
years = [date(1), date(4)];
for ii = 1:2
    year = num2str(years(ii));
    mon = [date(2) date(5)];
    %for imon = 1:length(mon)
    imon = ii;
        if mon(imon) < 10
            monc = ['0',num2str(mon(imon))];
        else
            monc = num2str(mon(imon));
        end

        try
            cdir = [rdir,'NDBC',slash,year,slash,month{mon(imon)},slash];
        catch
            1
        end
%for zz = 1:size(stations,1)
    %cd(num2str(stations(zz,1)));
        fname=[cdir,'n',station,'_',year,'_',monc,'.onlns'];
        if exist(fname,'file');
            jr = jr + 1;
            if jr == 1
                buoy = read_NDBC_onlns(fname);
            else
                bb(jr-1) = read_NDBC_onlns(fname);
            end
        end
    %cd('../')q

candir = [rdir,'NDBC_CANADA',slash,year,slash,month{mon(imon)},slash];
% if exist(candir,'dir');
%   cd(candir);
%for zz = 1:size(stations,1)
    %cd(num2str(stations(zz,1)));
    fname=[candir,'n',station,'_',year,'_',monc,'.onlns'];
    if exist(fname,'file');
        jr = jr + 1;
        if jr == 1
            buoy = read_NDBC_onlns(fname);
        else
            bb(jr-1) = read_NDBC_onlns(fname);
        end
    end
    %cd('../')q
    
%end
% end
cdipdir = [rdir,slash,'NDBC_CDIP',slash,year,slash,month{mon(imon)},slash];
%if exist(cdipdir,'dir')
    %cd([rdir,slash,'NDBC_CDIP',slash,year,slash,month{str2num(mon)}]);
    %for zz = 1:size(stations,1)
    fname=[cdipdir,'n',station,'_',year,'_',monc,'.onlns'];
        if exist(fname,'file');
            jr = jr + 1;
            if jr == 1 
                buoy = read_NDBC_onlns(fname);
            else
                bb(jr-1) = read_NDBC_onlns(fname);
            end
        end
    
    %end
end

if jr == 0
    buoy = 0;
    flag = 0;
    return
else
    flag = 1;
end
if jr == 1
    return
end

for jj = 1:length(bb)
    buoy.time = [buoy.time;bb(jj).time];
    buoy.wvht = [buoy.wvht;bb(jj).wvht];
    buoy.tpp = [buoy.tpp;bb(jj).tpp];
    buoy.tm1 = [buoy.tm1;bb(jj).tm1];
    buoy.wavd = [buoy.wavd;bb(jj).wavd];
    buoy.wspd = [buoy.wspd;bb(jj).wspd];
    buoy.wdir = [buoy.wdir;bb(jj).wdir];
end