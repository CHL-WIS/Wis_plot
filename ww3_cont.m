function ww3_cont(track,modelnm,plotloc,bas)
%  map contour ww3 pacific

project_in = 'mercator';
storm = bas;
%colposit = [0.2982 0.19 0.4500 0.0300];
%legboxx=0.02;
%legboxy=0.08;
load([plotloc,bas,'-',track(9:end),'.mat']);
% open max mean file and read header information
fname = dir('Max*.dat');
fid = fopen(fname.name,'r');
header = textscan(fid,'%f%f%f%f%f%f%f%f',1);
if ~isempty(strfind(fname.name,'ww3'))
    time1 = header{1};
    time2 = header{2};
    xlonw = header{3};
    xlone = header{4};
    nlon = header{5};
    xlats = header{6};
    xlatn = header{7};
    nlat = header{8};
    resd = (xlatn - xlats)/(nlat-1);
    qq = 1:8;
else
    time1 = header{1};
    time2 = header{2};
    resd = header{3};
    xlats = header{5};
    xlatn = header{6};
    xlonw = header{7};
    xlone = header{8};
    nlon = (xlone - xlonw)/resd + 1;
    nlat = (xlatn - xlats)/resd + 1;
    qr = [3,5,7];
end
    

xx = [xlonw:resd:xlone];
yy = [xlats:resd:xlatn];


fieldname{1} ='Maximum Total   Height H_{mo} ';
displname{1} ='H_{total}  ';
filename{1} ='HMOTOT';
fieldname{2} ='Mean Total   Height H_{mo} ';
displname{2} ='H_{total}  ';
filename{2} ='HMOTOT';

fieldname{3} ='Maximum Wind-Sea   Height H_{mo} ';
displname{3} ='H_{sea}  ';
filename{3} ='HMOSEA';
fieldname{4} ='Mean Wind-Sea   Height H_{mo} ';
displname{4} ='H_{sea}  ';
filename{4} ='HMOSEA';

fieldname{5} ='Maximum Swell   Height H_{mo} ';
displname{5} ='H_{swell} ';
filename{5} ='HMOSWL';
fieldname{6} ='Mean Swell   Height H_{mo} ';
displname{6} ='H_{swell} ';
filename{6} ='HMOSWL';

fieldname{7} ='Maximum Winds   Speed U_{10} ';
displname{7} ='U_{10} ';
filename{7} ='U10TOT';
fieldname{8} ='Mean Winds   Speed U_{10} ';
displname{8} ='U_{10} ';
filename{8} ='U10TOT';

