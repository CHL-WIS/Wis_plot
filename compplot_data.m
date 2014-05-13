function compplot_WIS(id,stations,data,coord,tit1,track,saven,fillm)

%coord(1:2) = coord(1:2) - 360;

shr_x(1,1) = coord(1);
shr_x(2,1) = coord(2);
shr_x(3,1) = coord(2);
shr_x(4,1) = coord(1);
shr_x(5,1) = coord(1);

shr_y(1,1) = coord(3);
shr_y(2,1) = coord(3);
shr_y(3,1) = coord(4);
shr_y(4,1) = coord(4);
shr_y(5,1) = coord(4);

idnum = 6;

f = figure('visible','off');
%clf
orient tall
subplot(8,3,[2 6])
m_proj('mercator','long',[coord(1) coord(2)],'lat',[coord(3) coord(4)]);
if fillm == 1
    shr_x = shr_x - 360;
    m_patch(shr_x,shr_y,[.0 .5 .0]);
end
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
for jj = 1:length(data)
    lon = data(jj).mlon;lat = data(jj).mlat;
    lon(lon < 0) = lon(lon < 0) + 360;
%m_plot(track(:,1),track(:,2),'b-','LineWidth',1);
    m_text(lon,lat,num2str(stations(jj)),'VerticalAlignment','Bottom', ...
        'backgroundcolor',[1 1 1],'fontsize',8,'HorizontalAlignment','left')
    m_plot(lon,lat,'r.','MarkerSize',12)
end
hold off

for jj = 1:length(data)
    maxhs(jj) = max(max(data(jj).bwvht),max(data(jj).mwvht));
end
hsmaxt = max(maxhs);
nn = 0;
for jj = 1:length(data)
    ii = data(jj).bwvht >= 0 & data(jj).btime >= data(jj).time(1) & ...
        data(jj).btime <= data(jj).time(end);
    if isempty(data(jj).bwvht(ii))
        %close(f);
        continue
    else
        nn = nn + 1;
        pp = jj; 
    end
        textdt = ['Buoy: ',num2str(stations(jj)),' at [', ...
        num2str(data(jj).mlon),', ',num2str(data(jj).mlat),']'];
    if nn == 1;
        textd = {textdt};
    else
        textd = vertcat(textd,textdt);
    end
    pt(nn) = subplot(8,3,3*nn+4:3*nn+6);
    plot(data(jj).btime(ii),data(jj).bwvht(ii),'r.',data(jj).time, ...
        data(jj).mwvht,'b','Markersize',8,'linewidth',1);
    grid;
    set_WIS_xtick(min(data(jj).time),max(data(jj).time),idnum);
    ylabel(['H_{s} (m)'],'fontweight','bold');
    set_WIS_ytick(0,hsmaxt);
    if nn == 1
        hleg = legend('Buoy','Model');
        yimit = get(gca,'ylim');
        %tit = vertcat(tit1);
        text(min(data(jj).time),yimit(2)*4.5,tit1,'fontweight','bold','VerticalAlignment','top');
        %text(min(data(jj).time),yimit(2)*3.5,textd,'fontweight','bold','VerticalAlignment','top')
        po=get(hleg,'position');
        po=[0.3 0.74 0.08 0.03];
        set(hleg,'position',po);
    end
    text(max(data(jj).time)-3.0,yimit(2),num2str(stations(jj)), ...
        'verticalalignment','top')
end
if nn == 0
    clear f;
    return
end
xlabel(['Month/Day in Year ',datestr(data(jj).time(1),'yyyy')], ...
    'fontweight','bold');
subplot(8,3,3*1+4:3*1+6);
text(min(data(1).time),yimit(2)*3.5,textd,'fontweight','bold','VerticalAlignment','top')


set(f,'units','inches');
set(f,'papersize',[9 11]);
set(f,'position',[0 0 9 11]);
set(f,'paperposition',[0 0 9 11]);
ffout = [saven,'-comp',num2str(id)];
saveas(f,ffout,'png')
clear f
