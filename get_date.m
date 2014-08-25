function [date,res,type] = get_date

files1 = dir('*MMf.tgz');
if size(files1,1) ~= 0
    untar(files1.name);
    nc = dir('wis*.nc');
    datetime = double(ncread(nc.name,'/datetime'));
    date = [datetime(1,1) datetime(2,1) datetime(3,1) datetime(1,end) ...
        datetime(2,end) datetime(3,end)];
    lon = double(ncread(nc.name,'/longitude'));
    res = lon(2) - lon(1);
    type = '*.nc';
else
    
    %finds name of MMt.tgz file
    files1 = dir('*MMt.tgz');
    if size(files1,1) == 0
        files1 = dir('*MMd.tgz');
    end
    filename1 = getfield(files1,'name');
    % untar MMt.tgz file
    untar(filename1);
    % read in Max-mean file (file name needs to change depending on model)
    ffn = dir('Max*.dat');
    fid = fopen(ffn.name);
    data = textscan(fid,'%f%f%f%f%f%f%f%f',1);
    fclose(fid);
    time1 = num2str(data{1});time2 = num2str(data{2});
    % identify lat and lon coordinates from header
    if ~isempty(strfind(ffn.name,'ww3'))
        lonw = data{3};
        lone = data{4};
        nlon = data{5};
        lats = data{6};
        latn = data{7};
        nlat = data{8};
        res = (latn - lats)/(nlat-1);
    else
        res = data{3};
        lats = data{5};
        latn = data{6};
        lonw = data{7};
        lone = data{8};
        nlon = (lone - lonw)/res + 1;
        nlat = (latn - lats)/res + 1;
    end
    % grab year month
    year1 = str2double(time1(1:4));
    mon1 = str2double(time1(5:6));
    day1 = str2double(time1(7:8));
    year2 = str2double(time2(1:4));
    mon2 = str2double(time2(5:6));
    day2 = str2double(time2(7:8));
    date = [year1 mon1 day1 year2 mon2 day2];
    type = '*.onlns';
end