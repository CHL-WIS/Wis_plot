function get_WIS_HUR(outfile)
%
%   get_WIS_EXP
%     grabs data from raid and start the WIS post processing
%     created TJ Hesser
% 
%   INPUT: 
%     outfile   STRING : directory listing for local location of files
%                       including year-mon
%                        i.e. /home/thesser1/GOM/model/1996-01
%                        i.e. C:\GOM\model\1996-01
% -------------------------------------------------------------------------
subgrid = 'LEVEL';
if isunix
    % linux listing for raid
   get_file = ['/mnt/CHL_WIS_1/EXP/Evaluation/WW3/Model/',outfile(end-6:end),'/'];
else
    % Windows listing for raid
    gtop = ['Z:\LAKE_HURON\Production\WAM451C\'];
    get_file = [gtop,'Model\',outfile(end-6:end),'\'];
    ice_dir = [gtop,'Ice\'];
end
% creates local directory if not already made
if ~exist(outfile,'dir')
    mkdir(outfile);
end
% moves to local directory
cd(outfile);
% identies all sub grids for simulation (change these to match model
% output)
loc{1} = [outfile,'/LEVEL1'];
% loc{2} = [outfile,'/LEVEL2'];
% loc{3} = [outfile,'/LEVEL3W'];
% loc{4} = [outfile,'/LEVEL3C1'];
% loc{5} = [outfile,'/LEVEL3C2'];
% loc{6} = [outfile,'/LEVEL3E'];
% picks out year and month string for archiving
year = outfile(end-6:end-3);
mon = outfile(end-1:end);
iceC = '000';
fillm = 1;
% Loop through each subgrid to create Max-mean and time series plots
for zz = 1:length(loc)
    % creates subgrid directory if not already created
     if ~exist(loc{zz},'dir')
         mkdir(loc{zz});
     end
     % move to subgrid directory
    cd (loc{zz})
    % identify the sub grid identifier i.e. 3C1 after LEVEL (might need to
    % change subgrid identifier depending on file name)
%     ii = strfind(loc{zz},subgrid);
%     % copies Max-Mean file from raid to local directory
%     copyfile([get_file,subgrid,loc{zz}(ii+5:end),'/*-',subgrid, ...
%         loc{zz}(ii+5:end),'-MMt.tgz'],'.');
      copyfile([get_file,'\LEVEL1\*_MMd.tgz'],'.')
      copyfile([get_file,'\LEVEL1\*_onlns.tgz'],'.')
      icef = ([ice_dir,'\ICEFLD_',year,'_',mon,'.CUM']);
      if exist(icef,'file')
          copyfile(icef,'.');
          iceC = '70N';
      end
%     % file name for onlns tar file
%     fnamest = [get_file,subgrid,loc{zz}(ii+5:end),'/*-',subgrid, ...
%             loc{zz}(ii+5:end),'-ST-onlns.tgz'];
%     % check to see if onlns information is available for grid
%     blah = dir(fnamest);
%     if ~isempty(blah)
%         % if onlns information exist then copy to local subgrid directory
%         copyfile(fnamest,'.');
%     end
    % run ww3_read (change grid identifier to basin)
    wis_read('HUR',year,mon,'\',fillm,iceC)
    
end

% runs basin specific archiving 

archive_HUR(year,mon);
end
