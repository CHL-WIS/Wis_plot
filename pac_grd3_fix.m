function pac_grd3_fix(yearmon)

coord = [230.0 245.0 30.0 50.0];
res = 0.0833;

form = ['%14i %6i %10.3f%10.3f%7.1f%5.0d.%8.2f%8.2f%8.2f', ...
    '%8.2f%8.2f%8.2f%8.2f%8.2f%8.2f%5.0f.%5.0f.%8.2f%8.2f', ...
    '%8.2f%8.2f%8.2f%8.2f%5.0f.%5.0f.%8.2f%8.2f%8.2f%8.2f', ...
    '%8.2f%8.2f%5.0f.%5.0f.\n'];

specform1 = ['%14i%8.2f%7.2f%5i%5i%8.4f%8.4f%8.4f\n']; 
specform2 = ['%6.2f%5.0f.%7.2f\n'];
specform3 = ['%6.2f%6.2f%6.2f%6.2f%6.2f%5.0f.%5.0f.\n'];


dirnew = '/home/thesser1/Pacific/Model/';
dirpl = '/mnt/CHL_WIS_1/Pacific/Production/Model/';
dirold = '/mnt/CHL_WIS_1/Pacific/Production/Model_Old/';

if ~exist([dirnew,yearmon],'dir')
    mkdir([dirnew,yearmon]);
end
cd([dirnew,yearmon])
system(['cp -rf ',dirold,yearmon,'/grd3 ',dirnew,yearmon,'/']);

dirsave = [dirnew,yearmon,'/',yearmon,'-onlns'];


%%% grd 4 onlns files
cd('grd3');
fnameone = dir('*ST-onlns.tgz');
untar(fnameone.name);

fnamespe = dir('*spec-buoy-fix.tgz');
untar(fnamespe.name);

fnames = dir('*.onlns');
for istat = 1:size(fnames,1)
    stat = str2double(fnames(istat).name(3:7));
    statn = stat;
    statc = num2str(statn);
    fprintf(1,'Old name %s, new string %s \n',fnames(istat).name(3:7),statc);

    
    %%% onlns files
    aa = load(fnames(istat).name);
%     aa(:,2) = statn;
%     
%     fid = fopen(['ST',statc,'.onlns'],'w');
%     for ij = 1:length(aa)
%         fprintf(fid,form,aa(ij,:));
%     end
%     fclose(fid);
%     delete(fnames(istat).name);
    
    
    %%% spectral files
    fnamespc = [fnames(istat).name(1:end-5),'spe2d'];
    
    bspec = read_WAM_spe2d(fnamespc);
%     specform4 = ['%8.4f%10.3f',repmat('%8.3f',1,bspec(1).na-1),'\n'];
%     fid = fopen(['ST',statc,'.spe2d'],'w');
%     for itime = 1:length(bspec)
%         fprintf(fid,specform1,bspec(itime).time,bspec(itime).lon, ...
%             bspec(itime).lat,bspec(itime).nf,bspec(itime).na, ...
%             bspec(itime).freq1,bspec(itime).dir1,bspec(itime).dird);
%         fprintf(fid,specform2,bspec(itime).u10,bspec(itime).udir, ...
%             bspec(itime).ustar);
%         fprintf(fid,specform3,bspec(itime).hs,bspec(itime).tp, ...
%             bspec(itime).tm,bspec(itime).tm1,bspec(itime).tm2, ...
%             bspec(itime).wdir,bspec(itime).wspr);
%         for ifreq = 1:bspec(itime).nf
%             fprintf(fid,specform4,bspec(itime).freq(ifreq),bspec(itime).ef2d(ifreq,:));
%         end
%  
%     end
%     fclose(fid);
%     delete(fnamespc);
    
%     if istat == 1
%         h5fname = [dirnew,yearmon,'/WIS-PAC-',yearmon,'.h5'];
% % %         h5dir = ['/time'];
% % %         h5create(h5fname,h5dir,[length(aa) 1]);
% % %         h5write(h5fname,h5dir,aa(:,1));
% %     end
%     
%     make_h5(h5fname,'grd3',fnames(istat).name(1:end-6),aa,bspec);
end
%   fpath = [dirnew,yearmon,'/grd3'];
%   make_h5_grd(h5fname,fpath,'grd3',coord,res)  

 %tar(fnameone.name,'*.onlns');
%delete *.onlns
 system(['mv ST*.onlns ',dirsave]); 
 %tar(fnamespe.name,'*.spe2d');
 %delete *.spe2d

