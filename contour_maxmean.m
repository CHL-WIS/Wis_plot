function f = contour_maxmean(data,varname)

xlonw = min(data.lon);
xlone = max(data.lon);
xlats = min(data.lat);
xlatn = max(data.lat);
project_in = 'mercator';
type={'max';'mean'};
warning('off','all');

for jj = 1:2
    value = data.(type{jj});
    RANGMM = max(max(value));
    %disp([titlefld1,'  ',num2str(RANGMM)]);
    interv=0.005*RANGMM;
    v=[-1,0:interv:RANGMM];
    
    [imax jmax] = find(value == RANGMM);
    
    load cmap.mat
    f(jj) = figure('visible','off');
    colormap(cmap)
    m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
    
    [~,hh]=m_contourf(data.lon,data.lat,value,v);
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
    
        for ii = 1:size(imax,1)
        m_plot(data.lon(jmax(ii)),data.lat(imax(ii)),'w.','MarkerSize',12);
    end 
    nummax=size(imax,1);
    xlocmax = data.lon(jmax(1))-360;
    deg4lon=' \circ W / ';
    if xlocmax < -180;
        xlocmax = xlocmax + 360;
        if xlocmax > 0
            deg4lon=' \circ E / ';
        else
            deg4lon=' \circ W / ';
        end
    end
    if data.lat(imax(1))>= 0.0
        deg4lat = ' \circ N';
    else
        deg4lat = ' \circ S';
    end
    
    [lont,latt] = plot_hurr_tracks(data.time(1,1),data.time(2,1),[xlonw xlone],[xlats xlatn]);
    if max(xlonw,xlone)  > 180
         lont(lont<0) = lont(lont<0) + 360;
    end
    
    
    
    
    hcolmax=colorbar('horizontal');
    
%     fname = ['pac_',data.grid,'_',varname,'_',type{jj},'.png'];
%     print(gcf,'-dpng','-r0','-painters',fname);
%     clf
%     close(f)
end