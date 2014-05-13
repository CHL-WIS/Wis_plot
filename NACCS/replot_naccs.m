function replot_sandy(year,mon)

if ~ischar(year)
    year = num2str(year);
end
if ~ischar(mon)
    if mon < 10
        mon = ['0',num2str(mon)];
    else
        mon = num2str(mon);
    end
end
fprintf(1,'Retreiving *.fig from raid for %s-%s\n',year,mon)
reverse_arc_atl(year,mon)

fprintf(1,'Replotting\n')
lev = {'1';'2';'3N';'3C';'3S1';'3S2'};
for ilev = 1:size(lev,1)
    mdir = ['C:\Users\rdchlrej\Documents\MATLAB\matlab_2011\Wis_plot\SANDY\', ...
        lev{ilev},'.mat'];
    fdir = ['G:\DATA\SANDY\Production\outdat\',year,'-',mon,'/level',lev{ilev},'/'];
    
    replot_figs(fdir,mdir);
    vdir = [fdir,'Validation'];
    replot_vals(vdir);
end
fprintf(1,'Archiving\n');
archive_atl(year,mon)