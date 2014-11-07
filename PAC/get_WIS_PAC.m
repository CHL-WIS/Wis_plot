function get_WIS_PAC(outfile,varargin)

p = inputParser;
p.addRequired('outfile');
p.addOptional('year','9999');
p.addOptional('mon','99');
p.addOptional('storm','blah');
parse(p,outfile,varargin{:});

year =p.Results.year;
mon = p.Results.mon;
storm = p.Results.storm;


post_file = ['Pacific/Production_2014/Model/',year,'-',mon,'/'];

if ispc
    get_file = ['Y:\',post_file];
    get_file = strrep(get_file,'/','\');
    slash = '\';
else
    get_file = ['/mnt/CHL_WIS_2/',post_file];
    slash = '/';
end

if ~exist(outfile,'dir')
    mkdir(outfile);
end
cd(outfile);
loc{1} = ['basin_l1'];
loc{2} = ['westc_l2'];
loc{3} = ['westc_l3'];
loc{4} = ['cali_l4'];
loc{5} = ['hawaii_l2'];
loc{6} = ['hawaii_l3'];

for zz = 2:length(loc)
    floc = [outfile,'/',loc{zz}];
    if ~exist(floc,'dir')
        mkdir(floc);
    end
    cd (floc)
    fprintf(1,'Moving files for level: %s\n',loc{zz})
    copyfile([get_file,loc{zz},slash,'*MMf.tgz'],'.');
    copyfile([get_file,loc{zz},slash,'*buoy_points.tgz'],'.');
    wis_read('PAC',slash,0,'year',year,'mon',mon)

end
archive_pac(year,mon);
for zz = 1:length(loc)
    move_2_thredds(year,mon,'Pacific',[get_file,loc{jj}])
end
%system(['rm -rf ',outfile]);
end
