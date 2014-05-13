function make_h5_grd(fname,fpath,grd,coord,res)


fgrd = ['/',grd,'/'];

vars = {'wvht_tot';'wdir_tot';'wvht_sea';'wvht_sw1';'wvht_sw2';'wind'};

longn = {'Total_Wave_Height';'Total_Wave_Direction';'WindSea_Wave_Height'; ...
    'Swell1_Wave_Height';'Swell2_Wave_Height';'Wind_Speed'};

units = {'m';'deg';'m';'m';'m';'m/s';'%'};

tarn = {'hss';'hdr';'sea';'sw1';'sw2';'wnd'};

for ivar = 1:size(vars,1)
    ff = dir([fpath,'/*',tarn{ivar},'.tgz']);
    if ivar == 1
     untar([fpath,'/',ff.name],fpath);
    
    files = dir([fpath,'/ww3.*']);
    for zz = 1:size(files,1)-1
        fid = fopen([fpath,'/',files(zz).name]);
        data = fgetl(fid);
        nlon = str2num(data(48:50));
        nlat = str2num(data(68:70));
        nmul = str2num(data(77:83));
%         if ivar == 1 & zz == 1
%             lonw = str2num(data(32:38));
%             lone = str2num(data(40:46));
%             lats = str2num(data(52:58));
%             latn = str2num(data(60:66));
%         end
               
        for jj = 1:nlat
            data = fscanf(fid,'%f',nlon);
            hs(jj,:) = data;
        end
        fclose(fid);
        
        field(:,:,zz) = hs*nmul;
    end
   delete ww3.*
    end
    h5create(fname,[fgrd,'/',vars{ivar}],[size(field)], ...
        'FillValue',-999.99,'Datatype','double');%,'ChunkSize',[10 10 10], ...
        %'Deflate',9);
    %h5create(fname,[fgrd,'/',vars{ivar}],[1 1],'FillValue',-999.99,'ChunkSize',[1 1],'Deflate',9);
    h5write(fname,[fgrd,'/',vars{ivar}],field);
    h5writeatt(fname,[fgrd,'/',vars{ivar}],'Long_Name',longn{ivar})
    h5writeatt(fname,[fgrd,'/',vars{ivar}],'Units',units{ivar});
    
end
h5writeatt(fname,fgrd,'grid_type','structured, geographic')
h5writeatt(fname,fgrd,'coord',coord)
h5writeatt(fname,fgrd,'resolution',res)
h5writeatt(fname,fgrd,'cell_numbers',[round(nlon) round(nlat)])
h5writeatt(fname,fgrd,'coord_unts','lonw,lone,lats,latn')
h5writeatt(fname,fgrd,'resolution_unts','degrees')
h5writeatt(fname,fgrd,'cell_number_unts','num_lon num_lat')