%units = 'm';
%read max and mean wave height information for total, windsea, and swell
for qq = 1:8
    if ~isempty(strfind(fname.name,'ww3'))
        for jj = 1:nlat
            data = fscanf(fid,'%f',nlon);
            hs{qq}(:,jj) = data;
        end
        hs{qq} = hs{qq}';
    else 
        if ismember(qq,qr)
           for pdum = 1:2
               data = fscanf(fid,'%10f',[nlon,nlat]);
           end
        end
        data = fscanf(fid,'%10f',[nlon,nlat]);
        hs{qq} = flipud(data');
         
    end

    titlefld1= fieldname{qq};
    titlefld2= displname{qq};
    titfile=filename{qq};
    
    if mod(qq,2) == 0
        mm = '-MEAN';
    else
        mm = '-MAX';
    end
    if qq > 6
        units = 'm/s';
    else
        units = 'm';
    end
    unts = units;
    fileout1=[titfile,'-',modelnm,'-',track,'-',storm,mm]
    titlnam1A=[modelnm,' ',storm,'  (Res ',num2str(resd),'\circ',...
        ' )'];
    titlnam1B=['  ',titlefld1,'  RESULTS:   ',track];
    titlnam1=[{titlnam1A};{titlnam1B}];
%Start plotting routine
    RANGMM = max(max(hs{qq}));
    disp([titlefld1,'  ',num2str(RANGMM)]);
    interv=0.005*RANGMM;
    v=[-1,0:interv:RANGMM];
    
    for jj = 1:nlat
        for ii = 1:nlon
            if (hs{qq}(jj,ii) >= 0.0 && hs{qq}(jj,ii) <= v(8))
                hs{qq}(jj,ii) = v(8);
            end
        end
    end
    
    % find max locations
      [imax jmax] = find(hs{qq} == RANGMM);
      
    load cmap.mat
    f = figure('visible','off');
    %f = figure('visible','on');
    colormap(cmap)
    m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);

    [CMCF,hh]=m_contourf(xx,yy,hs{qq},v);
    hold on
    caxis([0,RANGMM]);
    set(hh,'EdgeColor','none');
    m_gshhs_i('patch',[.0 .5 .0],'edgecolor','y');
    set(f,'units','inches');
    set(f,'Position',[0 0 6.75 7.50]);
    %set(hh,'Position',[0.13 0.17 0.775 0.725]);
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
        m_plot(xx(jmax(ii)),yy(imax(ii)),'w.','MarkerSize',12);
    end 
    nummax=size(imax,1);
    xlocmax = xx(jmax(1))-360;
    deg4lon=' \circ W / ';
    if xlocmax < -180;
        xlocmax = xlocmax + 360;
        if xlocmax > 0
            deg4lon=' \circ E / ';
        else
            deg4lon=' \circ W / ';
        end
    end
    if yy(imax(1))>= 0.0
        deg4lat = ' \circ N';
    else
        deg4lat = ' \circ S';
    end
    
    time1c = num2str(time1);
    time2c = num2str(time2);
    
    textstg1=[titlefld2,' = ',sprintf('%5.2f',RANGMM),' [',unts,']'];
    textstg2=['LOC (Obs= ',int2str(nummax), ' ):  ' ,num2str(xlocmax),deg4lon,...
        num2str(yy(imax(1))),deg4lat];
    textstg3=['DATE: ',time1c(1:10),'-',time2c(1:10)];
    textstrt=[{textstg1};{textstg2};{textstg3}];
    
    
    hcolmax=colorbar('horizontal');
    set(hcolmax,'Position',colposit,'FontSize',8)
    textcolbr=[titlefld1,'  [',unts,']'];
    text(colortext(1),colortext(2),textcolbr,'FontWeight','bold', ...
        'FontSize',8,'units','normalized');
    title(titlnam1,'FontWeight','bold');
    text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',8, ...
        'units','normalized','BackgroundColor','w');
    
%    pos=get(f,'Position');
%    pos(3:4)=[649,664];
%    pos(3:4) = [1081 1106];
%    pos(3:4) = [1298 1328];
%     set(f,'units','inches');
     set(f,'papersize',[9 11]);
     set(f,'PaperPosition',[0 0 6.75 7.50]);
%     set(f,'paperposition',[0.48 1.65 7.76 7.92])
%     set(f,'paperposition',[1 1 15 18]);
%     set(f,'units','inches','Position',[0 0 7.21 7.37])
%     pos = getpixelposition(f);
%     resol = get(0,'ScreenPixelsPerInch');
%     set(f,'Paperunits','inches','papersize',pos(3:4)/resol,'paperposition',[0 0 pos(3:4)/resol])
%      set(f,'Paperunits','inches','papersize',[1.5*8.5 1.5*11],'paperposition',[0 0 1.5*7.21 1.5*7.37]);
%     set(f,'Position',pos,'PaperPositionMode','manual');
%      set(f,'position',[0 0 7.21*2*resol 7.37*2*resol]);
%    set(gcf,'Position',pos,'PaperPositionMode','auto');
%     set(f,'Position',pos);
     set(f,'PaperPositionMode','manual');
%set(gcf,'renderer','painters');
%    print(f,'-dpng','-r600',fileout1); 
    saveas(f,fileout1,'png')
    %clf;clear f
    close(f);clear f
end
fclose(fid);
% pdfn = dir('*.pdf');
% for zz = 1:size(pdfn,1)
%     name = pdfn(zz).name;
%     system(['convert ',name,' ',name(1:end-3),'png']);
% end
end
