function get_WIS_MICHIGAN(outfile,varargin)
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

if isunix
    dirf = '/mnt/CHL_WIS_1/';
    slash = '/';
else
    dirf = 'X:\';
    slash = '\';
end


% subgrid identifier
subgrid = '';
%year = outfile(end-6:end-3);
%mon = outfile(end-1:end);
% identifies location of files on raid (Change for specific basin)
    if strcmp(storm,'blah')
        get_file = [dirf,'LAKE_MICHIGAN',slash,'Production',slash,'Model' ...
            slash,year,'-',mon,slash];
        get_ice = [dirf,'LAKE_MICHIGAN',slash,'ICE',slash,year,slash, ...
            year(3:4),mon,slash];
    else
        get_file = [dirf,'LAKE_MICHIGAN',slash,'Production',slash,'Model', ...
            slash,storm,slash];
        get_ice = [dirf,'LAKE_MICHIGAN',slash,'Production',slash,'Ice',slash];
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

fillm = 1;
iceC = '000';

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
    if strcmp(storm,'blah')
        fice = dir([get_ice,'*',year,'-',mon,'.CUM']);
        if ~isempty(fice)
            copyfile([get_ice,'*',year,'-',mon,'*.CUM'],'.');
            iceC = '70C';
        end
    else
        fice = dir([get_ice,'*',storm,'*CUM']);
        if ~isempty(fice)
            copyfile([get_ice,fice(1).name]);
            iceC = '70C';
        end
    end
%     fftgz = dir('WIS*.tgz');
%     if isempty(fftgz)
%         fftgz = dir([year,'_',mon,'*.tgz']);
%     end
%     for jtgz = 1:size(fftgz,1)
%         tgend = fftgz(jtgz).name(end-6:end);
%         newname = [year,mon,'_WIS_MICHIGAN_WAM451C_CFSR_',year, ...
%             '_',mon,'_',tgend];
%         system(['mv ',fftgz(jtgz).name,' ',newname]);
%     end
    %copyfile([get_file,'*_MMd.tgz'],'.');
    %copyfile([get_onlns,'/',year,'-',mon,'/*.tgz'],'.');
    % run ww3_read (change grid identifier to basin)
   % wis_read('MICHIGAN',year,mon,'/',fillm,'iceC',iceC)
    wis_read('MICHIGAN','/',fillm,'iceC',iceC,'storm', ...
        storm,'year',year,'mon',mon)
    
end
% runs basin specific archiving 
%archive_michigan(year,mon);
%system(['rm -rf ',outfile]);
end
