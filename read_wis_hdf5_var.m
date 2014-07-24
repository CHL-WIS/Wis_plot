function data = read_wis_hdf5_var(var)

vars = ['/',var];
tarname = dir('*field.tgz');
untar(tarname.name)
h5 = dir('*.h5');
data.lon = double(h5read(h5.name,'/longitude'));
data.lat = double(h5read(h5.name,'/latitude'));
mask = h5read(h5.name,'/mask');

if strcmp(var,'wndspd')
    uwndfull = double(h5read(h5.name,'/wnd_u'));
    uwnd_mfac = h5readatt(h5.name,'/wnd_u','Multiplication Factor');
    uwnd = uwndfull*uwnd_mfac;
    vwndfull = double(h5read(h5.name,'/wnd_v'));
    vwnd_mfac = h5readatt(h5.name,'/wnd_v','Multiplication Factor');
    vwnd = vwndfull*vwnd_mfac;
    data.(var) = zeros(size(uwnd));
    for jj = 1:length(data.lat)
        for ii = 1:length(data.lon)
            if mask(ii,jj) == 0 | max(uwndfull(ii,jj,:)) < -500
                data.(var)(ii,jj,:) = -999;
            else
                data.(var)(ii,jj,:) = sqrt(uwnd(ii,jj,:).^2 + ...
                    vwnd(ii,jj,:).^2);
            end
            
        end
    end
else
    data.(var) = double(h5read(h5.name,vars));
    data_mfac = h5readatt(h5.name,vars,'Multiplication Factor');
    data.(var) = data.(var)*data_mfac;
end

data.max = zeros(size(mask'));
data.mean = zeros(size(mask'));
for jj = 1:length(data.lat)
    for ii = 1:length(data.lon)
        inan = data.(var)(ii,jj,:) >= 0;
        if length(data.(var)(ii,jj,inan)) < 1
            if mask(ii,jj) == 0
                data.max(jj,ii) = -1;
                data.mean(jj,ii) = -1;
            else
                data.max(jj,ii) = 0;
                data.mean(jj,ii) = 0;
            end
        else
            data.max(jj,ii) = max(data.(var)(ii,jj,inan));
            data.mean(jj,ii) = mean(data.(var)(ii,jj,inan));
        end
    end
end

data.res = data.lon(2)-data.lon(1);
data.time = double(h5read(h5.name,'/datetime'));

