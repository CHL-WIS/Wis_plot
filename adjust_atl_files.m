function adjust_atl_files(yeard,mon,grid)
year = num2str(yeard);
if mon < 10
    monc = ['0',num2str(mon)];
else
    monc = num2str(mon);
end
yearumon = [year,'_',monc];
yeardmon = [year,'-',monc];


mdir = '/mnt/CHL_WIS_1/Atlantic/Evaluation/WAMCY451C/';
odir = [mdir,year,'/',yearumon,'/',grid,'/validation/'];

grid2 = ['level',grid(6:end)];
vdir = [mdir,'Validation/WIS/',yeardmon,'/',grid2,'/'];
if ~exist(vdir,'dir')
    mkdir(vdir);
end

fdir = dir([odir,'*.mat']);
for jj = 1:length(fdir)
    buoy = fdir(jj).name(end-8:end-4);
    fname = [vdir,'timepair-ATL-',yeardmon,'-',grid2,'-',buoy,'.mat'];
    ff = ['cp ',odir,'/',fdir(jj).name,' ',fname];
    system(ff);
end

