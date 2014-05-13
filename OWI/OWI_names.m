function [titchar2,saven,titchar3] = OWI_names(buoyc,buoy,model,track,level,res)
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
titcharpt1=['OWI Storms   '];
% Model level including grid resolution
titcharpt15=['WAMCY451C',' (Res = ',num2str(res),'\circ)  '];
% Sits below model level with model latitude and longitude
titcharpt17=['   [ ',num2str(model.lon),'\circ / ',num2str(model.lat),'\circ ]'];
% Buoy id and buoy longitude and latitude
titcharpt2=['NDBC = ',buoyc,' [',num2str(buoy.lon),'\circ / ', ...
    num2str(buoy.lat),'\circ]'];
titcharpt25=['at Depth = ',num2str(buoy.depth),'m'];

% Title string
titchar2=[titcharpt1;' ';{titcharpt2;titcharpt25;titcharpt15;titcharpt17}];

titchar3=[titcharpt1;{titcharpt15}];
% Save string (Change EXP to a 3 letter description of basin)
saven = ['OWI-',track];

