function replot_vals(fdir)

cd(fdir);
fname = dir('*.fig');
for jfig = 1:size(fname,1)
    f = open(fname(jfig).name);    
    fn = fname(jfig).name(1:end-4);
    set(f,'units','inches');
    set(f,'papersize',[9 11]);
    set(f,'position',[0 0 9 11]);
    set(f,'paperposition',[0 0 9 11]);
    saveas(f,fn,'png')
end