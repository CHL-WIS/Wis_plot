function stats_calc(buoyc,buoy,model,modelv,saven,simname,unt)
%
%     stats_calc
%      created TJ Hesser
% 
%   INPUT:
%     buoyc         STRING      :name of buoy
%     buoy          STRUCT      :
%     model         STRUCT      :
%     modelv        STRING      : model name and version
%     saven         STRING      : file name for figures
%     simname       STRING      : description of sim for title 
%     unt           STRING      : units ex. 'ft' or 'm'
%
%   Structured format:
%     .time        Matlab time
%     .lon         Longitude
%     .lat         Latitude
%     .wndspd        Wind Speed
%     .wnddir        Wind Direction
%     .wavhs        Wave Height
%     .wavtpp         Peak Period
%     .wavtm1         Mean Period
%     .wavdir        Wave Direction
% -------------------------------------------------------------------------

tol=11;
if strcmp(unt,'ft')
    buoy.wavhs = buoy.wavhs * 3.281;
    buoy.wndspd = buoy.wndspd * 2.23694;
    model.wavhs = model.wavhs .* 3.281;
    model.wndspd = model.wndspd .* 2.23694;
    names = {'H_{mo} (ft)';'T_{p} (s)';'T_{m} (s)';'WS (mi/hr)';'WD (deg)'};
else
    names = {'H_{mo} (m)';'T_{p} (s)';'T_{m} (s)';'WS (m/s)';'WD (deg)'};
end
ii = buoy.wavhs >= 0 & buoy.time >= model.time(1) & ...
        buoy.time <= model.time(end);
if isempty(buoy.wavhs(ii))
    return
end
%
%  More rows goes first in the arguement.
%       i1= index of larger data set.
%
totobsM = length(model.time);
totobsB = length(buoy.time);
if totobsM < totobsB
    [kkB,kkM]=mpair(buoy.time,model.time,tol);
else
    [kkM,kkB]=mpair(model.time,buoy.time,tol);
end

AB=[buoy.time(kkB),buoy.wndspd(kkB),buoy.wnddir(kkB),buoy.wavhs(kkB), ...
    buoy.wavtpp(kkB),buoy.wavtm1(kkB),buoy.wavdir(kkB)];
AM=[model.time(kkM),model.wndspd(kkM),model.wnddir(kkM),model.wavhs(kkM),...
    model.wavtpp(kkM),model.wavtm1(kkM),model.wavdir(kkM)];

saveout = ['timepair-',saven,'-',buoyc];
save(saveout,'AB','AM');

if size(AB,1) < 5
    return
end

[se,sd]=stats(AB,AM);

iwsg=find(AB(:,2) > 0 );
iwdg=find(AB(:,3) > 0 );
iwhtg=find(AB(:,4) > 0 );
itpg=find(AB(:,5) > 0 & AM(:,5) > 0 & AB(:,5) ~= Inf & AM(:,5) ~= Inf );
itmg=find(AB(:,6) > 0 & AM(:,6) > 0 & AB(:,6) ~= Inf & AM(:,6) ~= Inf);
iwadg=find(AB(:,7) > 0 );
vars = {iwsg;iwdg;iwhtg;itpg;itmg;iwadg};
rr = [4;5;6;2;3];

