function write_WIS_onlns(fname,aa)


form = ['%14i %6i %10.3f%10.3f%7.1f%5.0f.%8.2f%8.2f%8.2f', ...
    '%8.2f%8.2f%8.2f%8.2f%8.2f%8.2f%5.0f.%5.0f.%8.2f%8.2f', ...
    '%8.2f%8.2f%8.2f%8.2f%5.0f.%5.0f.%8.2f%8.2f%8.2f%8.2f', ...
    '%8.2f%8.2f%5.0f.%5.0f.\n'];

fid = fopen(fname,'w');
for ij = 1:size(aa,1)
    fprintf(fid,form,aa(ij,:));
end
fclose(fid);
