%%%MAKE A SEPERATE FUNCTION
function frame = extractFrameFromFigure(fig)

% The renderer requires DPI units.  Get the necessary conversion factor.
pixelsperinch = get(0,'screenpixelsperinch');

% The easiest way to obtain the conversion is to switch to pixel units.
% This provides robustness to whatever units the user was using previously.
oldUnits = get(fig,'units');
set(fig,'units','pixels');

% Now we obtain the figure size
pos = get(fig,'position');
oldPaperPosition = get(fig,'paperposition');
set(fig, 'paperposition', pos./pixelsperinch);

% Upgrade no renderer and painters renderer to OpenGL for the off-screen
% rendering, because that's what AVIFILE/ADDFRAME does.
renderer = get(fig,'renderer');
if strcmp(renderer,'painters') || strcmp(renderer,'None')
  renderer = 'opengl';
end

% Temporarily turn off warning in case opengl is not supported and
% hardcopy needs to use zbuffer
% warnstate = warning('off', 'MATLAB:extractFrameFromFigure:warningsTurnedOff');
% noanimate('save',fig);
frame = hardcopy(fig, ['-d' renderer],['-r' num2str(round(pixelsperinch))]);
% noanimate('restore',fig);
% warning(warnstate);

% Restore figure state.  We do it in the opposite order that it was changed
% so dependent state elements work correctly (esp. paperposition's
% interplay with units).
set(fig, 'paperposition', oldPaperPosition);
set(fig, 'units',oldUnits); 
end