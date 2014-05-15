function [cax]=define_taylordiag_axis(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin == 0
    disp_optionslist;
    return
else
    narg = nargin - 3 ;
    if mod(narg,2) ~= 0
        error('taylordiag.m : Wrong number of arguments')
    end
end

rho = varargin{1};
dx = varargin{2};
Npan=varargin{3};
nopt = narg/2; %number of custom options


%% BEGIN THE PLOT HERE TO GET AXIS VALUES:
%figure;
hold on
cax = gca;
tc = get(cax,'xcolor');
%ls = get(cax,'gridlinestyle');
ls = '-'; % DEFINE HERE THE GRID STYLE
next = lower(get(cax,'NextPlot'));

%% LOAD CUSTOM OPTION OF AXE LIMIT:

foundrmax = 0;
for iopt = 4 : 2 : narg+3
    optvalue = varargin{iopt+1};
    switch lower(varargin{iopt}), case 'limstd', rmax = optvalue; foundrmax=1; end
end

% make a radial grid
hold(cax,'on');
if foundrmax==0
    maxrho = max(abs(rho(:)));
else
    maxrho = rmax;
end
hhh = line([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho],'parent',cax);
set(cax,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
v = [get(cax,'xlim') get(cax,'ylim')];
ticks = sum(get(cax,'ytick')>=0);
delete(hhh);

% check radial limits and ticks
rmin = 0;
if foundrmax == 0;
    rmax = v(4);
end
rticks = max(ticks-1,2);
if rticks > 5   % see if we can reduce the number
    if rem(rticks,2) == 0
        rticks = rticks/2;
    elseif rem(rticks,3) == 0
        rticks = rticks/3;
    end
end
rinc  = (rmax-rmin)/rticks;
tick  = (rmin+rinc):rinc:rmax;

%% LOAD DEFAULT PARAMETERS:
hyp=sqrt(max(dx)+rmax^2);
tickRMSangle=(pi-asin(rmax/hyp))*(180/pi);
%tickRMSangle  = 135; %old default
showlabelsRMS = 1;
showlabelsSTD = 1;
showlabelsCOR = 1;
colSTD = [0 0 0];
colRMS = [0 .6 0];
colCOR = [0 0 1];
tickCOR(1).val = [1 .99 .95 .9:-.1:0];
tickCOR(2).val = [1 .99 .95 .9:-.1:0 -.1:-.1:-.9 -.95 -.99 -1];
widthCOR = .8;
widthRMS = .8;
widthSTD = .8;
styleCOR = '-.';
styleRMS = '--';
styleSTD = '-';
titleRMS = 1;
titleCOR = 1;
titleSTD = 1;
tickRMS = tick; rincRMS = rinc;
tickSTD = tick; rincSTD = rinc;


%% LOAD CUSTOM OPTIONS:
for iopt = 4 : 2 : narg+3
    optname  = varargin{iopt};
    optvalue = varargin{iopt+1};
    switch lower(optname)
        
        case 'tickrms'
            tickRMS = sort(optvalue);
            rincRMS = (max(tickRMS)-min(tickRMS))/length(tickRMS);
        case 'showlabelsrms'
            showlabelsRMS = optvalue;
        case 'tickrmsangle'
            tickRMSangle = optvalue;
        case 'colrms'
            colRMS = optvalue;
        case 'widthrms'
            widthRMS = optvalue;
        case 'stylerms'
            styleRMS = optvalue;
        case 'titlerms'
            titleRMS = optvalue;
            
        case 'tickstd'
            tickSTD = sort(optvalue);
            rincSTD = (max(tickSTD)-min(tickSTD))/length(tickSTD);
        case 'showlabelsstd'
            showlabelsSTD = optvalue;
        case 'colstd'
            colSTD = optvalue;
        case 'widthstd'
            widthSTD = optvalue;
        case 'stylestd'
            styleSTD = optvalue;
        case 'titlestd'
            titleSTD = optvalue;
        case 'npan'
            Npan = optvalue;
            
        case 'tickcor'
            tickCOR(Npan).val = optvalue;
        case 'colcor'
            colCOR = optvalue;
        case 'widthcor'
            widthCOR = optvalue;
        case 'stylecor'
            styleCOR = optvalue;
        case 'titlecor'
            titleCOR = optvalue;
        case 'showlabelscor'
            showlabelsCOR = optvalue;
    end
end


%% CONTINUE THE PLOT WITH UPDATED OPTIONS:

% define a circle
th = 0:pi/150:2*pi;
xunit = cos(th);
yunit = sin(th);
% now really force points on x/y axes to lie on them exactly
inds = 1:(length(th)-1)/4:length(th);
xunit(inds(2:2:4)) = zeros(2,1);
yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
if ~ischar(get(cax,'color')),
    %		ig = find(th>=0 & th<=pi);
    ig = 1:length(th);
    patch('xdata',xunit(ig)*rmax,'ydata',yunit(ig)*rmax, ...
        'edgecolor',tc,'facecolor',get(cax,'color'),...
        'handlevisibility','off','parent',cax);
end

% DRAW RMS CIRCLES:
% ANGLE OF THE TICK LABELS
c82 = cos(tickRMSangle*pi/180);
s82 = sin(tickRMSangle*pi/180);
for ic = 1 : length(tickRMS)
    i = tickRMS(ic);
    iphic = find( sqrt(max(dx)^2+rmax^2-2*max(dx)*rmax*xunit) >= i ,1);
    ig = find(i*cos(th)+max(dx) <= rmax*cos(th(iphic)));
    hhh = line(xunit(ig)*i+max(dx),yunit(ig)*i,'linestyle',styleRMS,'color',colRMS,'linewidth',widthRMS,...
        'handlevisibility','off','parent',cax);
    if showlabelsRMS
        text((i+rincRMS/20)*c82+max(dx),(i+rincRMS/20)*s82, ...
            ['  ' num2str(i)],'verticalalignment','bottom',...
            'handlevisibility','off','parent',cax,'color',colRMS,'rotation',tickRMSangle-90)
    end 
end

%DRAW DIFFERENTLY THE CIRCLE CORRESPONDING TO THE OBSERVED VALUE
hhh = line((cos(th)*max(dx)),sin(th)*max(dx),'linestyle','-','color',colSTD,'linewidth',1.5,...
    'handlevisibility','off','parent',cax);


% DRAW STD CIRCLES:
% draw radial circles
for ic = 1 : length(tickSTD)
    i = tickSTD(ic);
    hhh = line(xunit*i,yunit*i,'linestyle',styleSTD,'color',colSTD,'linewidth',widthSTD,...
        'handlevisibility','off','parent',cax);
    if showlabelsSTD
        if Npan == 2
            if isempty(tickSTD==0) == 0
                text(0,-rincSTD/20,'0','verticalalignment','top','horizontalAlignment','center',...
                    'handlevisibility','off','parent',cax,'color',colSTD); %plot 0
            end
            text(i,-rincSTD/20, ...
                num2str(i),'verticalalignment','top','horizontalAlignment','center',...
                'handlevisibility','off','parent',cax,'color',colSTD)
            text(-i,-rincSTD/20, ...
                num2str(i),'verticalalignment','top','horizontalAlignment','center',...
                'handlevisibility','off','parent',cax,'color',colSTD)
        else
            if isempty(tickSTD==0) == 0
                text(-rincSTD/20,rincSTD/20,'0','verticalalignment','middle','horizontalAlignment','right',...
                    'handlevisibility','off','parent',cax,'color',colSTD); %plot 0
            end
            text(-rincSTD/20,i, ...
                num2str(i),'verticalalignment','middle','horizontalAlignment','right',...
                'handlevisibility','off','parent',cax,'color',colSTD)
            text(i,-rincSTD/8, ...
                num2str(i),'verticalalignment','middle','horizontalAlignment','center',...
                'handlevisibility','off','parent',cax,'color',colSTD)
        end
    end
end
set(hhh,'linestyle','-') % Make outer circle solid

% DRAW CORRELATIONS LINES EMANATING FROM THE ORIGIN:
corr = tickCOR(Npan).val;
th  = acos(corr);
cst = cos(th); snt = sin(th);
cs = [-cst; cst];
sn = [-snt; snt];
line(rmax*cs,rmax*sn,'linestyle',styleCOR,'color',colCOR,'linewidth',widthCOR,...
    'handlevisibility','off','parent',cax)

% annotate them in correlation coef
if showlabelsCOR
    rt = 1.05*rmax;
    for i = 1:length(corr)
        text(rt*cst(i),rt*snt(i),num2str(corr(i)),...
            'horizontalalignment','center',...
            'handlevisibility','off','parent',cax,'color',colCOR);
    end
end

% AXIS TITLES
axlabweight = 'bold';
ix = 0;
if Npan == 1
    if titleSTD
        ix = ix + 1;
        ax(ix).handle = ylabel('Normalzied standard deviation (\sigma_m/\sigma_o)','color',colSTD,'fontweight',axlabweight);
    end
    
    if titleCOR
        ix = ix + 1;
        clear ttt
        pos1 = 45;	DA = 15;
        lab = 'Correlation Coefficient';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        dd = 1.1*rmax;	ii = 0;
        for ic = 1 : length(c)
            ith = c(ic);
            ii = ii + 1;
            ttt(ii)=text(dd*cos(ith*pi/180),dd*sin(ith*pi/180),lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',colCOR,'horizontalalignment','center',...
                'verticalalignment','bottom','fontsize',get(ax(1).handle,'fontsize'),'fontweight',axlabweight);
        end
        ax(ix).handle = ttt;
    end
    
    if titleRMS
        ix = ix + 1;
        clear ttt
        pos1 = tickRMSangle+(180-tickRMSangle)/2;
        DA = 10; %controls letter spacing
        lab = 'RMSD';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        dd = .95*tickRMS(1); %put label right below second tick
        ii = 0;
        for ic = 1 : length(c)
            ith = c(ic);
            ii = ii + 1;
            ttt(ii)=text(max(dx)+dd*cos(ith*pi/180),dd*sin(ith*pi/180),lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',colRMS,'horizontalalignment','center',...
                'verticalalignment','top','fontsize',get(ax(1).handle,'fontsize'),'fontweight',axlabweight);
        end
        ax(ix).handle = ttt;
    end
    
else
    if titleSTD
        ix = ix + 1;
        ax(ix).handle =xlabel('Normalzied standard deviation (\sigma_m/\sigma_o)','fontweight',axlabweight,'color',colSTD);
    end
    
    if titleCOR
        ix = ix + 1;
        clear ttt
        pos1 = 90;	DA = 15;
        lab = 'Correlation Coefficient';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        dd = 1.1*rmax;	ii = 0;
        for ic = 1 : length(c)
            ith = c(ic);
            ii = ii + 1;
            ttt(ii)=text(dd*cos(ith*pi/180),dd*sin(ith*pi/180),lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',colCOR,'horizontalalignment','center',...
                'verticalalignment','bottom','fontsize',get(ax(1).handle,'fontsize'),'fontweight',axlabweight);
        end
        ax(ix).handle = ttt;
    end
    
    if titleRMS
        ix = ix + 1;
        clear ttt
        pos1 = tickRMSangle+(180-tickRMSangle)/2;
        DA = 10;
        lab = 'RMSD';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        dd = 1.05*tickRMS(3); %put label right above third tick
        ii = 0;
        for ic = 1 : length(c)
            ith = c(ic);
            ii = ii + 1;
            ttt(ii)=text(max(dx)+dd*cos(ith*pi/180),dd*sin(ith*pi/180),lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',colRMS,'horizontalalignment','center',...
                'verticalalignment','bottom','fontsize',get(ax(1).handle,'fontsize'),'fontweight',axlabweight);
        end
        ax(ix).handle = ttt;
    end
end

% VARIOUS ADJUSTMENTS TO THE PLOT:
set(cax,'dataaspectratio',[1 1 1]), axis(cax,'off'); set(cax,'NextPlot',next);
set(get(cax,'xlabel'),'visible','on')
set(get(cax,'ylabel'),'visible','on')
%    makemcode('RegisterHandle',cax,'IgnoreHandle',q,'FunctionName','polar');
% set view to 2-D
view(cax,2);
% set axis limits
if Npan == 2
    axis(cax,rmax*[-1.15 1.15 0 1.15]);
    line([-rmax rmax],[0 0],'color',tc,'linewidth',1.2);
    line([0 0],[0 rmax],'color',tc);
else
    axis(cax,rmax*[0 1.15 0 1.15]);
    %	    axis(cax,rmax*[-1 1 -1.15 1.15]);
    line([0 rmax],[0 0],'color',tc,'linewidth',1.2);
    line([0 0],[0 rmax],'color',tc,'linewidth',2);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function disp_optionslist(varargin)

disp('General options:')
dispopt('''Npan''',sprintf('\t1 or 2: Panels to display (1 for positive correlations, 2 for positive and negative correlations).\n\t\t\t\tDefault value depends on CORs'));

disp('RMS axis options:')
dispopt('''tickRMS''','RMS values to plot gridding circles from observation point');
dispopt('''colRMS''','RMS grid and tick labels color. Default: green');
dispopt('''showlabelsRMS''','0 / 1 (default): Show or not the RMS tick labels');
dispopt('''tickRMSangle''','Angle for RMS tick lables with the observation point. Default: 135 deg.');
dispopt('''styleRMS''','Linestyle of the RMS grid');
dispopt('''widthRMS''','Line width of the RMS grid');
dispopt('''titleRMS''','0 / 1 (default): Show RMSD axis title');

disp('STD axis options:')
dispopt('''tickSTD''','STD values to plot gridding circles from origin');
dispopt('''colSTD''','STD grid and tick labels color. Default: black');
dispopt('''showlabelsSTD''','0 / 1 (default): Show or not the STD tick labels');
dispopt('''styleSTD''','Linestyle of the STD grid');
dispopt('''widthSTD''','Line width of the STD grid');
dispopt('''titleSTD''','0 / 1 (default): Show STD axis title');
dispopt('''limSTD''','Max of the STD axis (radius of the largest circle)');

disp('CORRELATION axis options:')
dispopt('''tickCOR''','CORRELATON grid values');
dispopt('''colCOR''','CORRELATION grid color. Default: blue');
dispopt('''showlabelsCOR''','0 / 1 (default): Show or not the CORRELATION tick labels');
dispopt('''styleCOR''','Linestyle of the COR grid');
dispopt('''widthCOR''','Line width of the COR grid');
dispopt('''titleCOR''','0 / 1 (default): Show CORRELATION axis title');

end

function [] = dispopt(optname,optval)
fprintf('%s\t\t%s\n',optname,optval);
end