f = figure('visible','off');
for ii = 1:3
    if isempty(vars{rr(ii)-1})
        continue
    end
    [qqB,qqM]=QQ_proc(AB(vars{rr(ii)-1},rr(ii)),AM(vars{rr(ii)-1},rr(ii)));
    orient('tall')
    subplot(3,2,2*ii-1)
    maxv = double(max(max(AB(vars{rr(ii)-1},rr(ii))),max(AM(vars{rr(ii)-1},rr(ii)))));
    plot(AB(vars{rr(ii)-1},rr(ii)),AM(vars{rr(ii)-1},rr(ii)),'r.', ...
        [0 maxv],[0 maxv],'b',[0 se(ii+1,9)*maxv], ...
        [0 se(ii+1,9)*maxv],'g--')
    grid
    axis([0,maxv,0,maxv]);
    axis('square')
    name1 = [modelv,' ',names{ii}];
    name2 = ['Buoy ',names{ii}];
    ylabel(name1);
    xlabel(name2);
    titchar1=['BUOY: ',buoyc,'  ',simname];
    %titchar1=[modelv,' at ',buoyc];
    if ii == 1
        title(titchar1);
    end
    str(1) = {['No Obs = ',int2str(length(vars{rr(ii)-1}))]};
    str(2) = {['Bias   = ',num2str(se(ii+1,3))]};
    str(3) = {['RMSE   = ',num2str(se(ii+1,5))]};
    str(4) = {['S.I.   = ',int2str(se(ii+1,6))]};
    str(5) = {['Corr   = ',num2str(se(ii+1,8))]};
    str(6) = {['Sym r  = ',num2str(se(ii+1,9))]};
    text(maxv+ 0.1*maxv,0,str,'FontSize',7);
    clear str;
    %
    subplot(3,2,2*ii)
    plot(qqB,qqM,'r+',[0 maxv],[0 maxv],'b')
    grid
    axis([0,maxv,0,maxv]);
    axis('square')
    ylabel(name1)
    xlabel(name2)
    titchar2=['BUOY: ',buoyc,'  ',simname,' Q-Q'];
    %titchar2=[modelv,' vs ',buoyc,' Q-Q '];
    if ii == 1
        title(titchar2);
    end
end
ff3 = ['scat-',saven,'-',buoyc,'-p1'];
saveas(f,ff3,'png');
close(f);clear f
close all

f = figure('visible','off');
orient('tall')
if ~isempty(iwsg)
    [qqB,qqM]=QQ_proc(AB(iwsg,2),AM(iwsg,2));
    subplot(3,2,1)
    wsmax = double(max(max(AB(iwsg,2)),max(AM(iwsg,2))));
    plot(AB(iwsg,2),AM(iwsg,2),'r.',[0 wsmax],[0 wsmax],'b',...
        [0 se(1,9)*wsmax],[0 se(1,9)*wsmax],'g--')
    grid
    axis([0,wsmax,0,wsmax]);
    axis('square');
    yname = [modelv,' WS'];
    ylabel(yname);
    xlabel('Buoy WS');
    %titchar1=[modelv,' at ',buoyc];
    titchar1=['BUOY: ',buoyc,'  ',simname];
    title(titchar1);
    str(1) = {['No Obs = ',int2str(length(iwsg))]};
    str(2) = {['Bias   = ',num2str(se(1,3))]};
    str(3) = {['RMSE   = ',num2str(se(1,5))]};
    str(4) = {['S.I.   = ',int2str(se(1,6))]};
    str(5) = {['Corr   = ',num2str(se(1,8))]};
    str(6) = {['Sym r  = ',num2str(se(1,9))]};
    text(wsmax+ 0.1*wsmax,0,str,'FontSize',7);
    clear str;
    %
    subplot(3,2,2)
    plot(qqB,qqM,'r+',[0 wsmax],[0 wsmax],'b')
    grid
    axis([0,wsmax,0,wsmax]);
    axis('square');
    ylabel(yname);
    xlabel('Buoy WS');
    %titchar2=[modelv,' vs ',buoyc,' Q-Q'];
    titchar2=['BUOY: ',buoyc,'  ',simname,' Q-Q'];
    title(titchar2);
    %
    %
    subplot(3,2,3)
    plot(AB(iwdg,3),AM(iwdg,3),'r.',[0 360],[0 360],'b')
    grid
    axis([0,360,0,360]);
    axis('square');
    ytype2 = [modelv,' WD'];
    ylabel(ytype2);
    xlabel('Buoy WD');
    titchar1=['BUOY: ',buoyc,'  ',simname];
    %titchar1=[modelv,' at ',buoyc];
    
    str(1) = {['No Obs = ',int2str(length(iwdg))]};
    str(2) = {['Scl X   = ',num2str(sd(1,1))]};
    str(3) = {['Scl Y   = ',num2str(sd(1,2))]};
    str(4) = {['Vec X  = ',num2str(sd(1,3))]};
    str(5) = {['Vec Y  = ',num2str(sd(1,4))]};
    str(6) = {['Diff   = ',num2str(sd(1,5))]};
    str(7) = {['Sigma  = ',num2str(sd(1,6))]};
    str(8) = {['Rho    = ',num2str(sd(1,7))]};
    str(9) = {['Phase = ',num2str(sd(1,8))]};
    text(360+ 0.075*360,-10,str,'FontSize',7);
    clear str;
    %
    %  Wind Direction Distribution Scatter Plot
    %
    nbins=36;
    resbins=360/nbins;
    DIRINT=0:resbins:360-resbins;
    NHIB=hist(AB(iwdg,3),nbins);
    NHIM=hist(AM(iwdg,3),nbins);
    cumtotM=cumsum(NHIM)/length(iwdg);
    cumtotB=cumsum(NHIB)/length(iwdg);
    
    subplot(3,2,4)
    HC=plot(DIRINT,cumtotB,'ro',DIRINT,cumtotM,'b*');
    grid
    axis([0,350,0 1]);
    legend(HC,'Buoy','Mod',4);
    axis('square');
    ylabel('Cum. %');
    xchar=['Dir Binned at ',int2str(resbins),'\circ' ];
    xlabel(xchar);
    clear HC; clear NHIB; clear NHIM; clear cumtotM; clear cumtotB;
