function [tit,outdir] = PAC_longterm_names(year1,year2,model,grd) 

gridc = '';
tit1 = ['Pacific Basin Longterm Analysis'];
tit2 = ['Model = ',model];
tit3 = ['Grid = PAC'];%,gridc];
tit4 = ['Time = ',year1,' - ',year2];
tit = {tit1;tit2;tit3;tit4};

outdir = ['/mnt/CHL_WIS_1/Pacific/Production/Longterm/'];
if ~exist(outdir,'dir');
    mkdir(outdir);
end
%lev = gridc(6:end);

