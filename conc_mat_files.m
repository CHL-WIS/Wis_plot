function data = conc_mat_files(fdir,varargin)

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
    if ~isempty(stormid)
        listp = dir([fdir,slash,stormid,'*']);
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
    %fdir2 = fdir;
    if ~isempty(filep)
        fdirp = [fdir,slash,filep(ip).name];
    else
        fdirp = fdir;
    end
    
    for id = 1:idir
        if ~isempty(filed)
            fdir1 = [fdirp,slash,filed(id).name];
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
            %stname = ['ST',fd(zd).name(end-8:end-4)];
            %data.buoy.(stname) = AB;
            %data.model.(stname) = AM;
        end
    end
end
if ~exist('data','var')
    error('The data needed does not exist for analysis')
end
data.numstorms = pdir;
data.numpoints = length(data.buoy.total);
fprintf(1,'File size is %f\n',length(data.buoy.total))