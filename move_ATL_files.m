loc{1} = 'LEVEL1';
loc{2} = 'LEVEL2';
loc{3} = 'LEVEL3N';
loc{4} = 'LEVEL3C';
loc{5} = 'LEVEL3S1';
loc{6} = 'LEVEL3S2';

cdir = '/mnt/CHL_WIS_1/Atlantic/Evaluation/WW3/Model/';
cd(cdir);
for yr = 2006:2009
    for mn = 1:12
        if mn < 10
            mon = ['0',num2str(mn)];
        else
            mon = num2str(mn);
        end
        yrmon = [num2str(yr),'-',mon];
        if exist(yrmon,'dir')
        cd([num2str(yr),'-',mon])
        
        for jj = 1:size(loc,1)
            if ~exist(loc{jj},'dir')
                mkdir(loc{jj});
            end

            nn = ['mv *-',loc{jj},'*.tgz ',loc{jj}];
            system(nn);
        end
        cd ../
        end
    end
end
