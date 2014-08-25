function data = read_wis_nc_var(var)

vars = ['/',var];
tarname = dir('*MMf.tgz');
untar(tarname.name)
nc = dir('*.nc');
data.lon = double(ncread(nc.name,'/longitude'));
data.lat = double(ncread(nc.name,'/latitude'));
data.max = double(ncread(nc.name,[var,'_','max']))';
data.mean = double(ncread(nc.name,[var,'_','mean']))';
data.res = data.lon(2)-data.lon(1);
data.time = double(ncread(nc.name,'/datetime'));
%mask = ncread(nc.name,'/mask');

% if strcmp(var,'wndspd')
%     uwndfull = double(ncread(nc.name,'/wnd_u'));
%     uwnd_mfac = ncreadatt(nc.name,'/wnd_u','mfactor');
%     uwnd = uwndfull*uwnd_mfac;
%     vwndfull = double(ncread(nc.name,'/wnd_v'));
%     vwnd_mfac = ncreadatt(nc.name,'/wnd_v','mfactor');
%     vwnd = vwndfull*vwnd_mfac;
%     data.(var) = zeros(size(uwnd));
%     for jj = 1:length(data.lat)
%         for ii = 1:length(data.lon)
%             if mask(ii,jj) == 0 | max(uwndfull(ii,jj,:)) < -500
%                 data.(var)(ii,jj,:) = -999;
%             else
%                 data.(var)(ii,jj,:) = sqrt(uwnd(ii,jj,:).^2 + ...
%                     vwnd(ii,jj,:).^2);
%             end
%             
%         end
%     end
% else
%     data.(var) = double(ncread(nc.name,vars));
%     data_mfac = ncreadatt(nc.name,vars,'mfactor');
%     data.(var) = data.(var)*data_mfac;
% end
% 
% data.max = zeros(size(mask'));
% data.mean = zeros(size(mask'));
% for jj = 1:length(data.lat)
%     for ii = 1:length(data.lon)
%         inan = data.(var)(ii,jj,:) >= 0;
%         if length(data.(var)(ii,jj,inan)) < 1
%             if mask(ii,jj) == 0
%                 data.max(jj,ii) = -1;
%                 data.mean(jj,ii) = -1;
%             else
%                 data.max(jj,ii) = 0;
%                 data.mean(jj,ii) = 0;
%             end
%         else
%             data.max(jj,ii) = max(data.(var)(ii,jj,inan));
%             data.mean(jj,ii) = mean(data.(var)(ii,jj,inan));
%         end
%     end
% end

%data.res = data.lon(2)-data.lon(1);
%data.time = double(ncread(nc.name,'/datetime'));

