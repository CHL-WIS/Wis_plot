function strdate = intdate_2_strdate(yr,mon,day,hour,minute,sec)

yearc = num2str(yr);
for jm = 1:length(mon)
    if mon(jm) < 10
        monc(jm,:) = ['0',num2str(mon(jm))];
    else
        monc(jm,:) = num2str(mon(jm));
    end
end

for jd = 1:length(day)
    if day(jd) < 10
        dayc(jd,:) = ['0',num2str(day(jd))];
    else
        dayc(jd,:) = num2str(day(jd));
    end
end

for jh = 1:length(hour)
    if hour(jh) < 10
        hourc(jh,:) = ['0',num2str(hour(jh))];
    else
        hourc(jh,:) = num2str(hour(jh));
    end
end

for jm = 1:length(minute)
    if minute(jm) < 10
        minutec(jm,:) = ['0',num2str(minute(jm))];
    else
        minutec(jm,:) = num2str(minute(jm));
    end
end

for js = 1:length(sec)
    if sec(js) < 10
        secc(js,:) = ['0',num2str(sec(js))];
    else
        secc(js,:) = num2str(sec(js));
    end
end

strdate = [yearc,monc,dayc,hourc,minutec,secc];
