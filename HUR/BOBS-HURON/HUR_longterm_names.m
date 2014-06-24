function [tit,outdir] = HUR_longterm_names(year1,year2,model,grid) 
%
%    EXP_longterm_names
%      creates title and directory for longterm stats on raid
%      created TJ Hesser
%
%    INPUT:
%       year1   STRING:  1st year of stats
%       year2   STRING:  Last year of stats
%       model   STRING:  Description of model i.e. WAM451C/WW3-ST4
%       grid    STRING:  Grid identifier  i.e. LEVEL1/LEVEL2
%    OUTPUT:
%       tit     STRING:  title for longterm stats plot
%       outdir  STRING:  Save location for longterm stats
% -------------------------------------------------------------------------

tit1 = ['Lake Huron WIS Hindcast Longterm Stats'];
tit2 = ['Model = ',model];
tit3 = ['Grid = ',grid];
tit4 = ['Time = ',year1,' - ',year2];
tit = {tit1;tit2;tit3;tit4};

% Change directory listing for saving longterm stats
outdir = ['Z:\LAKE_HURON\Production\WAM451C\Longterm\'];
if ~exist(outdir,'dir');
    mkdir(outdir);
end
