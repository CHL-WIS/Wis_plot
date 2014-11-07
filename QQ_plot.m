function H = QQ_plot(buoy,model,varb,varargin)
%
%  INPUT
%
%       buoy        NUMERIC     all of the time paired model results
%       model       NUMERIC     all of the time paried  buoy results 
%       yrstar      NUMERIC     starting year
%       yrend       NUMERIC     ending year
%       buoystn     CHARACTER   NDBC Location (for Title)
%       varb        CHARACTER   One of the following
%                                   Hs, Tp, Tm
%                               Used for the x and y axis labels
%                               And the title
%
%  ANOTATION SETTING
%
p = inputParser;
p.addRequired('buoy');
p.addRequired('model');
p.addRequired('varb');
p.addOptional('fplt',0);
p.addOptional('splt',0);
p.addOptional('color','r');
p.addOptional('symbol','+');
parse(p,buoy,model,varb,varargin{:});

fplt = p.Results.fplt;
splt = p.Results.splt;
color1 = p.Results.color;
symb = p.Results.symbol;

if fplt > 0
    figure(fplt)
elseif splt > 0
    subplot(splt)
end

if varb(1:2) == 'Hs'
    varbtxt=['H_{mo} [m]'];
elseif varb(1:2) == 'Tp'
    varbtxt=['T_{p}  [s]'];
else
    varbtxt=['T_{mean}  [s]'];
end
%
xlabtxt=['BUOY ',varbtxt];
ylabtxt=['MODEL ',varbtxt];
%titl1=['FEMA LAKE MICHIGAN EXTREME STORMS STUDY'];
%titl2=['MODEL RESULTS:  WAMCY4.5.1C'];
%titl3=['Quartile-Quartile Analysis:  ',buoystn];
%titl4=['Evaluation START: ', int2str(yrstrt),'  END: ' ,int2str(yrend)];
%titl5=['Total Number of Observations:  ',int2str(length(buoy))];
%titlT=[{titl1};{titl2};{titl3};{titl4};{titl5}];
%
%   Call Q-Q Processing Routine For Wave Height
%

%[qqB,qqM]=QQ_proc_extreme(buoy,model);
%[qqB,qqM]=QQ_proc(buoy,model);
[qqB,qqM] = QQ_proc_extr(buoy,model);
maxval=ceil(max(max(qqB(end)),max(qqM(end))));
%
%orient('tall')
%
plot([0 maxval],[0 maxval],'b');
hold on
H=plot(qqB(1:end),qqM(1:end),symb,'Color',color1,'markersize',8);

%H=plot(qqB(1:96),qqM(1:96),'r+',qqB(97:end),qqM(97:end),'bo',[0 maxval],[0 maxval],'b');
%H=plot(qqB(1:990),qqM(1:990),'r+',qqB(991:end),qqM(991:end),'bo',[0 maxval],[0 maxval],'b');
grid
axis([0,maxval+1,0,maxval+1]);
axis('square');
xlabel(xlabtxt,'FontWeight','Bold');
ylabel(ylabtxt,'FontWeight','Bold');
ytick = get(gca,'ytick');
set(gca,'xtick',ytick);
box on
%title(titlT,'FontWeight','Bold');
%legend(H,' 0.1- to 99.0-percentile','99.1- to 99.9-percentile','Location','SouthEast')
%eval(['print -dpng -r600 QQPLOT_ALL_',buoystn,'_',varb]); 

