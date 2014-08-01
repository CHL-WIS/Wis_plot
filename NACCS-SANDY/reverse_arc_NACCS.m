function reverse_arc_atl(year,mon)

if isunix
    slash = '/';
else
    slash = '\';
end
yeardmon = [year,'-',mon];
BASE = '/home/thesser1/ATL/model/';
BASEA = '/mnt/CHL_WIS_1/ATL/Production/';
arcf = [BASEA,slash,'Figures',slash,yeardmon];
out = [BASE,slash,yeardmon];
arcm = [BASEA,slash,'Model',slash,yeardmon];

loc{1} = 'level1';
loc{2} = 'level2';
loc{3} = 'level3N';
loc{4} = 'level3C';
loc{5} = 'level3S1';
loc{6} = 'level3S2';

for zz = 1:length(loc)
    fprintf(1,'Retrieving data for %s\n',loc{zz})
    val = [out,slash,loc{zz},slash,'Validation',slash];
    arcv = [BASEA,slash,'Validation',slash,'WIS',slash,yeardmon, ...
        slash,loc{zz},slash];
    arcfl = [arcf,slash,loc{zz},slash];
    arcml = [arcm,slash,loc{zz},slash];
   
    outhf = [out,slash,loc{zz},slash];
    if ~exist(outhf,'dir')
        mkdir(outhf);
    end
    outhv = [out,slash,loc{zz},slash,'Validation',slash];
    if ~exist(outhv,'dir')
        mkdir(outhv);
    end
    
    if isunix
        %system(['cp ',out,slash,loc{zz},slash,'*.tgz ',arcml]);
    	%system(['cp ',out,slash,loc{zz},slash,'*.png ',arcfl]);
    	%system(['cp ',val,slash,'* ',arcv])
        system(['cp ',arcfl,'*.fig ',outhf])
        system(['cp ',arcv,'*.fig ',outhv]);
    else
	copyfile([out,slash,loc{zz},slash,'*.tgz'],arcml);
	copyfile([out,slash,loc{zz},slash,'*.png'],arcfl);
	copyfile([val,slash,'*'],arcv);
    end	
end
