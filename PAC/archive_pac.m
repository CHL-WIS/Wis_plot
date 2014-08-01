function archive_pac(year,mon)

if isunix
    slash = '/';
else
    slash = '\';
end
yeardmon = [year,'-',mon];
BASE = '/home/thesser1/Pacific/Model/';
BASEA = '/mnt/CHL_WIS_2/Pacific/Eval_2014/';
arcf = [BASEA,slash,'Figures',slash,yeardmon];
out = [BASE,slash,yeardmon];
arcm = [BASEA,slash,'Model',slash,yeardmon];
if ~exist(arcm,'dir')
    mkdir(arcm);
end

if ~exist(arcf,'dir')
    mkdir(arcf);
end

loc{1} = 'basin_l1';
loc{2} = 'westc_l2';
loc{3} = 'westc_l3';
loc{4} = 'cali_l4';
loc{5} = 'hawaii_l2';
loc{6} = 'hawaii_l3';

for zz = 1:length(loc)
    val = [out,slash,loc{zz},slash,'Validation',slash];
    arcv = [BASEA,slash,'Validation',slash,'WIS',slash,yeardmon, ...
        slash,loc{zz},slash];
    arcfl = [arcf,slash,loc{zz},slash];
 %   arcml = [arcm,slash,loc{zz},slash];
    if ~exist(arcv,'dir')
        mkdir(arcv);
    end
    if ~exist(arcfl,'dir')
        mkdir(arcfl);
    end
 %   if ~exist(arcml,'dir')
 %       mkdir(arcml);
 %   end
    if isunix
  % 	system(['cp ',out,slash,loc{zz},slash,'*.tgz ',arcml]);
    	system(['cp ',out,slash,loc{zz},slash,'*.png ',arcfl]);
    	system(['cp ',val,slash,'* ',arcv])
    else
	%copyfile([out,slash,loc{zz},slash,'*.tgz'],arcml);
	copyfile([out,slash,loc{zz},slash,'*.png'],arcfl);
	copyfile([val,slash,'*'],arcv);
    end	
end
