function read_usgs_wtlv(fname)
fid = fopen('C:\Isaac\Buoy\Isaac_Stat_Id.txt');
data = textscan(fid,'%f%f%s%f');
fclose(fid);
buoyc = fname(5:11);

jj = find(strcmp(data{3},buoyc) == 1);
lon = data{1}(jj);
lat = data{2}(jj);
fid = fopen(fname);
data = fgetl(fid);
nn = 1;
coml = strfind(data,',');
while ~isempty(coml),
    usgsstat(nn,1) = str2num(data(1:coml(1)-1));
    for jj = 2:length(coml)
        if coml(jj-1) == coml(jj)-1
            foo{jj} = '-999';
        else
            foo{jj} = data(coml(jj-1)+1:coml(jj)-1);
        end
    end
    date{nn} = foo{2};
    wspd(nn,1) = str2num(foo{4});
    wdir(nn,1) = str2num(foo{6});
    pres(nn,1) = str2num(foo{8});
    wtlv(nn,1) = str2num(foo{10});
    nn = nn + 1;
    clear data
    data = fgetl(fid); 
    coml = strfind(data,',');
end
numdate = size(date,2);
for zz = 1:numdate
    [seg1,seg2] = strtok(date{zz},' ');
   [monc,dap] = strtok(seg1,'/');
   mon(zz,1) = str2num(monc);
   [dayc,dap] = strtok(dap,'/');
   day(zz,1) = str2num(dayc);
   [yearc,dap] = strtok(dap,'/');
   year(zz,1) = str2num(yearc);
   
   [hourc,dap] = strtok(seg2,':');
   hour(zz,1) = str2num(hourc);
   [minc,dap] = strtok(dap,':');
   min(zz,1) = str2num(minc);
end
time = datenum(year,mon,day,hour,min,0) + datenum(0,0,0,5,0,0);

wtlv = wtlv/3.281;
wspd = wspd/2.23694;

aa = struct('time',time,'stat',buoyc,'lon',lon,'lat',lat,'wtlv', ...
    wtlv,'wspd',wspd,'wdir',wdir,'pres',pres);

fout = ['w',fname(5:11),'-Isaac-full.mat'];
save(fout,'aa');
