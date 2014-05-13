function [titchar2,saven] = EXP_names(buoyc,buoy,model,level,res)
%
%   function EXP_names
%      creates title and save name for WIS timeplots
%      created TJ Hesser
%
%      all strings subject to change depending on basin
%
%   INPUT:
%        buoyc   STRING : string for buoy id
%        buoy    STRUCT ARRAY : structured array for buoy results
%        model   STRUCT ARRAY : structured array for model results
%        level   STRING : string to identify subgrid 
%        res     NUMERIC : resolution of grid
%   OUTPUT:
%        titchar2   STRING : title of time plots 
%        saven      STRING : save name for time plots 
% -------------------------------------------------------------------------

% top level title (Change Example to basin and adjust winds)
titcharpt1=['Example Hindcast Study [OWI Winds]   '];
% Model level including grid resolution
titcharpt15=['WaveWatch III ','ST4',' (Res = ',num2str(res),'\circ)  '];
% Sits below model level with model latitude and longitude
titcharpt17=['   [ ',num2str(model.lon),'\circ / ',num2str(model.lat),'\circ ]'];
% Buoy id and buoy longitude and latitude
titcharpt2=['NDBC = ',buoyc,' [',num2str(buoy.lon),'\circ / ', ...
    num2str(buoy.lat),'\circ]'];

% Title string
titchar2=[titcharpt1;' ';{titcharpt2;titcharpt15;titcharpt17}];

% Save string (Change EXP to a 3 letter description of basin)
saven = ['EXP-',level];

