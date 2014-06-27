function plot_coast(fname,fdir)

fid = fopen([fdir,fname]);
nn = 0;

while ~feof(fid)
    nn = nn + 1;
    data = fgetl(fid);
    bb = textscan(fid,'%f%f');
    coast.lon{nn} = bb{1};
    coast.lat{nn} = bb{2};
end

figure
hold on
for jj = 1:length(coast.lon)
    plot(coast.lon{jj},coast.lat{jj})
end