function [aa, fflag] = read_WIS_onlns(fname)
%
%   read_WIS_onlns
%
%   INPUT:
%     fname    STR    : name of file 
%
%   OUTPUT:
%     aa       STRUCT 
%      timec          : date yyyymmddhhmmss
%      time           : matlab time
%      stat           : station number
%      lat            : latitude
%      lon            : longitude
%      wndspd         : wind speed m/s
%      wnddir         : wind direction (met degrees from)
%      ustar          : fiction velocity (m/s)
%      cdrag          : coefficient of drag
%      norm           : normalized velocity
%      wavhs          : wave height
%      wavtp          : peak period
%      wavtpp         : parabolic fit to the peak period
%      wavtm          : mean period
%      wavtm1         : 1st moment of mean period
%      wavtm2         : 2nd moment of mean period
%      wavdir         : wave direction
%      wavspr         : wave direction spread
%      wavhs_wndsea   : windsea wave height
%      wavtp_wndsea   : windsea peak period
%      wavtpp_wndsea  : windsea parabolic fit to the peak period
%      wavtm_wndsea   : windsea mean period
%      wavtm1_wndsea  : windsea 1st moment of mean period
%      wavtm2_wndsea  : windsea 2nd moment of mean period
%      wavdir_wndsea  : windsea wave direction
%      wavspr_wndsea  : windsea wave direction spread
%      wavhs_swell    : swell wave height
%      wavtp_swell    : swell peak period
%      wavtpp_swell   : swell parabolic fit to the peak period
%      wavtm_swell    : swell mean period
%      wavtm1_swell   : swell 1st moment of mean period
%      wavtm2_swell   : swell 2nd moment of mean period
%      wavdir_swell   : swell wave direction
%      wavspr_swell   : swell wave direction spread
%   fflag            NUM    : returns a 0 if the file doesn't exist, 1 if
%                               sucessful
%------------------------------------------------------------------------
fid = fopen(fname);
if fid == -1
    fflag = 0;aa = 0;
    return
end
fflag = 1;
data = textscan(fid,['%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f',...
    '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f']);
fclose(fid);
if data{1}(1,1) == 1
    [aa,fflag] = read_WIS_onlns_old(fname);
    return
end
aa.timec = num2str(data{1});
year = str2num(aa.timec(:,1:4));
mon = str2num(aa.timec(:,5:6));
day = str2num(aa.timec(:,7:8));
hour = str2num(aa.timec(:,9:10));
min = str2num(aa.timec(:,11:12));
sec = str2num(aa.timec(:,13:14));
aa.time = datenum(year,mon,day,hour,min,sec);

aa.stat = data{2}{1};
aa.lat = data{3}(1);
aa.lon = data{4}(1);
aa.wndspd = data{5};
aa.wnddir = data{6};
aa.ustar = data{7};
aa.cdrag = data{8};
aa.norm = data{9};
aa.wavhs = data{10};
aa.wavtp = data{11};
aa.wavtpp = data{12};
aa.wavtm = data{13};
aa.wavtm1 = data{14};
aa.wavtm2 = data{15};
aa.wavdir = data{16};
aa.wavspr = data{17};

aa.wavhs_wndsea = data{18};
aa.wavtp_wndsea = data{19};
aa.wavtpp_wndsea = data{20};
aa.wavtm_wndsea = data{21};
aa.wavtm1_wndsea = data{22};
aa.wavtm2_wndsea = data{23};
aa.wavdir_wndsea = data{24};
aa.wavspr_wndsea = data{25};

aa.wavhs_swell = data{26};
aa.wavtp_swell = data{27};
aa.wavtpp_swell = data{28};
aa.wavtm_swell = data{29};
aa.wavtm1_swell = data{30};
aa.wavtm2_swell = data{31};
aa.wavdir_swell = data{32};
aa.wavspr_swell = data{33};
