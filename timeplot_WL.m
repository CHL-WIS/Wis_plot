function timeplot_WL(buoyc,buoy,model,coord,track,tit1,ffout,unt)

if strcmp(unt,'ft')
    buoy.wtlv = buoy.wtlv .* 3.281;
    buoy.wspd = buoy.wspd * 2.23694;
    model.wtlv = model.wtlv .* 3.281;
    model.wspd = model.wspd .* 2.23694;
    unit = {'ft';'mi/hr';'deg';'Pa'};
else
    unit = {'m';'m/s';'deg';'Pa'};
end
figure(1)
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
model.lon(model.lon < 0) = model.lon(model.lon < 0) + 360;
m_plot(track(:,1),track(:,2),'b-','LineWidth',1);
m_plot(model.lon,model.lat,'r.','MarkerSize',12)
hold off

pt(1) = subplot(8,3,[7 9]);
ii = buoy.wtlv ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end);
jj = model.wtlv > -100;
plot(buoy.time(ii),buoy.wtlv(ii),'r.',model.time(jj),model.wtlv(jj),'b-', ...
    'Markersize',8,'linewidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time));
ylabel(['WL (',unit{1},')'],'fontweight','bold');
if isempty(buoy.time(ii))
    text(model.time(1),0,'No Buoy Data','color','r','HorizontalAlignment','left',...
        'VerticalAlignment','bottom');
    set_WIS_ytick(min(model.wtlv(jj)),max(model.wtlv(jj)));
    hleg = legend('Model');
elseif isempty(model.time(jj))
    set_WIS_ytick(min(buoy.wtlv(ii)),max(buoy.wtlv(ii)));
    text(model.time(1),0,'No Model Data','color','b','HorizontalAlignment','left',...
        'VerticalAlignment','bottom');
    hleg = legend('Buoy');
else
    set_WIS_ytick(min(min(buoy.wtlv(ii)),min(model.wtlv(jj))), ...
        max(max(buoy.wtlv(ii)),max(model.wtlv(jj))));
    hleg = legend('Buoy','Model');
end
% yimit = get(gca,'ylim');
% text(min(model.time),yimit(2)*3.5,tit1,'fontweight','bold');
titp = title(tit1,'fontweight','bold');
pt = get(titp,'position');
pt = [pt(1)-2.1 pt(2)*2.2 pt(3)];
set(titp,'position',pt);
po=get(hleg,'position');
po=[0.3 0.74 0.08 0.03];
set(hleg,'position',po);

pt(2) = subplot(8,3,[10 12]);
ii = buoy.wspd ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end);
jj = model.wspd > -100;
plot(buoy.time(ii),buoy.wspd(ii),'r.',model.time(jj),model.wspd(jj),'b-', ...
    'MarkerSize',8,'LineWidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time));
ylabel(['WS (',unit{2},')'],'fontweight','bold');
if isempty(buoy.time(ii))
    text(model.time(1),0,'No Buoy Data','color','r','HorizontalAlignment','left',...
        'VerticalAlignment','bottom');
    set_WIS_ytick(0,max(model.wspd(jj)));
elseif isempty(model.time(jj))
    text(model.time(1),0,'No Model Data','color','b','HorizontalAlignment','left',...
        'VerticalAlignment','bottom');
    set_WIS_ytick(0,max(buoy.wspd(ii)));
else
    set_WIS_ytick(0,max(max(buoy.wspd(ii)),max(model.wspd(jj))));
end

pt(3) = subplot(8,3,[13 15]);
ii = buoy.wdir ~= -999 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end);
jj = model.wdir >= 0;
plot(buoy.time(ii),buoy.wdir(ii),'r.',model.time(jj),model.wdir(jj),'b-', ...
    'MarkerSize',8,'LineWidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time));
set_WIS_ytick(0,360);

ylabel('\theta_{wind}','fontweight','bold');
if isempty(buoy.time(ii))
    text(model.time(1),0,'No Buoy Data','color','r','HorizontalAlignment','left',...
        'VerticalAlignment','bottom');
elseif isempty(model.time(jj))
    text(model.time(1),0,'No Model Data','color','b','HorizontalAlignment','left',...
        'VerticalAlignment','bottom');
end

pt(4) = subplot(8,3,[16 18]);
ii = buoy.pres > 500 & buoy.time >= model.time(1) & ...
    buoy.time <= model.time(end);
jj = model.pres > 0;
plot(buoy.time(ii),buoy.pres(ii),'r.',model.time(jj),model.pres(jj),'b-', ...
    'MarkerSize',8,'LineWidth',1);
grid;
set_WIS_xtick(min(model.time),max(model.time));
ylabel(['Pres (',unit{4},')'],'fontweight','bold');
if isempty(buoy.time(ii))
    text(model.time(1),0,'No Buoy Data','color','r','HorizontalAlignment','left',...
        'VerticalAlignment','bottom');
    set_WIS_ytick(min(model.pres),max(model.pres));
elseif isempty(model.time(jj))
    text(model.time(1),max(buoy.pres(ii)),'No Model Data','color','b','HorizontalAlignment','left',...
        'VerticalAlignment','bottom');
    set_WIS_ytick(min(buoy.pres(ii)),max(buoy.pres(ii)));
else
    set_WIS_ytick(min(min(buoy.pres(ii)),min(model.pres(jj))), ...
        max(max(buoy.pres(ii)),max(model.pres(jj))));
end
xlabel(['Month/Day in Year ',datestr(model.time(1),'yyyy')], ...
    'fontweight','bold');



print(gcf,'-dpng','-r400',ffout)
close all