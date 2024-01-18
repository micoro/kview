function kvGenericSettingsGUI(~,~)
% creates a GUI to handle kview generic settings.
%
% NOTE: intended for internal use only.
%
%
% SYNTAX:
%   kvGenericSettingsGUI(hObject,eventdata)
%
%
% INPUT:
%   hObject     unused
%   eventdata   unused
%
%
% -------------------------------------------------------------------------
%  Copyright (C) 2016
%  All Rights Reserved.
%
%  Date:    21/05/2016
%  Author:  Michele Oro Nobili




%% ---------------------------------------------------- Initialize data ---

% only one instance at time
persistent hsingleton;
if ishandle(hsingleton)
    
    % push the window on the top.
    figure(hsingleton);
    
    return;
end

% check if settings file exist and in case creates it
kviewLoadSettings;

% get data from settings file
settings = load('kviewSettings.mat');


%% ------------------------------------------------------- GUI creation ---

% create the main figure
hFig = figure(...
    'IntegerHandle','off',...
    'MenuBar','none',...
    'Name','Settings',...
    'NumberTitle','off',...
    'Position',[1 1 500 130],...
    'Resize','off',...
    'HandleVisibility','off',...
    'Tag','settingsGUI',...
    'Visible','off');
handles.(get(hFig,'Tag')) = hFig;

% set GUI position
ScreenSize = get(0,'ScreenSize');
hFig.Position(1:2) = (ScreenSize(3:4)-hFig.Position(3:4))/2;

% Add elements to the GUI
h = uix.VBox('Parent',hFig,'Tag','VBox1','Padding',5,'Spacing',5);
handles.(get(h,'Tag')) = h;

    h = uix.Panel('Parent',handles.VBox1,'Tag','Panel1','Title','Default X axis','FontSize',9);
    handles.(get(h,'Tag')) = h;
    
        h = uix.Grid('Parent',handles.Panel1,'Tag','Grid1','Padding',5,'Spacing',5);
        handles.(get(h,'Tag')) = h;
        
            h = uicontrol('Parent',handles.Grid1,...
                'FontSize',9,...
                'HorizontalAlignment','right',...
                'String','subsystem:',...
                'Style','text',...
                'Tag','Xsubsystem_text');
            handles.(get(h,'Tag')) = h;
        
            h = uicontrol('Parent',handles.Grid1,...
                'FontSize',9,...
                'HorizontalAlignment','right',...
                'String','variable:',...
                'Style','text',...
                'Tag','Xvariable_text');
            handles.(get(h,'Tag')) = h;
            
            h = uicontrol('Parent',handles.Grid1,...
                'FontSize',9,...
                'HorizontalAlignment','left',...
                'String',settings.defaultXAxis{2},...
                'Style','edit',...
                'Tag','Xsubsystem_edit');
            handles.(get(h,'Tag')) = h;
            h.Callback = {@CheckEditBox,h};
        
            h = uicontrol('Parent',handles.Grid1,...
                'FontSize',9,...
                'HorizontalAlignment','left',...
                'String',settings.defaultXAxis{1},...
                'Style','edit',...
                'Tag','Xvariable_edit');
            handles.(get(h,'Tag')) = h;
            h.Callback = {@CheckEditBox,h};
           
    h = uix.Empty('Parent',handles.VBox1,'Tag','Empty1');
    handles.(get(h,'Tag')) = h;
            
    h = uix.HButtonBox('Parent',handles.VBox1,'Tag','HBBox1','Spacing',5,'HorizontalAlignment','right','ButtonSize',[100 30]);
    handles.(get(h,'Tag')) = h;

        h = uicontrol('Parent',handles.HBBox1,...
            'Callback',@SaveCallback,...
            'FontSize',10,...
            'String','Save',...
            'Style','pushbutton',...
            'Tag','ok_pushbutton');
        handles.(get(h,'Tag')) = h;

        h = uicontrol('Parent',handles.HBBox1,...
            'Callback',@ExitCallback,...
            'FontSize',10,...
            'String','Exit',...
            'Style','pushbutton',...
            'Tag','exit_pushbutton');
        handles.(get(h,'Tag')) = h;
    
    
    
% set dimensions
set(handles.Grid1,'Widths',[200 -1],'Heights',[22 22]);
set(handles.VBox1,'Heights',[80 -1 30]);

% assign hsingleton
hsingleton = hFig;

% set visibility to on
hFig.Visible = 'on';



%% --------------------------------------------------- Nested functions ---


    function CheckEditBox(~,~,hEditBox)
        if ~isvarname(hEditBox.String)
            hEditBox.String = '';
        end       
    end


    function SaveCallback(~,~)
        defaultXAxis = {handles.Xvariable_edit.String,handles.Xsubsystem_edit.String};
        save(which('kviewSettings.mat'),'defaultXAxis','-append');
    end



    function ExitCallback(~,~)
        delete(hFig);
    end



end

