function f = map_point(pointloc,coord,varargin)
p = inputParser;
p.addRequired('pointloc');
p.addRequired('coord');
p.addOptional('fplt',0);
p.addOptional('splt',0);
parse(p,pointloc,coord,varargin{:});

fplt = p.Results.fplt;
splt = p.Results.splt;

xlonw = coord(1);
xlone = coord(2);
xlats = coord(3);
xlatn = coord(4);
project_in = 'mercator';

if fplt > 0
    figure(fplt)
elseif splt > 0
    subplot(splt)
end

m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
hold on
m_gshhs_i('patch',[.0 .5 .0],'edgecolor','k');
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
set(h_water,'FaceColor','none')
for jj = 1:size(pointloc,1)
    m_plot(pointloc(jj,1),pointloc(jj,2),'r.','markersize',8)
end
% set(hh,'EdgeColor','none');

% xlabel('Longitude','FontWeight','bold')
% ylabel('Latitude','FontWeight','bold')

;
