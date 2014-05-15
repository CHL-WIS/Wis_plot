function taylordiagram_v2_station(data,inpath,varargin)
%,dt,modeldur)
% TAYLORDIAGRAM_v1
% Plot a Taylor diagram from statistics
% Inputs:
%   inpath - folder of simulation
%   dt - model timestep (minutes)
%   modeldur - modeling duration (days)
%
% REF: 	K. Taylor
%		Summarizing multiple aspects of model performance in a single diagram
%		Journal of Geophysical Research-Atmospheres, 2001, V106, D7.
%
% Modifed from the function written by Guillaume Maze and obtained on the
% MathWorks File Exchange website on 4/23/2014.
% (http://www.mathworks.com/matlabcentral/fileexchange/20559-taylor-diagram).
% Copyright (c) 2008 Guillaume Maze.
% http://codes.guillaumemaze.org
% All rights reserved.
%
% The code originally compares observation time series with different
% reanalysis data (multiple model runs, one observation). The code was
% modifed to compare multiple stations, in which for each of them is a comparison
% between observation and model data. The standard deviation is normalized by the
% observed data standard deviation so there is a single reference point along the x-axis
%(correlation coefficient = 1, STD = 1, RMS = 0) rather than a point for each observation.
%
% Required functions:
%   allstats.m (http://code.google.com/p/guillaumemaze/wiki/matlab_codes_statistics_allstats)
%	ptable.m (http://code.google.com/p/guillaumemaze/wiki/matlab_codes_graphicxPlots_ptable)
%   define_taylordiag_axis.m
%
% Each of these inputs are one dimensional with same length. Row 1 corresponds
% to the statistics of reference series (observations - should be normalized).
% Row 2 correspsonds to the statisrics of the model series. Each column is a different station.
%
% Note that by definition the following relation must be true for all series i:
% RMSs(i) - sqrt(STDs(i).^2 + STDs(1)^2 - 2*STDs(i)*STDs(1).*CORs(i)) = 0
% This relation is checked and if not verified an error message is sent (see
% reference for more information).
p = inputParser;
p.addRequired('data');
p.addRequired('inpath');
p.addRequired('simname');
%p.addRequired('varb');
p.addOptional('fplt',0);
p.addOptional('splt',0);
parse(p,data,varargin{:});

fplt = p.Results.fplt;
splt = p.Results.splt;

if fplt > 0
    figure(fplt)
elseif splt > 0
    subplot(splt)
end


%set(0,'ShowHiddenHandles','on')
%delete(get(0,'Children'))

% folders = dir(inpath);
% folders = folders([folders.isdir]);
% folders(strncmp({folders.name}, '.', 1)) = [];
% 
% folcmap=hsv(numel(folders));

counter=0;
% dt=dt*60;
% modeldur=modeldur*86400;
% 
% modsteps=ceil((modeldur/dt)*0.2);

% for k=1:numel(folders)
%     Npan(k)=1;
%     foldat=folders(k).name;
%    files=dir(fullfile(inpath,foldat,'timepair*.mat'));
%     folhleglabel{k}=foldat;
%files=dir(fullfile(inpath,'timepair*.mat'));
f1 = fieldnames(data.buoy);
files = f1(1:end);
folcmap = hsv(numel(files));
%folcmap(1,1:3) = [0 0 0];
%folcmap(2:length(folcmap2)+1,:) = folcmap2;
for kk=1:1%numel(files) %Looping over *.timepair files in the directory
    tfile=files{kk};
    Npan(kk) = 1;
    foldat = files{kk};
    folhleglabel{kk} = foldat;
    %        data=load(fullfile(inpath,foldat,tfile));
    %        data = load(fullfile(inpath,tfile));
    buoy=data.buoy.(tfile)(:,4);
    model=data.model.(tfile)(:,4);
    ind=find(tfile=='.');
    bname=tfile(ind-5:ind-1);
    
    ind=buoy>0;
    buoy(~ind)=NaN;
    clear ind;
    
    ind=model>0;
    model(~ind)=NaN;
    clear ind;
    
%     if length(find(isfinite(buoy)==1))<=modsteps || length(buoy)<=modsteps
%         disp(['Observation length of ',bname,' too short for comparison'])
%         continue
%     end
    counter=counter+1;
    
    C = allstats(buoy,model); %col 1 - observation, col2 - model (mean,std,rms,cor)
    statm(1,:) = C(:,1); %observation
    statm(2,:)= C(:,2); %model
    
    STDs=statm(:,2)/statm(1,2); %normalized by STD of observation
    RMSs=statm(:,3)/statm(1,2); %normalized by STD of observation
    CORs=statm(:,4);
    
    if find(CORs<0)
        Npan(k) = 2; % double panel
    end
    
    %Check input
    apro = 100;
    di   = fix(RMSs*apro)/apro - fix(sqrt(STDs.^2 + STDs(1)^2 - 2*STDs*STDs(1).*CORs)*apro)/apro;
    
    if find(di~=0)
        ind=find(di~=0);
        a=fix(RMSs(ind)*apro)/apro;
        b = fix(sqrt(STDs(ind).^2 + STDs(1)^2 - 2*STDs(ind)*STDs(1).*CORs(ind))*apro)/apro;
        error('You must have:RMSs(%i) - sqrt(STDs(%i).^2 + STDs(1)^2 - 2*STDs(%i)*STDs(1).*CORs(%i)) = 0 and it''s equal to: %0.3f - %0.3f = %0.3f !',ind,ind,ind,ind,a,b,di(ind));
    end
    
    %In polar coordinates
    rho(:,counter)=STDs;
    theta(:,counter)=real(acos(CORs));
    dx(1,counter)=rho(1,counter); %observed STD
    %color(counter,:)=folcmap(k,:);
    color(counter,:)=folcmap(kk,:);
    ptlabel{counter}=bname;
    cutoff(1,kk)=counter;
    gridname{kk} = files{kk};
end
%     cutoff(1,k)=counter;
%     %dind=find(tfile=='-');
%     %simname=tfile(dind(1)+1:dind(end)-1);
%     gridname{k}=strcat(simname,'_',foldat);
%end
%girdname{1} = 'Level1'

clear dind

dind=find(inpath=='/');
folsimname=inpath(dind(end)+1:end);

%Plot individual points for each grid
%for j=1:numel(folders)
% for j = 1:numel(files)
%     if j==1
%         ind=1:cutoff(j);
%     else
%         ind=cutoff(j-1)+1:cutoff(j);
%     end
%     
%     [cax]=define_taylordiag_axis(rho(:,ind),dx(:,ind),Npan(j),'titleRMS',0);
%     cmap=hsv(length(ind));
%     colcount=1;
%     ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
%     plot(rho(1,1)*cos(theta(1,1)),rho(1,1)*sin(theta(1,1)),'Marker','.','Color','k','MarkerSize',20);
%     [m,n]=size(rho);
%     
%     for jj=ind
%         pp(colcount)=plot(rho(m,jj)*cos(theta(m,jj)),rho(m,jj)*sin(theta(m,jj)),'Marker','.','Color',cmap(colcount,:),'MarkerSize',15);
%         if colcount<=26
%             tt(colcount)=text(rho(m,jj)*cos(theta(m,jj)),rho(m,jj)*sin(theta(m,jj)),ALPHABET(colcount),'color','r');
%             hleglabel(colcount)=strcat(ALPHABET(colcount), ': ',ptlabel(jj));
%         elseif colcount<=26*2
%             tt(colcount)=text(rho(m,jj)*cos(theta(m,jj)),rho(m,jj)*sin(theta(m,jj)),lower(ALPHABET(colcount-26)),'color','r');
%             hleglabel(colcount)=strcat(lower(ALPHABET(colcount-26)), ': ',ptlabel(jj));
%         else
%             error('How to handle that many observations?');
%         end
%         colcount=colcount+1;
%     end
%     
%     hleg=legend(pp,hleglabel,'FontSize',6,'Location','EastOutside');
%     set(hleg,'Box','off','Color','none');
%     set(tt,'verticalalignment','bottom','horizontalalignment','right');
%     set(tt,'fontsize',8);
%     
%     titl1=strcat(simname,'-',foldat);
%     c=clock;
%     cdate=datestr(c,'mmmm dd, yyyy HH:MM AM');
%     titl3=['Date Plotted: ',cdate];
%     titchT=[{titl1},{titl3}];
%     title(titchT,'FontWeight','Bold')
%     
%     ff2 = fullfile(['TaylorDiagram-',gridname{j}]);
%     saveas(gcf,ff2,'png');
%     delete(pp)
%     clear pp
%     delete(tt)
%     clear tt
%     delete(hleg)
%     clear hleg
%     clear hleglabel
%     hold off
%     
%     set(0,'ShowHiddenHandles','on')
%     delete(get(0,'Children'))
% end
if find(Npan==2)
    [cax2]=define_taylordiag_axis(rho,dx,2,'titleRMS',0);
else
    [cax2]=define_taylordiag_axis(rho,dx,1,'titleRMS',0);
end
[m,n]=size(rho);
plot(rho(1,1)*cos(theta(1,1)),rho(1,1)*sin(theta(1,1)),'Marker','x','Color','k','MarkerSize',8,'LineWidth',2);
pp=zeros(1,n);
for jj=1:n
    pp(jj)=plot(rho(m,jj)*cos(theta(m,jj)),rho(m,jj)*sin(theta(m,jj)),'Marker','.','Color',color(jj,:),'MarkerSize',15);
end
hleg=legend(pp(cutoff),folhleglabel,'FontSize',6,'Location','EastOutside');
set(hleg,'Box','off','Color','none')
%titl1=(simname);
%titl2=['Stations Processed: ',num2str(n)];
%c=clock;
%cdate=datestr(c,'mmmm dd, yyyy HH:MM AM');
%titl3=['Date Plotted: ',cdate];
%titchT=[{titl1},{titl2},{titl3}];
%title(titchT,'FontWeight','Bold')

%ff3 = fullfile(['TaylorDiagram-',folsimname]);
%saveas(gcf,ff3,'png');
end

