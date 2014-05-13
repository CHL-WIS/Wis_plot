function aa = conc_SUPERIOR_eval(buoy,model,level,yeard,mon1,mon2)
bas = 'SUPERIOR';
if isunix
    cc = ['/mnt/CHL_WIS_1/LAKE_SUPERIOR/Production/Validation/WIS/'];
else
    cc = ['X:\GOM\Evaluation\',model,'\Validation\WIS\'];
end
yearc = num2str(yeard(1));
yearmon = [yearc,'-',mon1];
if isunix
    dirname = [cc,'/',yearmon,'/',level];
    if ~exist(dirname,'dir')
        dirname = [cc,'/',yearmon,'/'];
    end
    fname = [dirname,'/timepair-',bas,'-',yearmon,'-',level,'-',buoy,'.mat'];
else
    dirname = [cc,'\',yearmon,'\',level];
    fname = [dirname,'\timepair-',bas,'-',yearmon,'-',level,'-',buoy,'.mat'];
end
    lev = level(6:end);

% if exist(fname,'file')
%     load(fname);
%     aabuoy = AB;
%     aamod = AM;
%     [se,sd]=stats(AB,AM);
%     wndsst = se(1,:);
%     wvhtst = se(2,:);
%     tppst = se(3,:);
%     tmmst = se(4,:);
%     timest = AM(1,1);
%     wvhtme = mean(AB(AB(:,4)>=0,4));
%     wspdme = mean(AB(AB(:,2)>=0,2));
%     tmmme = mean(AB(AB(:,6)>=0,6));
% else
%     timest = datenum(yeard(1),str2num(mon1),01,01,00,00);
%     AB = NaN([1 7]);AM = NaN([1 7]);
%     AB(1,1) = timest;AM(1,1) = timest;
%     aabuoy = AB;
%     aamod = AM;
%     wndsst = NaN([1 18]);
%     wvhtst = NaN([1 18]);
%     tppst = NaN([1 18]);
%     tmmst = NaN([1 18]);
%     wvhtme = NaN;
%     wspdme = NaN;
%     tmmme = NaN;
% end
for jj = yeard(1):yeard(end)
    mone = 12;mons = 1;
    if jj == yeard(1)
        mons = str2num(mon1);
    end
    if jj == yeard(end)
        mone = str2num(mon2);
    end
    for ii = mons:mone
        if ii < 10
            monc = ['0',num2str(ii)];
        else
            monc = num2str(ii);
        end
        yearc = num2str(jj);
        yearmon = [yearc,'-',monc];
        if isunix
            dirname = [cc,'/',yearmon,'/',level];
            if ~exist(dirname,'dir')
                dirname = [cc,'/',yearmon,'/'];
            end
            fname = [dirname,'/timepair-',bas,'-',yearmon,'-',level,'-',buoy,'.mat'];
        else
            dirname = [cc,'\',yearmon,'\',level];
            fname = [dirname,'\timepair-',bas,'-',yearmon,'-',level,'-',buoy,'.mat'];
        end
        if exist(fname,'file')
            load(fname);
            if isempty(AB)
                AB = NaN([1,size(aabuoy,2)]);
                AM = NaN([1,size(aamod,2)]);
                AB(1,1) = aabuoy(end,1) + 1;
                AM(1,1) = aamod(end,1) + 1;                
                aabuoy = vertcat(aabuoy,AB);
                aamod = vertcat(aamod,AM);
                wndsst = vertcat(wndsst,NaN([1,size(se,2)]));
                wvhtst = vertcat(wvhtst,NaN([1,size(se,2)]));
                tppst = vertcat(tppst,NaN([1,size(se,2)]));
                tmmst = vertcat(tmmst,NaN([1,size(se,2)]));
                timest = vertcat(timest,datenum(jj,ii,1,1,0,0));
                wvhtme = vertcat(wvhtme,mean(AB(AB(:,4)>=0,4)));
                wspdme = vertcat(wspdme,mean(AB(AB(:,2)>=0,2)));
                tmmme = vertcat(tmmme,mean(AB(AB(:,6)>=0,6)));
                continue
            end
            [se,sd]=stats(AB,AM);
            if exist('aabuoy','var')
                aabuoy = vertcat(aabuoy,AB);
                aamod = vertcat(aamod,AM);
                wndsst = vertcat(wndsst,se(1,:));
                wvhtst = vertcat(wvhtst,se(2,:));
                tppst = vertcat(tppst,se(3,:));
                tmmst = vertcat(tmmst,se(4,:));
                timest = vertcat(timest,datenum(jj,ii,1,1,0,0));
                wvhtme = vertcat(wvhtme,mean(AB(AB(:,4)>=0,4)));
                wspdme = vertcat(wspdme,mean(AB(AB(:,2)>=0,2)));
                tmmme = vertcat(tmmme,mean(AB(AB(:,6)>=0,6)));
            else
                aabuoy = AB;
                aamod = AM;
                wndsst = se(1,:);
                wvhtst = se(2,:);
                tppst = se(3,:);
                tmmst = se(4,:);
                timest = datenum(jj,ii,1,1,0,0);
                wvhtme = mean(AB(AB(:,4)>=0,4));
                wspdme = mean(AB(AB(:,2)>=0,2));
                tmmme = mean(AB(AB(:,6)>=0,6));
            end
        else
            if ~exist('aabuoy','var')
                timest = datenum(yeard(1),str2num(mon1),01,01,00,00);
                AB = NaN([1 7]);AM = NaN([1 7]);
                AB(1,1) = timest;AM(1,1) = timest;
                aabuoy = AB;
                aamod = AM;
                wndsst = NaN([1 18]);
                wvhtst = NaN([1 18]);
                tppst = NaN([1 18]);
                tmmst = NaN([1 18]);
                wvhtme = NaN;
                wspdme = NaN;
                tmmme = NaN;
            else
                AB = NaN([1,size(aabuoy,2)]);
                AM = NaN([1,size(aamod,2)]);
                AB(1,1) = aabuoy(end,1) + 1;
                AM(1,1) = aamod(end,1) + 1;                
                aabuoy = vertcat(aabuoy,AB);
                aamod = vertcat(aamod,AM);
                wndsst = vertcat(wndsst,NaN([1 18]));
                wvhtst = vertcat(wvhtst,NaN([1 18]));
                tppst = vertcat(tppst,NaN([1 18]));
                tmmst = vertcat(tmmst,NaN([1 18]));
                timest = vertcat(timest,datenum(jj,ii,1,1,0,0));
                wvhtme = vertcat(wvhtme,mean(AB(AB(:,4)>=0,4)));
                wspdme = vertcat(wspdme,mean(AB(AB(:,2)>=0,2)));
                tmmme = vertcat(tmmme,mean(AB(AB(:,6)>=0,6)));
            end
        end
    end
end
%if exist('aabuoy','var')
    iwvht = aabuoy(:,4) >= 0 & ~isnan(aabuoy(:,4));
    if ~isempty(aabuoy(iwvht,4))
        %[qqB,qqM] = QQ_proc(aabuoy(iwvht,4),aamod(iwvht,4));
        aa = struct('aabuoy',aabuoy,'aamod',aamod,'timest',timest,'wndsst',wndsst, ...
        'wvhtst',wvhtst,'tppst',tppst,'tmmst',tmmst,'wvhtme',wvhtme, ...
        'wspdme',wspdme,'tmmme',tmmme);
    else
        aa = 0;
    end
