function run_monthly_sum_plots(fdir,varargin)
%
%   run_bob_plots  
%      created by TJ Hesser 05/15/2014
%
%   description: creates 4 panel plot of statistics for large data sets in
%   WIS.
%
%   INPUT:
%     fdir        STRING             : directory where *.mat files reside
%     project     OPT STRING         : project name for full project analysis
%     storm       OPT STRING         : storm name for only a single storm
%                                        analysis
%     level       OPT STRING         : level name for only analyzing one
%                                        level
%     fout        OPT STRING         : directory for creating plot (default
%                                        = fdir)
%     stormid     OPT STRING         : tag to identify specific storm
%                                        directories, ie TP or ET
%     stname      OPT STRING         : name for title of stormid tags
%
% --------------------------------------------------------------------------
p = inputParser;
p.addRequired('fdir');
p.addOptional('project','');
p.addOptional('storm','');
p.addOptional('level','');
p.addOptional('fout',fdir);
p.addOptional('stormid','');
p.addOptional('stname','');
p.addOptional('year1',0000);
p.addOptional('year2',0000);
p.addOptional('excep','');
p.addOptional('buoyloc','');
p.addOptional('coord',[-180 180 -70 70]);
parse(p,fdir,varargin{:});

fout = p.Results.fout;
level = p.Results.level;
project = p.Results.project;
storm = p.Results.storm;
stormid = p.Results.stormid;
stname = p.Results.stname;
year1 = p.Results.year1;
year2 = p.Results.year2;
excep = p.Results.excep;
buoyloc = p.Results.buoyloc;
coord = p.Results.coord;
if isunix
    slash = '/';
else
    slash = '\';
end
month = {'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'};

data = conc_monthly_files(fdir,'level',level,'year1',year1,'year2',year2,'excep',excep);

f = figure(1);
clf
set(f,'units','inches');
set(f,'Position',[0 0 11 8.5]);
set(f,'papersize',[11 8.5]);
set(f,'PaperPosition',[0 0 11 8.5]);
set(f,'PaperPositionMode','manual');
%orient Rotated
ii = data.buoy.total(:,4) > 0;

%binave(data.buoy.total(ii,4),data.model.total(ii,4),'Hs','splt',subplot(2,2,1))
binave_test(data.buoy,data.model,'Hs','splt',subplot(2,2,1))

if ~strcmp(buoyloc,'')
    ff = dir([buoyloc,'/*.locs']);
    if ~isempty(ff)
        for jj = 1:size(ff,1)
            aa = load([buoyloc,'/',ff(jj).name]);
            bloc(jj,1:2) = [aa(1,1) aa(1,2)];
            bloc(jj,3) = str2num(ff(jj).name(2:6));
        end
    else
        ff = dir([buoyloc,'/*',level,'*buoy.mat']);
        load(ff(1).name);
        bloc(:,1:3) = buoy(:,1:3);
    end
    dd = [abs(coord(4)-coord(3)),abs(coord(1) - coord(2))];
    cdiff = dd(1)/dd(2);
    if cdiff < 0.70 | cdiff > 0.90
        [mside,id] = max(dd);
        if id == 1
            ddiff = (mside - dd(2))/2;
            coord(1) = coord(1) - ddiff;
            coord(2) = coord(2) + ddiff;
        else
            ddiff = (mside - dd(1))/2;
            coord(3) = coord(3) - ddiff;
            coord(4) = coord(4) + ddiff;
        end
    end
        ii = ismember(bloc(:,3),data.bname);
    map_point(bloc(ii,1:3),coord,'splt',subplot(2,2,2))
else
    contrplt(data.buoy.total(ii,4),data.model.total(ii,4),'Hs','splt',subplot(2,2,2))
end

subplot(2,2,3)
hold on
folcmap = hsv(numel(1:12));
for jj = 1:12
    ii = data.buoy.(month{jj}).total(:,4) > 0;
    hh(jj) = QQ_plot(data.buoy.(month{jj}).total(ii,4),data.model.(month{jj}).total(ii,4),'Hs','splt',subplot(2,2,3), ...
        'color',folcmap(jj,:),'symbol','.');
end
hh(jj+1) = QQ_plot(data.buoy.total(ii,4),data.model.total(ii,4),'Hs','splt', ...
    subplot(2,2,3),'color',[0 0 0],'symbol','.');
lloc = legend(hh,'January','Febuary','March','April','May','June','July',...
    'August','September','October','November','December','Total');

sc = taylordiagram_v2_station(data,fdir,'splt',subplot(2,2,4));

%orient Rotated
subplot(2,2,3)
ll = get(lloc,'position');
%ll(1:2) = [0.4355 0.1096];
ll(1:2) = [0.45 0.457];
set(lloc,'position',ll);
%legend BOXOFF


figure(1)
set(gcf,'NextPlot','add');
axes;
if strcmp(stname,'')
    stname = 'total';
end
tit1 = [project,'-',storm,'-',level,'-',stname,': Years = ', ...
    num2str(year1),'-',num2str(year2)];
tit2 = ['No. of Locs = ',num2str(size(data.bname,2))];
%tit2 = ['No. storms = ',num2str(data.numstorms)];
tit1 = strrep(tit1,'--','-');
tit = {tit1;tit2};
h = title(tit,'fontweight','bold','fontsize',14);
set(gca,'Visible','off');
set(h,'Visible','on');
fname = [fout,slash,'test_',project,'_',storm,'_',level,'_',num2str(year1),...
    '_',num2str(year2),'.png'];
fname = strrep(fname,'__','_');
print(gcf,'-dpng','-r600',fname);
close(gcf)