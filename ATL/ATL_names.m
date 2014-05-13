function [titchar2,saven,titchar3] = ATL_names(buoyc,buoy,model,track,level,res)
titcharpt1=['Atlantic Hindcast Study '];%[OWI Winds]   '];
titcharpt125=['  GRID ',level,'  OWI Winds'];
titcharpt15=['WaveWatch III ','ST4',' (Res = ',num2str(res),'\circ)  '];
titcharpt17=['   [ ',num2str(model.lon),'\circ / ',num2str(model.lat),'\circ ]'];
titcharpt2=['NDBC = ',buoyc,' [',num2str(buoy.lon),'\circ / ', ...
    num2str(buoy.lat),'\circ]'];

titchar2=[titcharpt1;titcharpt125;' ';{titcharpt2;titcharpt15;titcharpt17}];
titchar3=[{titcharpt1;titcharpt125}];

saven = ['ATL-',track];

