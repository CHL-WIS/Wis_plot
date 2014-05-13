function timeplot_WIS(buoyc,buoy,model,coord,tit1,saven,unt)

idnum = 6;
if strcmp(unt,'ft')
    buoy.wvht = buoy.wvht .* 3.281;
    buoy.wspd = buoy.wspd * 2.23694;
    model.wtlv = model.wtlv .* 3.281;
    model.wspd = model.wspd .* 2.23694;
    unit = {'ft';'s';'s';'deg';'mi/hr';'deg'};
else
    unit = {'m';'s';'s';'deg';'m/s';'deg'};
end
coord(coord(1:2)< 0) = coord(coord(1:2)<0) + 360;

f = figure('visible','off');
clf
orient tall
subplot(8,3,[2 6])
m_proj('mercator','long',[coord(1) coord(2)],'lat',[coord(3) coord(4)]);
%m_patch(shr_x,shr_y,[.0 .5 .0]);
m_gshhs_i('patch',[.0 .5 .0],'edgecolor','k');
hcst=findobj(gca,'Tag','m_gshhs_i');
set(hcst,'HandleVisibility','off');
m_grid('box','fancy','tickdir','in','fontweight','bold','fontsize',8);
hcc=get(gca,'children');
tags=get(hcc,'Tag');
k=strmatch('m_grid',tags);
hgrd=hcc(k);
hp=findobj(gca,'Tag','m_grid_color');
set(hp,'Visible','off');
set(hgrd,'HandleVisibility','off');
k2=strmatch('m_gshhs_i',tags);
h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
set(h_water,'FaceColor','none');
hold on
lon = model.lon;lat = model.lat;
lon(lon < 0) = lon(lon < 0) + 360;
%m_plot(track(:,1),track(:,2),'b-','LineWidth',1);
m_plot(lon,lat,'r.','MarkerSize',12)
hold off

pt(1) = subplot(8,3,[7 9]);
ii = buoy.wvht ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end); 
if isempty(buoy.wvht(ii))
    close(f);
    return
end
plot(buoy.time(ii),buoy.wvht(ii),'r.',model.time,model.wvht,'b', ...
    'Markersize',8,'linewidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time),idnum);
ylabel(['H_{s} (',unit{1},')'],'fontweight','bold');
set_WIS_ytick(0,max(max(buoy.wvht(ii)),max(model.wvht)));
hleg = legend('Buoy','Model');
yimit = get(gca,'ylim');
text(min(model.time),yimit(2)*3.0,tit1,'fontweight','bold');
po=get(hleg,'position');
po=[0.3 0.74 0.08 0.03];
set(hleg,'position',po);

pt(2) = subplot(8,3,[10 12]);
ii = buoy.tpp ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end) ;
plot(buoy.time(ii),buoy.tpp(ii),'r.',model.time,model.tpp,'b', ...
    'MarkerSize',8,'LineWidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time),idnum);
ylabel('T_{p} (s)','fontweight','bold');
set_WIS_ytick(0,max(max(buoy.tpp(ii)),max(model.tpp)));


pt(3) = subplot(8,3,[13 15]);
ii = buoy.tm1 ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end);
plot(buoy.time(ii),buoy.tm1(ii),'r.',model.time,model.tm1,'b', ...
    'MarkerSize',8,'LineWidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time),idnum);
ylabel('T_{m} (s)','fontweight','bold');
set_WIS_ytick(0,max(max(buoy.tm1(ii)),max(model.tm1)));


pt(4) = subplot(8,3,[16 18]);
ii = buoy.wavd ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end);
plot(buoy.time(ii),buoy.wavd(ii),'r.',model.time,model.wavd,'b', ...
    'MarkerSize',8,'LineWidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time),idnum);
set_WIS_ytick(0,360);
ylabel('\theta_{wave}','fontweight','bold');


pt(5) = subplot(8,3,[19 21]);
ii = buoy.wspd ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end);
plot(buoy.time(ii),buoy.wspd(ii),'r.',model.time,model.wspd,'b', ...
    'MarkerSize',8,'LineWidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time),idnum);
ylabel(['WS (',unit{5},')'],'fontweight','bold');
set_WIS_ytick(0,max(max(buoy.wspd(ii)),max(model.wspd)));


pt(6) = subplot(8,3,[22 24]);
ii = buoy.wdir ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end);
plot(buoy.time(ii),buoy.wdir(ii),'r.',model.time,model.wdir,'b','MarkerSize',8,'LineWidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time),idnum);
set_WIS_ytick(0,360);
xlabel(['Month/Day in Year ',datestr(model.time(1),'yyyy')], ...
    'fontweight','bold');
ylabel('\theta_{wind}','fontweight','bold');


ffout = [saven,'-',buoyc];
saveas(f,ffout,'png')
clear f
