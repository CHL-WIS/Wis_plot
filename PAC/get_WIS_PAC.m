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


%get_file = ['X:\Atlantic\Evaluation\WW3\Model\',outfile(end-6:end),'\'];
%get_file = ['/mnt/CHL_WIS_2/Pacific/Production/Model_Old/',year,'-',mon,'/'];
get_file = ['/mnt/CHL_WIS_2/Pacific/Eval_2014/PAC_haw3/model/',year,'-',mon,'/'];
if ~exist(outfile,'dir')
    mkdir(outfile);
end
cd(outfile);
%loc{1} = [outfile,'/grd1'];
%loc{2} = [outfile,'/grd2'];
%loc{3} = [outfile,'/grd3'];
%loc{4} = [outfile,'/grd4'];
loc{1} = ['basin_l1'];
loc{2} = ['westc_l2'];
loc{3} = ['westc_l3'];
loc{4} = ['cali_l4'];
loc{5} = ['hawaii_l2'];
loc{6} = ['hawaii_l3'];

for zz = 1:length(loc)
    floc = [outfile,'/',loc{zz}]
    if ~exist(floc,'dir')
        mkdir(floc);
    end
    cd (floc)
%    ii = strfind(loc{zz},'grd');
%    levn = loc{zz}(ii+3:end);
    %copyfile([get_file,loc{zz},'/*', ...
    %    loc{zz},'-MMt.tgz'],'.');
    %fnamest = [get_file,loc{zz},'/*', ...
    %        loc{zz},'-ST-onlns.tgz'];
    %blah = dir(fnamest);
    %if ~isempty(blah)
    %    copyfile(fnamest,'.');
    %end
    wis_read('PAC','/',0,'year',year,'mon',mon)
    
end
%archive_pac(year,mon);
%system(['rm -rf ',outfile]);
end
