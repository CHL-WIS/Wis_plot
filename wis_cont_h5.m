function wis_cont_h5(track,modelnm,plotloc,bas,varargin)
%  map contour
p = inputParser;
p.addRequired('track');
p.addRequired('modelnm');
p.addRequired('plotloc');
p.addRequired('bas');
p.addOptional('trackp',0);
p.addOptional('iceC','000');
parse(p,track,modelnm,plotloc,bas,varargin{:});

warning('off','all')
trackp = p.Results.trackp;
iceC = p.Results.iceC;
ice_cover = 0;
if ~strcmp(iceC,'000')
    ice_cover = str2double(iceC(1:2));
    iceflg = iceC(3:3);
    if strcmp(iceflg,'N')
        iceflg2 = 'NIC';
    else
        iceflg2 = 'CIS';
    end
end

project_in = 'mercator';
storm = bas;
ii = strfind(track,'-');
ip = ii(end);
load([plotloc,bas,'-',track(ip+1:end),'.mat']);

varname = {'wavhs';'wavhs_wndsea';'wavhs_swell1';'wndspd'};
type = {'max';'mean'};
typelong = {'Maximum';'Mean'};
varlongname = {'Height H_{mo}';'Height H_{mo}';'Height H_{mo}'; ...
    'Wind Speed U_{10}'};
filename = {'HMOTOT';'HMOSEA';'HMOSWL';'U10TOT'};
varcondition = {'Total';'Wind-Sea';'Swell';'Total'};
displ = {'H_{total}';'H_{sea}';'H_{swell}';'U_{10}'};
units = {'m';'m';'m';'m/s'};


%read max and mean wave height information for total, windsea, and swell
for qq = 1:length(varname)
    data = read_wis_hdf5_var(varname{qq});

    for jtype = 1:2
        titlefld1= [typelong{jtype},' ',varcondition{qq},'   ', ...
            varlongname{qq}];
        titlefld2= displ{qq};
        titfile=filename{qq};
        
        unts = units{qq};
        track = strrep(track,'_','-');
        fileout1=[titfile,'-',modelnm,'-',track,'-',type{jtype}];
        fprintf(1,'File name : %s\n',fileout1);
        titlnam1A=[modelnm,' ',storm,'  (Res ',num2str(data.res),'\circ',...
            ' )'];
        titlnam1B=['  ',titlefld1,'  RESULTS:   ',track];
        titlnam1=[{titlnam1A};{titlnam1B}];

    
        %Start plotting routine
        RANGMM = max(max(data.(type{jtype})));
        disp([titlefld1,'  ',num2str(RANGMM)]);
        interv=0.005*RANGMM;
        v=[-1,0:interv:RANGMM];
        
        
%        find max locations
        [imax jmax] = find(data.(type{jtype}) == RANGMM);
        
        load cmap.mat
        f = figure('visible','off');
        colormap(cmap)
        m_proj(project_in,'long',[min(data.lon) max(data.lon)], ...
            'lat',[min(data.lat) max(data.lat)]);
        
        [CMCF,hh]=m_contourf(data.lon,data.lat,data.(type{jtype}),v);
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
            deg4lat = ' \circ N  ';
        else
            deg4lat = ' \circ S  ';
        end
    
    if trackp == 1
        %yr = str2num(track(1:4));
        %mn = str2num(track(6:7));
        %%%%% ------------------------------------------------------------
        % work in progress TJH 02/21/14
%         yr = [yr1:1:yr2];
%         mn = [mn1:1:mn2];
%         nyears = (yr2 - yr1) + 1;
%         nmons = (mn2 - mn1) + 1;
%         for iyr = 1:nyears
%             for imon = 1:nmons
        [lont,latt] = plot_hurr_tracks(data.time(1,1),data.time(2,1), ...
            [min(data.lon) max(data.lon)],[min(data.lat) max(data.lat)]);
        if max(min(data.lon),max(data.lon))  > 180
            lont(lont<0) = lont(lont<0) + 360;
        end
%             end
%         end
%
%%%%% ---------------------------------------------------------------------
        for jj = 1:size(lont,2)
            m_plot(lont(:,jj),latt(:,jj),'k<-','markersize',6,'linewidth',2)
        end
    end 
    
    time1c = intdate_2_strdate(data.time(1,1),data.time(2,1),data.time(3,1), ...
        data.time(4,1),data.time(5,1),data.time(6,1));
    time2c = intdate_2_strdate(data.time(1,end),data.time(2,end), ...
        data.time(3,end),data.time(4,end),data.time(5,end),data.time(6,end));
 
   
    textstg1=[titlefld2,' = ',sprintf('%5.2f',RANGMM),' [',unts,']'];
    textstg2=['LOC (Obs= ',int2str(nummax), ' ):  ' ,num2str(xlocmax),deg4lon,...
        num2str(data.lat(imax(1))),deg4lat];
    textstg3=['DATE: ',time1c(1:10),'-',time2c(1:10)];
    textstrt=[{textstg1};{textstg2};{textstg3}];
    
    if ice_cover > 0
        icef=['ICEFLD_',track(1:7),'.CUM'];
        if ~exist(icef,'file')
            icef = ['ICEFLD_',track(1:4),'_',track(6:7),'.CUM'];
        end
        if ~exist(icef,'file')
            icef = ['ICEFLD-',track(1:6),'.CUM'];
        end
        fid100 = fopen(icef);
        data = textscan(fid100,'%f%f%f');
        fclose(fid100);
        sLong = data{1};sLat = data{2};zero7 = data{3};
        ice=zero7 == 1;
        m_plot(sLong(ice),sLat(ice),'s','Color',[0.9 0.9 0.9], ...
            'MarkerFaceColor',[0.9 0.9 0.9],'MarkerEdgeColor',[0.9 0.9 0.9],'MarkerSize',4);
        textstg4 = ['ICE Conc (',iceflg2,'):  ',num2str(ice_cover), '%  '];
        textstrt=[{textstg1};{textstg2};{textstg3};{textstg4}];
    end
    
  
    hcolmax=colorbar('horizontal');
    set(hcolmax,'Position',colposit,'FontSize',10,'fontweight','bold')
    textcolbr=[titlefld1,'  [',unts,']'];
    cctext = text(colortext(1),colortext(2),textcolbr,'FontWeight','bold', ...
        'FontSize',10,'units','normalized');
    title(titlnam1,'FontWeight','bold','fontsize',10);
    legtext = text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',10, ...
        'units','normalized','BackgroundColor','w');
    
     set(f,'units','inches');
     set(f,'Position',figpos);
     set(f,'papersize',figpos(3:4));
     set(f,'PaperPosition',figpos);
     set(f,'PaperPositionMode','manual');
    print(f,'-dpng','-r0','-painters',fileout1);
    close(f);clear f
    end
end


