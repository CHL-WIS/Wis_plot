function aa = read_OWI_winds(fname)

fid = fopen(fname);

data = textscan(fid,'%s%s%s%f%f\n',1);
aa.time1 = fix(data{4});
aa.time2 = fix(data{5});

data = fgetl(fid);
data = fgetl(fid);
aa.nlat = str2double(data(6:9));
aa.nlon = str2double(data(16:19));
aa.dlon = str2double(data(23:28));
aa.dlat = str2double(data(32:37));
aa.lat1 = str2double(data(44:51));
aa.lon1 = str2double(data(58:65));
tt(1,1) = str2double(data(69:end));

aa.lon = [aa.lon1:aa.dlon:aa.lon1+(aa.nlon-1)*aa.dlon];
aa.lat = [aa.lat1:aa.dlat:aa.lat1+(aa.nlat-1)*aa.dlat];

uwnd(:,:,1) = fscanf(fid,'%f',[aa.nlon,aa.nlat]);
vwnd(:,:,1)= fscanf(fid,'%f',[aa.nlon,aa.nlat]);

nn = 1;
while 1
    data = fgetl(fid);
    data = fgetl(fid);
    if data == -1 | strcmp(data,'')
        break
    end
    nn = nn + 1;
    tt(nn,1) = str2double(data(69:end));
    uwnd(:,:,nn) = fscanf(fid,'%f',[aa.nlon,aa.nlat]);
    vwnd(:,:,nn)= fscanf(fid,'%f',[aa.nlon,aa.nlat]);
    wnspd(:,:,nn) = sqrt(uwnd(:,:,nn).^2 + vwnd(:,:,nn).^2);
end

aa.time = tt;
aa.uwnd = uwnd;
aa.vwnd = vwnd;
aa.windspd = wnspd;
