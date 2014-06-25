function pac_grd1_fix(yearmon)

coord = [110.0 300.0 -64.0 64.0];
res = 0.5;

form = ['%14i %6i %10.3f%10.3f%7.1f%5.0d.%8.2f%8.2f%8.2f', ...
    '%8.2f%8.2f%8.2f%8.2f%8.2f%8.2f%5.0f.%5.0f.%8.2f%8.2f', ...
    '%8.2f%8.2f%8.2f%8.2f%5.0f.%5.0f.%8.2f%8.2f%8.2f%8.2f', ...
    '%8.2f%8.2f%5.0f.%5.0f.\n'];

specform1 = ['%14i%8.2f%7.2f%5i%5i%8.4f%8.4f%8.4f\n']; 
specform2 = ['%6.2f%5.0f.%7.2f\n'];
specform3 = ['%6.2f%6.2f%6.2f%6.2f%6.2f%5.0f.%5.0f.\n'];

dirnew = '/home/thesser1/Pacific/Model/';
dirpl = '/mnt/CHL_WIS_2/Pacific/Production/Model/';
dirold = '/mnt/CHL_WIS_2/Pacific/Production/Model_Old/';

if ~exist([dirnew,yearmon],'dir')
    mkdir([dirnew,yearmon]);
end
cd([dirnew,yearmon])
system(['cp -rf ',dirold,yearmon,'/grd1 ',dirnew,yearmon,'/']);

dirsave = [dirnew,yearmon,'/',yearmon,'-onlns'];
if ~exist(dirsave,'dir')
    mkdir(dirsave)
end

%%% grd 4 onlns files
cd('grd1');
newfiles = [dirnew,yearmon,'/grd1/new/'];
oldfiles = [dirnew,yearmon,'/grd1/old/'];
    mkdir(newfiles);
    mkdir(oldfiles);
fnameone = dir('*ST-onlns.tgz');
untar(fnameone.name);

fnamespe = dir('*spec-buoy-fix.tgz');
untar(fnamespe.name);

system(['mv *.onlns ',oldfiles]);
system(['mv *.spe2d ',oldfiles]);

fnames = load('/home/thesser1/PAC/fnames_cut.log');
filen = dir([oldfiles,'/*.onlns']);
%for istat = 1:size(fnames,1)
for istat = 1:size(filen,1)
    fprintf(1,'Working on file: %s \n',filen(istat).name)
    iloc = fnames(:,1) == str2num(filen(istat).name(3:7));
    if ~isempty(fnames(iloc,1))
        if fnames(iloc,2) == 99999
            fprintf(1,'Station %s was deleted as duplicate \n',num2str(filen(istat).name));
            continue
        end
        stat = fnames(iloc,1);
        statn = fnames(iloc,2);
        statc = num2str(statn);
        fprintf(1,'Old name %s, new string %s \n',num2str(fnames(iloc,1)),statc);
    else 
        if str2num(filen(istat).name(3:7)) < 81022 &  ...
                str2num(filen(istat).name(3:7)) >= 80000;
            fprintf(1,'Station %s was deleted as duplicate \n',num2str(filen(istat).name));
            continue
        end
        stat = str2num(filen(istat).name(3:7));
        statn = stat;
        statc = filen(istat).name(3:7);
        fprintf(1,'Station %s with no change of name \n',num2str(statc));
    end 
    %%% onlns files
    ff = [oldfiles,'ST',num2str(stat),'.onlns'];
    aa = load(ff);
    aa(:,2) = statn;
   
    
    fid = fopen([newfiles,'ST',statc,'.onlns'],'w');
    for ij = 1:length(aa)
        fprintf(fid,form,aa(ij,:));
    end
    fclose(fid);
    %delete(ff);
       
    %%% spectral files
    fnamespc = [oldfiles,'ST',num2str(stat),'.spe2d'];
    
    bspec = read_WAM_spe2d(fnamespc);
    specform4 = ['%8.4f%10.3f',repmat('%8.3f',1,bspec(1).na-1),'\n'];
    fid = fopen([newfiles,'ST',statc,'.spe2d'],'w');
    for itime = 1:length(bspec)
        fprintf(fid,specform1,bspec(itime).time,bspec(itime).lon, ...
            bspec(itime).lat,bspec(itime).nf,bspec(itime).na, ...
            bspec(itime).freq1,bspec(itime).dir1,bspec(itime).dird);
        fprintf(fid,specform2,bspec(itime).u10,bspec(itime).udir, ...
            bspec(itime).ustar);
        fprintf(fid,specform3,bspec(itime).hs,bspec(itime).tp, ...
            bspec(itime).tm,bspec(itime).tm1,bspec(itime).tm2, ...
            bspec(itime).wdir,bspec(itime).wspr);
        for ifreq = 1:bspec(itime).nf
            fprintf(fid,specform4,bspec(itime).freq(ifreq),bspec(itime).ef2d(ifreq,:));
        end
 
    end
    fclose(fid);
    %delete(fnamespc);
%     h5fname = [dirnew,yearmon,'/WIS-PAC-',yearmon,'.h5'];
%     if ~exist(h5fname,'file')
%         %h5fname = [dirnew,yearmon,'/WIS-PAC-',yearmon,'.h5'];
%         h5dir = ['/time'];
%         h5create(h5fname,h5dir,[length(aa) 1]);
%         h5write(h5fname,h5dir,aa(:,1));
%         h5writeatt(h5fname,h5dir,'Date_Form','yyyymmddhhmmss')
%         h5writeatt(h5fname,h5dir,'Date_Datum','UTC');
%         h5writeatt(h5fname,'/','Model_Name','WaveWatch III')
%         h5writeatt(h5fname,'/','Model_Version','Version 3 - ST4')
%         h5writeatt(h5fname,'/','Date_Created',date);
%         h5writeatt(h5fname,'/','Model_Run_By','Tyler J Hesser')
%         h5writeatt(h5fname,'/','Model_Run_Date','Unknown')
%         h5writeatt(h5fname,'/','Location','Pacific Basin')
%         h5writeatt(h5fname,'/','Data_Type','WIS Hindcast')
%         h5writeatt(h5fname,'/','Date_Datum','UTC')
% 	    h5writeatt(h5fname,'/','Data_Units','Metric')
%         h5writeatt(h5fname,'/','Direction_Convention','Meteorological, From Which')
%         h5writeatt(h5fname,'/','Wind_Data_Source','OceanWeather Inc, OWI')
% 	
%     end
%     
%     make_h5(h5fname,'grd1',['ST',statc],aa,bspec);
%     

end
    
%     fpath = [dirnew,yearmon,'/grd1'];
%     make_h5_grd(h5fname,fpath,'grd1',coord,res)
%     
%delete([oldfiles,'ST8*']);
%system(['mv ',oldfiles,'/ST* ',dirnew,yearmon,'/grd1']);
%system(['mv ',newfiles,'/ST* ',dirnew,yearmon,'/grd1']);

%tar(fnameone.name,'*.onlns');
%system(['mv ST*.onlns ',dirsave]);

%tar(fnamespe.name,'*.spe2d');
%delete *.spe2d

rmdir('new');
rmdir('old');
