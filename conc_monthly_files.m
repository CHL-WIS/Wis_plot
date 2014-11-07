function data = conc_monthly_files(fdir,varargin)
%
%     data = conc_mat_files
%        created by TJ Hesser  05/16/14
%
%     gathers WIS data sets by project or storm for analysis 
%
%  INPUTS:
%     fdir        STRING     : directory where data is stored
%                                could be project directory down to level
%                                directory
%     project     OPT STR    : name of project directory (ie. NACCS)
%     storm       OPT STR    : name of storm or year-mon (ie. ST0001 or
%                                1983-01)
%     level       OPT STR    : name of level (ie. level1)
%     stormid     OPT STR    : Flag for identifying specific storms while 
%                                searching directory (ie. TP* for Tropical
%
%  OUTPUTS:
%     data        STRUCT  
%       buoy      STRUCT     : buoy data
%         total   array      : array of buoy data for total inquiry
%         var     array      : arrays for each strom in project
%
%       model     STRUCT     : model data
%         total   arrray     : array of model data for total inquiry
%         var     array      : array of model data for project specific
%                                 output
%
% -------------------------------------------------------------------------
p = inputParser;
p.addRequired('fdir');
p.addOptional('project','');
p.addOptional('storm','');
p.addOptional('level','');
p.addOptional('stormid','');
p.addOptional('year1',0000);
p.addOptional('year2',0000);
p.addOptional('excep','');
parse(p,fdir,varargin{:});

project = p.Results.project;
storm = p.Results.storm;
level = p.Results.level;
stormid = p.Results.stormid;
year1 = p.Results.year1;
year2 = p.Results.year2;
excep = p.Results.excep;

if isunix
    slash = '/';
else
    slash = '\';
end

month = {'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'};
wdir = [fdir,slash,'Validation',slash,'WIS'];
if year1 == 0 & year2 == 0
    yrf = dir([wdir,slash,'*-*']);
    yrs = yrf(1).name(1:4);
    yre = yrf(end).name(1:4);
elseif year1 == 0 & year2 ~= 0
    yrf = dir([wdir,slash,'*-*']);
    yrs = yrf(1).name(1:4);
    yre = num2str(year2);
elseif year1 ~= 0 & year2 == 0
    yrf = dir([wdir,slash,'*-*']);
    yrs = num2str(year1);
    yre = yrf(end).name(1:4);
else
    yrs = num2str(year1);
    yre = num2str(year2);
end
year = str2num(yrs):1:str2num(yre);

for imon = 1:12
    if imon < 10
        monc = ['0',num2str(imon)];
    else
        monc = num2str(imon);
    end
    for iyear = 1:length(year)
        fd1 = [wdir,slash,num2str(year(iyear)),'-',monc,slash,level];
        fd = dir([fd1,slash,'timepair*.mat']);
        for zd = 1:length(fd)
           % if ~strcmp(excep,'')
                buoy = str2num(fd(zd).name(end-8:end-4));
                if buoy > 44100
                    continue
                end
                if strcmp(level,'level2') & ismember(buoy,[44007,44056])
                    continue
                end
                if strcmp(level,'level3C') & ismember(buoy,[44056,44009]);
                    continue
                end
           % end
            load([fd1,slash,fd(zd).name]);
            if iyear==1 & imon == 1 & zd == 1| ~exist('data','var')
                data.buoy.total = AB;
                data.model.total = AM;
                data.bname(1) = buoy;
                nn = 1;
            else
                data.buoy.total = [data.buoy.total;AB];
                data.model.total = [data.model.total;AM];
                if ~ismember(buoy,data.bname)
                    nn = nn + 1;
                    data.bname(nn) = buoy;
                end
            end
            mmname = month{imon};
            if exist('mmname','var')
                if ~myIsField(data.buoy,mmname)
                    data.buoy.(mmname).total = AB;
                    data.model.(mmname).total = AM;
                else
                    data.buoy.(mmname).total = [data.buoy.(mmname).total; ...
                        AB];
                    data.model.(mmname).total = [data.model.(mmname).total; ...
                        AM];
                end                      
            end
        end
    end
end
if ~exist('data','var')
    error('The data needed does not exist for analysis')
end
data.numstorms = 12;
data.numpoints = length(data.buoy.total);
fprintf(1,'File size is %f\n',length(data.buoy.total))