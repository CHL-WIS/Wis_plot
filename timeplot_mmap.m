function timeplot_mmap(coord,ifill)

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

m_proj('mercator','long',[coord(1) coord(2)],'lat',[coord(3) coord(4)]);
if ifill == 1
    shr_x(shr_x > 180) = shr_x(shr_x > 180) - 360;
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
if ifill == 0
    k2=strmatch('m_gshhs_i',tags);
    h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
    set(h_water,'FaceColor','none');
end
hold on