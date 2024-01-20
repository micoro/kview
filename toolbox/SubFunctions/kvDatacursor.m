function text = kvDatacursor(~,eventdata)
% Modified DataTip
%
% The function shows X, Y and Z coordinates in the datatip. It also shows
% the local slope (deltaY/deltaX) and if exactly two datatips are presents,
% it shows the slope between the two datatips.
%
%
% INPUT:
%   hObject         unused
%   eventdata       contains the following fields: Target (handle), 
%                   Position and DataIndex. 
%
% OUTPUT:  
%   text            cell of strings to be displayed in the datatip.
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    15/09/2016
%   Author:  Michele Oro Nobili 


    Index = eventdata.DataIndex;
    line = eventdata.Target;

    % Calc local slope
    if Index-1<=0
        Slope = (line.YData(Index+1)-line.YData(Index))/(line.XData(Index+1)-line.XData(Index));
    elseif Index+1>length(line.XData)
        Slope = (line.YData(Index)-line.YData(Index-1))/(line.XData(Index)-line.XData(Index-1));
    else
        Slope = ((line.YData(Index+1)-line.YData(Index))/(line.XData(Index+1)-line.XData(Index)) +... 
        (line.YData(Index)-line.YData(Index-1))/(line.XData(Index)-line.XData(Index-1)))/2;
    end

    % add X and Y coord to datatip
    text = {['X: ' num2str(eventdata.Position(1))],...
            ['Y: ' num2str(eventdata.Position(2))]};

    % add Z coord if present
    if length(eventdata.Position)>2
        text{end+1} = ['Z: ' num2str(eventdata.Position(3))];
    end

    % Add local slope to datatip
    text{end+1} = ['Local Slope: ' num2str(Slope)];

    % if there are 2 datatips, calc relative slope
    dcm_obj = datacursormode(line.Parent.Parent);
    Cursors = dcm_obj.getCursorInfo;
    if length(Cursors) == 2
        RelativeSlope = ((Cursors(2).Position(2) - Cursors(1).Position(2))/(Cursors(2).Position(1) - Cursors(1).Position(1)));
        text{end+1} = ['Relative Slope: ' num2str(RelativeSlope)];
    end


    
end

