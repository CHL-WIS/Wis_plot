function get_WIS_NACCS(outfile,varargin)

p = inputParser;
p.addRequired('outfile');
p.addOptional('year','9999');
p.addOptional('mon','99');
p.addOptional('storm','blah');
parse(p,outfile,varargin{:});

year =p.Results.year;
mon = p.Results.mon;
storm = p.Results.storm;

if isunix
    get_file = ['/mnt/CHL_WIS_1/NACCS/Production/Model/',year,'-',mon,'/'];
    slash = '/';
else
    get_file = ['Z:\NACCS\Production\Model\',year,'-',mon,'\'];
    slash = '\';
end
if ~exist(outfile,'dir')
    mkdir(outfile);
end
cd(outfile);
loc{1} = [outfile,'/level1'];
loc{2} = [outfile,'/level2'];
loc{3} = [outfile,'/level3N'];
loc{4} = [outfile,'/level3C'];
loc{5} = [outfile,'/level3S1'];
loc{6} = [outfile,'/level3S2'];

  for zz = 1:length(loc)
    if ~exist(loc{zz},'dir')
        mkdir(loc{zz});
    end
    cd (loc{zz})
    ii = strfind(loc{zz},'level');
    levn = loc{zz}(ii+5:end);
    copyfile([get_file,'level',levn,'/*MMd.tgz'],'.');
    fnamest = [get_file,'level',levn,'/*onlns.tgz'];
    blah = dir(fnamest);
    if ~isempty(blah)
        copyfile(fnamest,'.');
    end
    wis_read('NACCS',slash,0,'year',year,'mon',mon)
    
end
%archive_atl(year,mon);
%system(['rm -rf ',outfile]);
end