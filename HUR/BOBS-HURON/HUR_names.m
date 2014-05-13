function [titchar2,saven] = HUR_names(buoyc,buoy,model,track,level,res)
titcharpt1=['Lake Huron Hindcast Study '];
titcharpt125 = ['       [CFSR Winds]   '];
titcharpt15=['WAMCY451C ',' (Res = ',num2str(res),'\circ)  '];
titcharpt17=['   [ ',num2str(model.lon),'\circ / ',num2str(model.lat),'\circ ]'];
titcharpt2=['NDBC/EC = ',buoyc,' '];
titcharpt225=['   [',num2str(buoy.lon),'\circ / ',num2str(buoy.lat),'\circ]'];

titchar2=[titcharpt1;titcharpt125;' ';{titcharpt2;...
        titcharpt225;titcharpt15;titcharpt17}];

saven = ['HUR-',track];

