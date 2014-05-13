%make pac grid figure

 figure
m_proj('mercator','long',[110 300],'lat',[-64 64])
m_gshhs_i('patch',[0 0.5 0])
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
level2x = [220.0 220.0 250.0 250.0 220.0];
level2y = [30.0 50.0 50.0 30.0 30.0];
m_plot(level2x,level2y,'r-','linewidth',2)

level3x = [230.0 230.0 245.0 245.0 230.0];
level3y = [30.0 50.0 50.0 30.0 30.0];
m_plot(level3x,level3y,'b-','linewidth',2)

level4x = [198.0 198.0 207.0 207.0 198.0];
level4y = [17.0 23.9 23.9 17.0 17.0];
m_plot(level4x,level4y,'c-','linewidth',2)

title('WIS Pacific Hindcast Grid System','Fontweight','bold')
xlabel('Longitude','fontweight','bold')
ylabel('Latitude','fontweight','bold')
legend('Intermediate Grid','Coastal Grid','Hawaii Grid',3,'fontweight','bold')

print(gcf,'-dpng','-r0','-painters','WIS_PAC_GRIDS')