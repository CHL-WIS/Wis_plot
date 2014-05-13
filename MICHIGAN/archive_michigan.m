function archive_michigan(varargin)

p = inputParser;
p.addOptional('year','9999');
p.addOptional('mon','99');
p.addOptional('storm','blah');
parse(p,varargin{:});

year =p.Results.year;
mon = p.Results.mon;
storm = p.Results.storm;

if strcmp(year,'9999') & strcmp(storm,'blah')
    fprintf(1,'Need to identify either year-mon or storm\n')
    return
end

if isunix
    slash = '/';
else
    slash = '\';
end

if ~strcmp(storm,'blah')
    id = storm;
else
    yeardmon = [year,'-',mon];
    id = yeardmon;
end
BASE = '/home/thesser1/MICHIGAN/';
BASEA = '/mnt/CHL_WIS_1/LAKE_MICHIGAN/Production/';
arcf = [BASEA,slash,'Figures',slash,id];
out = [BASE,slash,id];
arcm = [BASEA,slash,'Model',slash,id];
if ~exist(arcm,'dir')
    mkdir(arcm);
end

if ~exist(arcf,'dir')
    mkdir(arcf);
end

%for zz = 1:length(loc)
val = [out,slash,'Validation',slash];
arcv = [BASEA,slash,'Validation',slash,'WIS',slash,id, ...
        slash];
arcfl = [arcf,slash];
arcml = [arcm,slash];
if ~exist(arcv,'dir')
    mkdir(arcv);
end
if ~exist(arcfl,'dir')
    mkdir(arcfl);
end
if ~exist(arcml,'dir')
    mkdir(arcml);
end
if isunix
	%system(['cp ',out,slash,'*.tgz ',arcml]);
    system(['cp ',out,slash,'*.png ',arcfl]);
   	system(['cp ',val,slash,'* ',arcv]);
else
    %copyfile([out,slash,'*.tgz'],arcml);
	copyfile([out,slash,'*.png'],arcfl);
	copyfile([val,slash,'*'],arcv);
end	
%end
