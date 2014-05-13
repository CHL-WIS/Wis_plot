function get_WIS_GOM(outfile)

if isunix
    get_file = ['/mnt/CHL_WIS_1/GOM/Production/Model/',outfile(end-6:end),'/'];
    slash = '/';
else
    get_file = ['X:\GOM\Production\Model\',outfile(end-6:end),'\'];
    slash = '\';
end

if ~exist(outfile,'dir')
    mkdir(outfile);
end
cd(outfile);
locd{1} = 'L02';
locd{2} = 'L3W';
locd{3} = 'L3C1';
locd{4} = 'L3C2';
locd{5} = 'L3E';
loc{1} = [outfile,slash,'LEVEL1'];
loc{2} = [outfile,slash,'LEVEL2'];
loc{3} = [outfile,slash,'LEVEL3W'];
loc{4} = [outfile,slash,'LEVEL3C1'];
loc{5} = [outfile,slash,'LEVEL3C2'];
loc{6} = [outfile,slash,'LEVEL3E'];

year = outfile(end-6:end-3);
mon = outfile(end-1:end);

for zz = 1:length(locd)
     id = 0;
     if ~exist(loc{zz+1},'dir')
         mkdir(loc{zz+1});
         id = 1;
     end
    cd (loc{zz+1})
    ii = strfind(loc{zz+1},'LEVEL');
    %ii2 = strfind(locd{zz},'L');
    %copyfile([get_file,'LEVEL',loc{zz}(ii+5:end),'/*-LEVEL', ...
    %    loc{zz}(ii+5:end),'-MMt.tgz'],'.');
    if id == 1
        copyfile([get_file,slash,'LEVEL',loc{zz+1}(ii+5:end),slash,...
            '*L',locd{zz}(2:end),'*MMd.tgz'],'.');
    %fnamest = [get_file,'LEVEL',loc{zz}(ii+5:end),'/*-LEVEL', ...
    %        loc{zz}(ii+5:end),'-ST-onlns.tgz'];
        fnamest = [get_file,slash,'LEVEL',loc{zz+1}(ii+5:end),slash, ...
            '*L',locd{zz}(2:end),'*onlns.tgz'];
        blah = dir(fnamest);
        if ~isempty(blah)
            copyfile(fnamest,'.');
        end
    end
    wis_read('GOM',year,mon,slash)
    
end
%archive_gom(year,mon);
%system(['rm -rf ',outfile]);
end
