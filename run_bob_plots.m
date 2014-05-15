function run_bob_plots(fdir,varargin)
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
parse(p,fdir,varargin{:});

fout = p.Results.fout;
level = p.Results.level;
project = p.Results.project;
storm = p.Results.storm;
stormid = p.Results.stormid;
stname = p.Results.stname;
if isunix
    slash = '/';
else
    slash = '\';
end

data = conc_mat_files(fdir,'project',project,'storm',storm,'level', ...
    level,'stormid',stormid);

figure(1)
clf

ii = data.buoy.total(:,4) > 0;

binave(data.buoy.total(ii,4),data.model.total(ii,4),'Hs','splt',subplot(2,2,1))

contrplt(data.buoy.total(ii,4),data.model.total(ii,4),'Hs','splt',subplot(2,2,2))

QQ_plot(data.buoy.total(ii,4),data.model.total(ii,4),'Hs','splt',subplot(2,2,3))

taylordiagram_v2_station(data,fdir,'splt',subplot(2,2,4))

orient Rotated
figure(1)
set(gcf,'NextPlot','add');
axes;
tit1 = [project,'-',storm,'-',level,'-',stname];
tit2 = ['No. storms = ',num2str(data.numstorms)];
tit1 = strrep(tit1,'--','-');
tit = {tit1;tit2};
h = title(tit,'fontweight','bold','fontsize',14);
set(gca,'Visible','off');
set(h,'Visible','on');
fname = [fout,slash,'test_',project,'_',storm,'_',level,'.png'];
fname = strrep(fname,'__','_');
print(gcf,'-dpng','-r600',fname);