function archive_HUR(year,mon)

if isunix
    slash = '/';
else
    slash = '\';
end
yeardmon = [year,'-',mon];
BASE = 'G:\DATA\WIS-LAKE-HURON\Production\outdat';
BASEA = 'Z:\LAKE_HURON\Production\WAM451C';
arcf = [BASEA,slash,'Figures',slash,yeardmon];
out = [BASE,slash,yeardmon,'\LEVEL1'];
arcm = [BASEA,slash,'Model',slash,yeardmon];
if ~exist(arcm,'dir')
    mkdir(arcm);
end

if ~exist(arcf,'dir')
    mkdir(arcf);
end

%for zz = 1:length(loc)
val = [out,slash,'Validation',slash];
arcv = [BASEA,slash,'Validation',slash,'WIS',slash,yeardmon, ...
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
% 	system(['cp ',out,slash,'*.tgz ',arcml]);
    system(['cp ',out,slash,'*.png ',arcfl]);
   	system(['cp ',val,slash,'* ',arcv]);
else
%   copyfile([out,slash,'*.tgz'],arcml)
	copyfile([out,slash,'*.png'],arcfl);
    bb = dir([val,slash,'*.png']);
    if ~isempty(bb)
       copyfile([val,slash,'*'],arcv);
    end
end	
%end
