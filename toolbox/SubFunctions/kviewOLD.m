function varargout = kviewOLD(varargin)
% kviewOLD is old code that is in process to be replaced/improved.
%
% ----------------------------------------------------------------------- %
%   Copyright (C) 2015
%   All Rights Reserved.
%
%   Date:    11/02/2015
%   Author:  Michele Oro Nobili 


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kview_OpeningFcn, ...
                   'gui_OutputFcn',  @kview_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT
end


% --- Executes on selection change in CustomMenu1_popupmenu.
function CustomMenu_popupmenu_Callback(hObject,~, handles, CustomMenuNum)
% hObject    handle to CustomMenu1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% CustomMenuNum determine the target CustomMenu

% Hints: contents = cellstr(get(hObject,'String')) returns CustomMenu1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CustomMenu1_popupmenu

% get data
contents = cellstr(get(hObject,'String'));
GUIPosition = get(handles.main_GUI,'Position');
CustomPanels = getappdata(handles.main_GUI,'CustomPanels');

if CustomMenuNum == 1
    TargetCustomPanelHandle = handles.CustomPanel1;
elseif CustomMenuNum == 2
    TargetCustomPanelHandle = handles.CustomPanel2;
end

delete(get(TargetCustomPanelHandle,'Children'));


if strcmp(contents{get(hObject,'Value')},'-- None --')
    contents1 = cellstr(get(handles.CustomMenu1_popupmenu,'String'));
    contents2 = cellstr(get(handles.CustomMenu2_popupmenu,'String'));
    
    if all(strcmp({contents1{get(handles.CustomMenu1_popupmenu,'Value')},contents2{get(handles.CustomMenu2_popupmenu,'Value')}},'-- None --'))
        Sizes = get(handles.VBox1,'Sizes');
        if Sizes(4) ~= 0
            GUIPosition = [GUIPosition(1) GUIPosition(2)+120 GUIPosition(3) GUIPosition(4)-120];
            set(handles.VBox1,'Sizes',[Sizes(1:3) 0]);
        end
    end
    
else
    
    Sizes = get(handles.VBox1,'Sizes');
   
    if Sizes(4) ~= 120
        GUIPosition = [GUIPosition(1) GUIPosition(2)-120 GUIPosition(3) GUIPosition(4)+120];
        set(handles.VBox1,'Sizes',[Sizes(1:3) 120]);
    end
   
    Selection = contents{get(hObject,'Value')};
    
    switch Selection
                    
        case 'Offset and Gain'
            kview_OffsetAndGain(TargetCustomPanelHandle);   
            
        case 'Custom Buttons 1'
            kview_CustomButtons(TargetCustomPanelHandle,1);
        case 'Custom Buttons 2'
            kview_CustomButtons(TargetCustomPanelHandle,2);
        case 'Custom Buttons 3'
            kview_CustomButtons(TargetCustomPanelHandle,3);
            
        otherwise
            feval(CustomPanels{strcmp(CustomPanels(:,1),Selection),2},TargetCustomPanelHandle);
    end  
end

 
set(handles.main_GUI,'Position',GUIPosition);
guidata(hObject,handles);
end