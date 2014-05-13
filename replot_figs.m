function replot_figs(fdir,plotmat)

load(plotmat);
cd(fdir);
fname = dir('*.fig');
for jfig = 1:size(fname,1)
    f = open(fname(jfig).name);    
    fn = fname(jfig).name(1:end-4);
    set(f,'units','inches');
    set(f,'Position',figpos);
    set(f,'papersize',figpos(3:4));
    set(f,'PaperPosition',figpos);
    set(f,'PaperPositionMode','manual');
    print(f,'-dpng','-r0','-painters',fn);
end