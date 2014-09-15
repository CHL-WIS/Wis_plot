function move_2_thredds(yr,mon,basin,fdir)

cd(fdir)
%system('tar -xzvf *wis_points.tgz')

rdir = ['/mnt/data/wis/',basin,'/',yr,'-',mon];
mkd = ['ssh rdextth9@134.164.23.50 "mkdir ',rdir,'"'];
system(mkd);

myfile = ['scp ',fdir,'/*wis_points.tgz rdextth9@134.164.23.50:',rdir];
system(myfile);

untf = ['ssh rdextth9@134.164.23.50 "cd /mnt/data/wis/',basin,'/',yr,'-',mon,' ; ', ...
    'tar xzf *wis_points.tgz"'];
system(untf);

rmff = ['ssh rdextth9@134.164.23.50 "cd /mnt/data/wis/',basin,'/',yr,'-',mon,' ; ', ...
    'rm *.tgz"'];
system(rmff);
%system('rm *.nc')

  	