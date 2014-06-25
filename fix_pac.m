for iyear = 1980:2012
    for imon = 1:12
        if imon < 10
            monc = ['0',num2str(imon)];
        else
            monc = num2str(imon);
        end

        yearmon = [num2str(iyear),'-',monc];
        pac_grd1_fix(yearmon);

        pac_grd3_fix(yearmon);

        pac_grd4_fix(yearmon);

        dirnew = '/home/thesser1/Pacific/Model/';
        dirpl = '/mnt/CHL_WIS_2/Pacific/Production/Model/';

        diryrmon = [dirnew,yearmon];

        system(['cp -rf ',diryrmon,' ',dirpl,yearmon]);
	system(['rm -rf ',diryrmon]);
    end
end
exit
