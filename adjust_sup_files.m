function adjust_sup_files(yeard,mon,grid)
year = num2str(yeard);
if mon < 10
    monc = ['0',num2str(mon)];
else
    monc = num2str(mon);
end
yearumon = [year,'_',monc];
yeardmon = [year,'-',monc];


mdir = '/mnt/CHL_WIS_1/LakeSuperior/Production/WAM451C/';
%odir = [mdir,year,'/',yearumon,'/',grid,'/validation/WIS/',yeardmon];

vdir = [mdir,'Validation/WIS/',yeardmon,'/'];
% if ~exist(vdir,'dir')
%     mkdir(vdir);
% end

fdir = dir([vdir,'*.mat']);
for jj = 1:size(fdir,1)
    buoy = fdir(jj).name(end-8:end-4);
    fname = [vdir,'timepair-LKSUPERIOR-',yeardmon,'-',buoy,'.mat'];
    ff = ['cp ',vdir,'/',fdir(jj).name,' ',fname];
    system(ff);
end

