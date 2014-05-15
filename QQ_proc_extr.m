function [qqx, qqy]=QQ_proc_extr(xpar,ypar)
%
%  Q-Q Generation and plotting routine.
%       Developed:  A. Cox  Oceanweather, Inc.
%       Modified :  R. Jensen (to matlab).
%
%  Required Input:
%  Time paired buoy and model
%       X = BUOY
%       Y = MODEL
%
%
%  sarrary are the number of observations, and/or time paired obs
%   where we need to mpair model and measurements.
%
sarray=length(xpar);
%
%  Now sort in an assending order (lowest to highest)
%  And Get the wave heights in height bands
%
xsrtB=sort(xpar);
ysrtM=sort(ypar);
hmax1=max(xpar);
hmax2=max(ypar);
hmax = hmax1;
parmax=max(max(xpar),max(ypar));

res=0.1;
%
%  Hardwire percentiles:
%
percntle=.001:.001:.999;
totpercnt=length(percntle);
%
for kk=1:totpercnt
    snp=percntle(kk).*(sarray-1);
    ij=floor(snp);
    sg=snp - ij;
    iarray=ij + 1;
    if iarray == sarray
        qqx(kk)=(1-sg).*xsrtB(iarray);
    else
        qqx(kk)=(1-sg).*xsrtB(iarray) + sg.*xsrtB(iarray+1);
    end
end
%
%  Do the same thing for the model
%
clear snp; clear ij; clear iarray; clear sg;

for kk=1:totpercnt
    snp=percntle(kk).*(sarray-1);
    ij=floor(snp);
    sg=snp - ij;
    iarray=ij + 1;
    if iarray == sarray
        qqy(kk)=(1-sg).*ysrtM(iarray);
    else
        qqy(kk)=(1-sg).*ysrtM(iarray) + sg.*ysrtM(iarray+1);
    end
end
%