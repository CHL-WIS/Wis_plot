function set_WIS_xtick(minf,maxf,idnum)

xlimmx = [minf,maxf];
xtickdiff = maxf - minf;
xticks = [minf:ceil(xtickdiff/12):maxf];
xticklab = datestr(xticks,idnum);
set(gca,'xtick',xticks,'xticklabel',xticklab,'xlim', ...
    [minf maxf]);
