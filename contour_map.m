function f = contour_map(lon,lat,value)
data.lon = lon;
data.lat = lat;
data.value = value;

xlonw = min(data.lon);
xlone = max(data.lon);
xlats = min(data.lat);
xlatn = max(data.lat);
project_in = 'mercator';

RANGMM = max(max(data.value));
%disp([titlefld1,'  ',num2str(RANGMM)]);
interv=0.005*RANGMM;
v=[-1,0:interv:RANGMM];
load cmap.mat
f = figure('visible','on');
colormap(cmap)
m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);

[CMCF,hh]=m_contourf(data.lon,data.lat,data.value,v);
hold on
caxis([0,RANGMM]);
set(hh,'EdgeColor','none');
m_gshhs_i('patch',[.0 .5 .0],'edgecolor','y');
xlabel('Longitude','FontWeight','bold')
ylabel('Latitude','FontWeight','bold')
m_grid('box','fancy','tickdir','in','FontWeight','Bold');
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