else
    qqB=zeros(1,99);
    qqM=zeros(1,99);
    se(1,1:18)=0;
    wsmax=10;
    resbins=0;
    xchar=['Dir Binned at ',int2str(resbins),'\circ' ];
    ppr1 = {wsmax;wsmax;360;350};
    ppr2 = {wsmax;wsmax;360;1.0};
    ppy1 = [modelv,' WS'];
    ppy2 = [modelv,' WD'];
    ppy = {ppy1;ppy1;ppy2;'Cum. %'};
    ppx = {'Buoy WS';'Buoy WS';'Buoy WD';xchar};
    titchar1=[modelv,' at ',buoyc];
    titchar2=[modelv,' vs ',buoyc,' Q-Q'];
    txx = {5;5;180;180};
    txy = {5;5;180;0.5};
    for ii = 1:4
        subplot(3,2,ii)
        plot([0 ppr1{ii}],[0 ppr2{ii}],'b')
        grid
        axis([0,ppr1{ii},0,ppr2{ii}]);
        axis('square');
        ylabel(ppy{ii});
        xlabel(ppx{ii});
        text(txx{ii},txy{ii},'NODATA','HorizontalAlignment','center','Color','r');
        if ii == 1
            title(titchar1);
        elseif ii == 2
            title(titchar2);
        end
    end
    
end

if isempty(iwadg) == 0
    
    subplot(3,2,5)
    plot(AB(iwadg,7),AM(iwadg,7),'r.',[0 360],[0 360],'b')
    grid
    axis([0,360,0,360]);
    axis('square');
    ylabel([modelv,' WAVE  \theta_{M}']);
    xlabel('Buoy WAVE  \theta_{M}');
    %
    str(1) = {['No Obs = ',int2str(length(iwsg))]};
    str(2) = {['Scl X   = ',num2str(sd(2,1))]};
    str(3) = {['Scl Y   = ',num2str(sd(2,2))]};
    str(4) = {['Vec X  = ',num2str(sd(2,3))]};
    str(5) = {['Vec Y  = ',num2str(sd(2,4))]};
    str(6) = {['Diff   = ',num2str(sd(2,5))]};
    str(7) = {['Sigma  = ',num2str(sd(2,6))]};
    str(8) = {['Rho    = ',num2str(sd(2,7))]};
    str(9) = {['Phase = ',num2str(sd(2,8))]};
    text(360+ 0.1*360,-10,str,'FontSize',7);
    clear str;
    %
    %  Wave Cumulative Distribution Scatter Plot
    %
    nbins=36;
    resbins=360/nbins;
    DIRINT=0:resbins:360-resbins;
    NHIWB=hist(AB(iwadg,7),nbins);
    NHIWM=hist(AM(iwadg,7),nbins);
    cumtotM=cumsum(NHIWM)/length(iwadg);
    cumtotB=cumsum(NHIWB)/length(iwadg);
    
    subplot(3,2,6)
    HC=plot(DIRINT,cumtotB,'ro',DIRINT,cumtotM,'b*');
    grid
    axis([0,350,0 1]);
    legend(HC,'Buoy','Mod',4);
    axis('square');
    ylabel('Cum. %');
    xchar=['Dir Binned at ',int2str(resbins),'\circ' ];
    xlabel(xchar);
    clear HC;
    %
end
ff2 = ['scat-',saven,'-',buoyc,'-p2'];
saveas(f,ff2,'png');
close(f);clear f
close all
