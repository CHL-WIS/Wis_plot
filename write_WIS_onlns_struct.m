function write_WIS_onlns_struct(fname,aa)

form = ['%14i %6i %10.3f%10.3f%7.1f%5.0d.%8.2f%8.2f%8.2f', ...
    '%8.2f%8.2f%8.2f%8.2f%8.2f%8.2f%5.0f.%5.0f.%8.2f%8.2f', ...
    '%8.2f%8.2f%8.2f%8.2f%5.0f.%5.0f.%8.2f%8.2f%8.2f%8.2f', ...
    '%8.2f%8.2f%5.0f.%5.0f.\n'];
alen = length(aa.wvht);
fid = fopen(fname,'w');
for ij = 1:alen
    tt = str2double(aa.timec(ij,:));
    fprintf(fid,form,tt,aa.stat,aa.lat,aa.lon, ...
        aa.u10(ij),aa.udir(ij),aa.ustar(ij),aa.cdrag(ij),aa.norm(ij), ...
        aa.wvht(ij),aa.tp(ij),aa.tpp(ij),aa.tm(ij),aa.tm1(ij),aa.tm2(ij), ...
        aa.wavd(ij),aa.wavs(ij),aa.whsea(ij),aa.tpsea(ij),aa.tppsea(ij), ...
        aa.tmsea(ij),aa.tm1sea(ij),aa.tm2sea(ij),aa.wdsea(ij),aa.wssea(ij), ...
        aa.whswe(ij),aa.tpswe(ij),aa.tppswe(ij),aa.tmswe(ij),aa.tm1swe(ij), ...
        aa.tm2swe(ij),aa.wdswe(ij),aa.wsswe(ij));
end
fclose(fid);