function set_WIS_ytick(minf,maxf)

if maxf == 360
    ylimmx = [0,maxf];
else
    ylimmx=[floor(minf),ceil(maxf)+1];
end
if ylimmx(2) <= 2
    ytd1 = ylimmx(2)/4;
    ytickm = [ytd1 2*ytd1 3*ytd1 4*ytd1];
else
    ytd1 = ceil((ylimmx(2) - ylimmx(1))/4);
    ytickm = [ylimmx(1)+ytd1 ylimmx(1)+2*ytd1 ylimmx(1)+3*ytd1 ylimmx(1)+4*ytd1];
end
set(gca,'YTick',ytickm);
set(gca,'Ylim',ylimmx);