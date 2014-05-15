function contrplt(buoyin,modelin,yrstrt,yrend,buoystn,varb)
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
titl2=['MODEL RESULTS:  WAMCY4.5.1C'];
if varb(1:2) == 'Hs'
    varbtxt=['H_{mo} [m]'];
elseif varb(1:2) == 'Tp'
    varbtxt=['T_{p}  [s]'];
elseif varb(1:2) == 'Ws'
    varbtxt=['U_{10} [m/s]'];
    titl2=['MODEL RESULTS:  CFSR'];
else
    varbtxt=['T_{mean}  [s]'];
end
clf;
xlabtxt=['BUOY ',varbtxt];
ylabtxt=['MODEL ',varbtxt];
titl1=['FEMA LAKE MICHIGAN EXTREME STORMS STUDY'];
titl3=['Binned Mean Error to:  Symmetric Regression for: ',buoystn];
titl4=['Evaluation START: ', int2str(yrstrt),'  END: ' ,int2str(yrend)];
titl5=['Total Number of Observations:  ',int2str(length(buoyin))];
titlT=[{titl1};{titl2};{titl3};{titl4};{titl5}];% load in buoy data
%
%  Set up the 2-D matrix for contour plotting
%
ig=find(buoyin > 0);
buoy=buoyin(ig);
model=modelin(ig);

maxx=max(buoy);
maxy=max(model);
tprtot=length(buoy);

resol=0.1;
invtres=1/resol;
maxx=ceil(invtres*maxx)/invtres;
maxy=ceil(invtres*maxy)/invtres;

nx=ceil(maxx/resol);
ny=ceil(maxy/resol);
%
mapvarb(nx+1,ny+1)=NaN;
%
%  Buoy  time paired data set is buyhs   defined as X
%  Model time paired data set is modhs   defined as Y
%  Find the loop max for processing (doesn't matter which one)
%
%  Generate the symmetric regression  (csu)
%   Linear regression with forced "0" intercept.
%  Calculate the RMSE for the 95% confidence Bands
%
csu=sqrt(sum(model.^2) / sum(buoy.^2));

bbias=mean(model - buoy);
rmse=sqrt(sum ( ( model - buoy - bbias).^2 ) / tprtot );
%
%  Generate the 2-D maphs file for contouring
%   Place the Number of observations in each category
%
for nn=1:tprtot
iloc=ceil(buoy(nn)/resol) + 1;
jloc=ceil(model(nn)/resol) + 1;
mapvarb(iloc,jloc) = mapvarb(iloc,jloc) + 1;
end
%
%  Scaling to the maximum number of observations
%   occurring in the 2-D map matrix..
%  This should provide 0-1.0 scaling of the 
%  contour levels.
%
maxmap=max(max(mapvarb));
mapvarb=mapvarb/maxmap;
xxx=0:resol:maxx;
yyy=0:resol:maxy;
maxxy=ceil(max(max(maxx),max(maxy)));

[x2,y2] = meshgrid(xxx,yyy);
contour(x2',y2',mapvarb,100)
axis([0, maxxy, 0 maxxy]);
axis('square')

colorbar
grid
hold


llimy=-1.96*rmse;
llimy2=csu*maxx+llimy;
ulimy=1.96*rmse;
ulimy2=csu*maxx+ulimy;
H=plot([0 maxxy],[0 maxxy],'r',[0 maxx],[0 csu*maxx],'b',...
    [0 maxx],[llimy,llimy2],'m--',[0 maxx],[ulimy,ulimy2],'m--');
legend(H,'Perfect Fit','Linear Regression','95% Confidence Limit',...
    '95% Confidence Limit','Location','SouthEast');

obx=ceil(maxx/2. + 1);
oby=obx;
slpe=sprintf('Y=%5.3f X',csu);
text(obx,oby,slpe,'Rotation',45,'Fontweight','Bold');

xlabel(xlabtxt,'FontWeight','Bold');
ylabel(ylabtxt,'FontWeight','Bold');
title(titlT,'FontWeight','Bold');

eval(['print -dpng -r600 ContpltALL_',buoystn,'_',varb]); 
