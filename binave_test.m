function binave_test(bb,mm,varb,varargin)
%function binave(buoy,model,yrstrt,yrend,buoystn,varb)
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
p.addRequired('bb');
p.addRequired('mm');
p.addRequired('varb');
p.addOptional('fplt',0);
p.addOptional('splt',0);
parse(p,bb,mm,varb,varargin{:});

fplt = p.Results.fplt;
splt = p.Results.splt;

if fplt > 0
    figure(fplt)
elseif splt > 0
    subplot(splt)
end

if varb(1:2) == 'Hs'
    varbtxt=['H_{mo} [m]'];
    colm = 4;
elseif varb(1:2) == 'Tp'
    varbtxt=['T_{p}  [s]'];
elseif varb(1:2) == 'U1'
    varbtxt=['U_{10} [m/s]'];
else
    varbtxt=['T_{mean}  [s]'];
end
xlabtxt=['BUOY ',varbtxt];
%xlabtxt=['CFSR ',varbtxt];
ylabtxt=['MODEL ',varbtxt];
%ylabtxt=['CFSR ',varbtxt];
%titl1=['LAKE MICH 20-yr HINDCAST STUDY'];
%titl1=['Lake St. Clair CFSR STUDY'];
%titl2=['MODEL RESULTS:  WAM 4.5.1C'];
%titl3=['Binned Mean Error to:  Symmetric Regression for: ',buoystn];
%titl4=['Evaluation START: ', int2str(yrstrt),'  END: ' ,int2str(yrend)];
%titl5=['Total Number of Observations:  ',int2str(length(buoy))];
%titlT=[{titl1};{titl2};{titl3};{titl4};{titl5}];
%
%  Generate the symmetric regression  (csu)
%   Linear regression with forced "0" intercept.
%  Calculate the RMSE for the 95% confidence Bands
%
if isstruct(bb)
    ii = bb.total(:,colm) > 0;
    buoy = bb.total(ii,colm);
    model = mm.total(ii,colm);
    files = {'jan','feb','mar','apr','may','jun','jul','aug','sep','oct', ...
        'nov','dec'};
    folcmap = hsv(numel(files(1:end)));
end

maxval=max(max(buoy),max(model));
tprtot=length(buoy);
csu=sqrt(sum(model.^2) / sum(buoy.^2));

biaspr=mean(model - buoy);
rmse=sqrt(sum ( ( model - buoy - biaspr).^2 ) / tprtot );

%  Bin Averaged Plot with Error Bars
%
[p,s] = polyfit(buoy,model,1);
%
%   1.  Determine the transfer Coefs.
%   2.  Correct model results.
%   3.  Then Plot up the results.
%
% q = [-p(2)/p(1) 1/p(1)];
m8t = p(1)*buoy + p(2);
m88t = csu*buoy;
% plot(buoy,m88t,'.',buoy,m8t,'g+',[0 ceil(maxval)], [0 ceil(maxval)],'r--')
% axis('square')
% grid
%clf
%
%  Check Corrected Data now slope = 1
%
[r,t] = polyfit(model,m8t,1);
xllim = 0.5;
xuplim = ceil(max(buoy)) - 0.5;
resoltp=0.25;
xrngt = xllim:resoltp:xuplim;
nbinst = length(xrngt);
%
%  This is for Symmetric Regression
%
for ibns=1:nbinst-1
    idt = find(buoy >= xrngt(ibns) & buoy < xrngt(ibns+1));
    if idt>0
        mvt(ibns)=(xrngt(ibns)+xrngt(ibns+1))/2;
        avet(ibns)=mean(model(idt));
        stt(ibns) = std(model(idt));
    else
        mvt(ibns) = NaN;
        avet(ibns)= NaN;
        stt(ibns) = NaN;
    end
end
%
%  Plot Error Bars
%
%plot(buoy,model,'g.',[0 ceil(maxval)], [0 ceil(maxval)],'b--')
hold on
for jj = 1:length(files)
    ii = bb.(files{jj}).total(:,4) > 0;
    plot(bb.(files{jj}).total(ii,4),mm.(files{jj}).total(ii,4),'.','Color',folcmap(jj,:));
end
plot([0 ceil(maxval)],[0 ceil(maxval)],'b--');
box on
set(gca,'xlim',[0 ceil(maxval)]);
set(gca,'ylim',[0 ceil(maxval)]);
%axes([0 0 max(xlim,ylim) max(xlim,ylim)])
%axis('equal')
axis('square');
pause(1)
ytick = get(gca,'ytick');
set(gca,'xtick',ytick);


grid
%hold on
errorbar(mvt,avet,stt,'ok','linewidth',1.0);
xlabel(xlabtxt,'FontWeight','Bold');
ylabel(ylabtxt,'FontWeight','Bold');
xpoint = get(gca,'xlim');
text(xpoint(2)/2,0,['No. of Obs. = ',num2str(length(buoy))],'Fontweight','Bold', ...
    'VerticalAlignment','bottom','HorizontalAlignment','center');
%title(titlT,'FontWeight','Bold');
%title(titl3,'FontWeight','Bold')
hold off
%eval(['print -dpng -r600 ScatpltALL_',buoystn,'_',varb]); 
