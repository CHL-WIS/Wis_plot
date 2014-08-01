function archive_naccs(outfile,varargin)
%
p = inputParser;
p.addRequired('outfile');
p.addOptional('year','9999');
p.addOptional('mon','99');
p.addOptional('storm','blah');
parse(p,outfile,varargin{:});

year =p.Results.year;
mon = p.Results.mon;
storm = p.Results.storm;
%
if isunix
    slash = '\';
    BASE='\mnt\chlWIS_2';
else
    slash = '/';
    BASE = 'Y:\';
end
%
BASEA = [BASE,'\NACCS\'];
    if strcmp(storm,'blah')
        put_file=[BASEA,slash,'Production',year,'-',mon,slash];
        arcf = [put_file,'Figures',slash,year,'-',mon,slash];
        arcv = [put_file,'Validation',shash,'WIS',slash,year,'-',mon,slash];
    else
        put_file=[BASEA,slash,'Production',slash,storm,slash];
        arcf = [put_file,'Figures',slash,storm,slash];
        arcv = [put_file,'Validation',slash,'WIS',storm,slash];
    end
%
if ~exist(arcf,'dir')
    mkdir(arcf);
end

if ~exist(arcv,'dir')
    mkdir(arcv);
end

loc{1} = 'level1';
loc{2} = 'level2';
loc{3} = 'level3N';
loc{4} = 'level3C';

for zz = 1:length(loc)
     if strcmp(storm,'blah')
       arcf1 = [arcf,loc{zz},slash];
       arcv1 = [arcv,loc{zz},slash];
     else
       arcf1 = [arcv,loc{zz},slash];
       arcv1 = [arcv,loc{zz},slash];
     end
    if ~exist(arcv1,'dir')
        mkdir(arcv1);
    end
    if ~exist(arcfl,'dir')
        mkdir(arcfl);
    end
    if isunix
        system(['cp ',outfile,slash,loc{zz},slash,'*.png ',arcfl]);
        bb = dir([arcv1,'*.png']);
        if ~isempty(bb)
          system(['cp ',outfile,slash,'Validation',loc{zz},slash,'*.png ',arcvl]);
        end
    else
        copyfile([outfile,slash,loc{zz},slash,'*.png'],arcfl);
        bb = dir([arcv1,'*.png']);
        if ~isempty(bb)
        copyfile([outfile,slash,'Validation',loc{zz},slash,'*.png'],arcvl);
        end
    end
end
