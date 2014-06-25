function wis_fullfile_2_month(fdir,stat)

aa = load([fdir,'/ST',num2str(stat),'.onlns']);

time = fix(aa(:,1)./10^8);
jj = 0;
for jyear = 1979:2009
     jj = jj + 1;
    for imon = 1:12
        tcomp = jyear*100 + imon;
        ii = time == tcomp;
        if isempty(aa(ii,:))
            continue
        end
        if imon < 10
            mon = ['0',num2str(imon)];
        else
            mon = num2str(imon);
        end
        fdd = [fdir,'/',num2str(jyear),'-',mon];
        if ~exist(fdd,'dir')
            mkdir(fdd);
        end
        fname = [fdd,'/ST',num2str(stat),'.onlns'];
        write_WIS_onlns(fname,aa(ii,:));
        clear ii
    end
end