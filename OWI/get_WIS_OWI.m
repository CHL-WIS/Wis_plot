function get_WIS_OWI(outfile,varargin)
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
p = inputParser;
p.addRequired('outfile');
p.addOptional('year','9999');
p.addOptional('mon','99');
p.addOptional('storm','blah');
parse(p,outfile,varargin{:});

year =p.Results.year;
mon = p.Results.mon;
storm = p.Results.storm;

% subgrid identifier
subgrid = '';
% identifies location of files on raid (Change for specific basin)
if isunix
    % linux listing for raid
   %get_file = ['/mnt/CHL_WIS_1/owi_work/model/',storm,'/'];
   get_file = ['/mnt/CHL_WIS_1/owi_work/WAMCY451C/',storm,'/Model/'];
   %get_ice = ['/mnt/CHL_WIS_1/LakeSuperior/Production/WAM451C/Ice/'];
else
    % Windows listing for raid
   get_file = ['Z:\owi_work\model\',storm,'\'];
end
% creates local directory if not already made
if ~exist(outfile,'dir')
    mkdir(outfile);
end
% moves to local directory
cd(outfile);
% identies all sub grids for simulation (change these to match model
% output)
loc{1} = [outfile];

fillm = 0;
iceC = '000';

%year = outfile(end-6:end-3);
%mon = outfile(end-1:end);
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
         if ~exist(get_file,'dir')
            return
        end
        copyfile([get_file,'*MMd.tgz'],'.');
        copyfile([get_file,'*onlns.tgz'],'.');
%         fice = dir([get_ice,'*',year,'_',mon,'.CUM']);
%         if ~isempty(fice)
%             copyfile([get_ice,'*',year,'_',mon,'*.CUM'],'.');
%             iceC = '70C';
%         end
        %copyfile([get_file,'*_MMd.tgz'],'.');
        %copyfile([get_file,'*-STNS_ONLNS.tgz'],'.');
    % run ww3_read (change grid identifier to basin)
    wis_read('OWI','/',fillm,'storm',storm,'year',year,'mon',mon)
    
end
% runs basin specific archiving 
% archive_superior(year,mon);
% system(['rm -rf ',outfile]);
end
