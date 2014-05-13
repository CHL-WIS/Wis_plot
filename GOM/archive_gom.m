function archive_gom(year,mon)

if isunix
    slash = '/';
else
    slash = '\';
end
yeardmon = [year,'-',mon];
BASE = '/home/thesser1/GOM/model/';
BASEA = '/mnt/CHL_WIS_1/GOM/Production/';
arcf = [BASEA,slash,'Figures',slash,yeardmon];
out = [BASE,slash,yeardmon];
arcm = [BASEA,slash,'Model',slash,yeardmon];
if ~exist(arcm,'dir')
    mkdir(arcm);
end

if ~exist(arcf,'dir')
    mkdir(arcf);
end

loc{1} = 'LEVEL1';
loc{2} = 'LEVEL2';
loc{3} = 'LEVEL3W';
loc{4} = 'LEVEL3C1';
loc{5} = 'LEVEL3C2';
loc{6} = 'LEVEL3E';

for zz = 2:length(loc)
    val = [out,slash,loc{zz},slash,'Validation',slash];
    arcv = [BASEA,slash,'Validation',slash,'WIS',slash,yeardmon, ...
        slash,loc{zz},slash];
    arcfl = [arcf,slash,loc{zz},slash];
    arcml = [arcm,slash,loc{zz},slash];
    if ~exist(arcv,'dir')
        mkdir(arcv);
    end
    if ~exist(arcfl,'dir')
        mkdir(arcfl);
    end
    %if ~exist(arcml,'dir')
    %    mkdir(arcml);
    %end
    system(['cp ',out,slash,loc{zz},slash,'*.tgz ',arcml]);
    system(['cp ',out,slash,loc{zz},slash,'*.png ',arcfl]);
    system(['cp ',val,slash,'* ',arcv]);
end