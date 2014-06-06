function data = conc_mat_files(fdir,varargin)
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
parse(p,fdir,varargin{:});

project = p.Results.project;
storm = p.Results.storm;
level = p.Results.level;
stormid = p.Results.stormid;

if isunix
    slash = '/';
else
    slash = '\';
end

if ~strcmp(project,'')
    if ~isempty(storm)
        listp = dir([fdir,slash,storm]);
        pdir = size(listp,1);
        filep = listp;
    elseif ~isempty(stormid)
        listp = dir([fdir,slash,stormid]);
        pdir = size(listp,1);
        filep = listp;
    else
        listp = dir([fdir,slash]);
        pdir = size(listp(3:end),1);
        filep = listp(3:end);
    end
       
    if ~isempty(level)
        filed.name = level;
        idir = 1;
    else    
        listd = dir([fdir,slash,filep(1).name,slash]);
        idir = size(listd(3:end),1);
        filed = listd(3:end);
    end
elseif ~strcmp(storm,'')
    listd = dir([fdir,slash]);
    idir = size(listd(3:end),1);
    filed = listd(3:end);
    pdir = 1;
    filep = '';
elseif ~strcmp(level,'')
    idir = 1;
    filed = '';
    pdir = 1;
    filep = '';
end


for ip = 1:pdir
    if ~isempty(filep)
        fdirp = [fdir,slash,filep(ip).name];
        fpname = filep(ip).name;
        fpname = strrep(fpname,'-','_');
    else
        fdirp = fdir;
    end

    for id = 1:idir
        if ~isempty(filed)
            fdir1 = [fdirp,slash,filed(id).name];
            if ~exist('sttname','var')
                fdname = filed(id).name;
                fdname = strrep(fdname,'-','_');
            end
        else
            fdir1 = fdirp;
        end

        fd = dir([fdir1,slash,'timepair*.mat']);
        for zd = 1:length(fd)
            load([fdir1,slash,fd(zd).name]);
            if zd == 1 & id == 1 & ip == 1 | ~exist('data','var')
                data.buoy.total = AB;
                data.model.total = AM;
            else
                data.buoy.total = [data.buoy.total;AB];
                data.model.total = [data.model.total;AM];
            end
            if exist('fpname','var')
                if ~myIsField(data.buoy,fpname)
                    data.buoy.(fpname).total = AB;
                    data.model.(fpname).total = AM;
                else
                    data.buoy.(fpname).total = [data.buoy.(fpname).total; ...
                        AB];
                    data.model.(fpname).total = [data.model.(fpname).total; ...
                        AM];
                end
            elseif exist('fdname','var')
                if ~myIsField(data.buoy,fdname)
                    data.buoy.(fdname).total = AB;
                    data.model.(fdname).total = AM;
                else
                    data.buoy.(fdname).total = [data.buoy.(fdname).total; ...
                        AB];
                    data.model.(fdname).total = [data.model.(fdname).total; ...
                        AM];
                end                
            end
            %stname = ['ST',fd(zd).name(end-8:end-4)];
            %data.buoy.(stname) = AB;
            %data.model.(stname) = AM;
        end
    end
   % fprintf(1,'File size is %f\n',length(data.buoy.(sttname).total))
end
if ~exist('data','var')
    error('The data needed does not exist for analysis')
end
data.numstorms = pdir;
data.numpoints = length(data.buoy.total);
fprintf(1,'File size is %f\n',length(data.buoy.total))