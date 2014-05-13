function ww3_read_PAC
%ftp_trans_ww3
 title1 = ['Pacific Hindcast Study [OWI Winds]'];
 plotloc = '/home/thesser1/My_Matlab/Wis_plot/PAC/';
 rdir = '/mnt/CHL_WIS_1/';
 
files1 = dir('*MMt.tgz');
filename1 = getfield(files1,'name');
%dirname = [filename1(1:4),'-',filename1(5:6)];
% if ~exist(dirname,'dir')
%     mkdir(dirname)
% end
% movefile('*.tgz',dirname);
% cd(dirname)
untar(filename1);
fid = fopen('Max-mean-ww3.dat');
data = textscan(fid,'%f%f%f%f%f%f%f%f',1);
lonw = data{3};lone = data{4};
lats = data{6};latn = data{7};
res = (lone-lonw)./(data{5}-1);
% files2 = dir('*spec.tgz');
% untar(files2.name);
% 
% mkdir('Spectra');
% files3 = dir('*spec-buoy.tgz');
% copyfile(files3.name,'Spectra');
% cd('Spectra');
% untar(files3.name);
% cd ../

storm = 'Pacific';
%storm = 'Gtest';
%track = 'North';

%if size(filename1,2) > 27
%    modelnm = ['WW3-OWI'];
%    track = [filename1(1:4),'-',filename1(5:6)];
%else
    modelnm = 'WW3-OWI';
    track = [filename1(1:4),'-',filename1(5:6)];
    bbop = pwd;
    ii = strfind(bbop,'grd');
    level = bbop(ii:end);
    track = [track,'-',level];
%end

ww3_cont_PAC(storm,track,modelnm,plotloc)
loc = pwd;

% timeseries_get(filename1(1:4),filename1(5:6),level, ...
%    '/home/thesser1/Pacific/WW3_multi_tst/',plotloc,rdir,'PAC')


%or_val_set(filename1(1:4),filename1(5:6));
%cd('C:/IMEDS 3.1/src/process');
%imeds

% date1 = [filename1(1:6),'01000000'];
% mon2 = str2double(filename1(5:6)) + 1;
% year2 = str2double(filename1(1:4));
% if mon2 > 12
%     mon2 = 1;
%     year2 = str2double(filename(1:4)) + 1;
% end
% if mon2 < 10
%     mon2s = ['0',num2str(mon2)];
% else
%     mon2s = num2str(mon2);
% end
% date2 = [num2str(year2),mon2s,'01000000'];
% alt_data = read_alt(date1,date2,lonw,lone,lats,latn,res);
% ww3_alt(alt_data,loc);
% close all
% delete ww3.*.hs
