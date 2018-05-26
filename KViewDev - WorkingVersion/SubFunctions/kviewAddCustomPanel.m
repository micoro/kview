function kviewAddCustomPanel(kviewGUI_handle,PanelName,PanelCreateFcn)
% Function to add a custom panel to the kview GUI.
%
% SYNTAX:   
%   kviewAddCustomPanel(kviewGUI_handle,PanelName,PanelCreateFcn)
%
% INPUT:
%   kviewGUI_handle     Handle of the kview GUI.
%   PanelName           String that will appear in the popup menu.
%   PanelCreateFcn      Name of the function that will actually draw the
%                       panel (with all the needed callbacks).
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    27/04/2015
%   Author:  Michele Oro Nobili 


% Get data
handles = guidata(kviewGUI_handle);
CustomPanels = getappdata(kviewGUI_handle,'CustomPanels');

% check if the panel already exist
if any(strcmp(CustomPanels(:,1),PanelName))
    disp('A custom panel with the same name already exist.')
else
    CustomPanels(end+1,:) = {PanelName PanelCreateFcn};
end

% Repeat for each popoupmenu
for ii =1:2
    % get panel popupmenu string
    PopupMenuStrings = get(handles.(['CustomMenu' num2str(ii) '_popupmenu']),'String');

    % Make the changes
    PopupMenuStrings{end+1} = PanelName;

    % Store data and update the GUI
    set(handles.(['CustomMenu' num2str(ii) '_popupmenu']),'String',PopupMenuStrings);
end


setappdata(kviewGUI_handle,'CustomPanels',CustomPanels);

end

