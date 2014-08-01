function BC_QC_SYN(storm_nam)
%
%  Input storm_nam is character string including the storm type.
%   storm_nam;  CHARACTER   TP-####
%
%  Below we also load in the individual files containing STWAVE BC' 
%        Station ID's also located in the Matlab Plot Directory of NACCS
%
path1in=['G:\CDRIVE\Program Files\MATLAB\My_Matlab\Wis_plot\NACCS-SANDY\'];

peakdatS=2000071501;
timess=num2str(peakdatS);
yrr=str2num(timess(:,1:4));
mnt=str2num(timess(:,5:6));
dyy=str2num(timess(:,7:8));
timSDS=datenum(yrr,mnt,dyy,0,0,0);
%
%  Go to the working directory
%
wwkdir=['H:\NACCS_PRODUCTION\outdat\BC_EVAL\'];
cd(wwkdir);
%
%  LOAD IN LEVEL3N and PROCESS (Grids 1-8)
%
level='L3N';
pathin=['Y:\NACCS\Production\Model\'];
bbb=[pathin,storm_nam,'*'];
blah = dir([bbb]);
nam2=blah.name;
path2in=[pathin,nam2,'\level3N\'];
filein2=['NACCS_',nam2(1:2),'_',nam2(4:7),'_SYN_',nam2(9:10),'_L3N_STNS.ONLNS'];
T3N=load([path2in,filein2]);
tt=num2str(T3N(:,1));
yrr=str2num(tt(:,1:4));
mnt=str2num(tt(:,5:6));
dyy=str2num(tt(:,7:8));
hrr=str2num(tt(:,9:10));
mnn=str2num(tt(:,11:12));
timT3N=datenum(yrr,mnt,dyy,hrr,mnn,0);
%
%  Load in LEVEL3C Time Series
%
path3in=['Y:\NACCS\Production\Model\',nam2,'\level3C\'];
filein3=[path3in,'NACCS_',nam2(1:2),'_',nam2(4:7),'_SYN_',nam2(9:10),'_L3C_STNS.ONLNS'];
T3C=load(filein3);
%
%  Find the overall maximum wave height to Scale all time plots
%
T3T=[T3N;T3C];
ll=find(T3T(:,2) >=50000);
hmaxx=max(T3T(ll,10));
clear T3T;
%
%  Set the Plotting (1-4) on the first page
%                   (5-9) on the second page
%                   One main title anotated for each grid
%
clf;
orient('Tall');
icnt = 0;
for mm=1:8
    grd=mm;
    filein1=[path1in,'NACCS_',level,'-G',num2str(grd),'_STID.dat'];
    SPTS=load(filein1);
    ii=find(T3N(:,2) == SPTS(1));
    icnt = icnt + 1;
    if icnt <= 4
        ax(icnt) = subplot(5,1,icnt);
        plot(timT3N(ii),T3N(ii,10));
        xtickdif=max(timT3N)-min(timT3N);
        xticks=[min(timT3N):ceil(xtickdif/10):max(timT3N)];
        xticklab=datestr(xticks,6);
        set(gca,'XTick',xticks,'XTicklabel',xticklab);
        grid
        hold on
        xlabch=['Days in:  ',num2str(yrr(1))];
        for nn=1:length(SPTS)
            ii=find(T3N(:,2) == SPTS(nn));
            subplot(5,1,icnt);
            plot(timT3N(ii),T3N(ii,10))
        end
        subplot(5,1,icnt);
        plot([timSDS,timSDS],[0,ceil(hmaxx)],'r','LineWidth',1)
        textch=['STWAVE Grid:  ',int2str(grd)];
        text(xticks(1),floor(hmaxx),textch,'FontSize',8,'FontWeight','Bold');
        xlabel(xlabch,'FontWeight','Bold');
        ylabel('H_{mo} [m]','FontWeight','Bold');
        titl1='Boundary Conditions:  WAMCY451C';
        titl2=['Storm Simulation:  ',nam2];
%         titl3=['STWAVE Max Grid:  ',int2str(grdmax),'  Location:  ',...
%             geoloc];
        titl4=['Storm Peak Date:  ',int2str(peakdatS)];
%         titlt=[{titl1};{titl2};{titl3};{titl4}];
        titlt=[{titl1};{titl2};{titl4}];

        if icnt == 1
            title(titlt,'FontWeight','Bold');
        end
    end
        if icnt == 4 && mm == 4
%            linkaxes(ax,'xy')
            fileout=['NACCS-',nam2,'-G1-4','-TSer_pg1'];
            print(gcf,'-r500','-dpng',fileout);
            clf;
            icnt = 0;
        end
    end
    %
    %  Process LEVEL3C (Two STWAVE DOMAIN:  9 Only)
    %
    level='L3C';
    ttC3=num2str(T3C(:,1));
    yrr=str2num(ttC3(:,1:4));
    mnt=str2num(ttC3(:,5:6));
    dyy=str2num(ttC3(:,7:8));
    hrr=str2num(ttC3(:,9:10));
    mnn=str2num(ttC3(:,11:12));
    timT3C=datenum(yrr,mnt,dyy,hrr,mnn,0);
   
    grd=9;
    filein1=['NACCS_',level,'-G',num2str(grd),'_STID.dat'];
    SPTS=load(filein1);
    ii=find(T3C(:,2) == SPTS(1));
    subplot(5,1,5);
    plot(timT3C(ii),T3C(ii,10))
    xtickdif=max(timT3C)-min(timT3C);
    xticks=[min(timT3C):ceil(xtickdif/10):max(timT3C)];
    xticklab=datestr(xticks,6);
    set(gca,'XTick',xticks,'XTicklabel',xticklab);
    grid
    hold on
    xlabch=['Days in:  ',num2str(yrr(1))];
    for nn=1:length(SPTS)
        ii=find(T3C(:,2) == SPTS(nn));
        plot(timT3C(ii),T3C(ii,10))
    end
    plot([timSDS,timSDS],[0,ceil(hmaxx)],'r','LineWidth',1)
    textch=['STWAVE Grid:  ',int2str(grd)];
    text(xticks(1),floor(hmaxx),textch,'FontSize',8,'FontWeight','Bold');
    xlabel(xlabch,'FontWeight','Bold');
    ylabel('H_{mo} [m]','FontWeight','Bold');
    fileout=['NACCS-',nam2,'-G5-9','-TSer_pg2'];
    print(gcf,'-r500','-dpng',fileout);
    clf;
end

