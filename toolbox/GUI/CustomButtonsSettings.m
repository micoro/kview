function varargout = CustomButtonsSettings(varargin)
% CustomButtonsSettings MATLAB code for CustomButtonsSettings.fig
%      CustomButtonsSettings, by itself, creates a new CustomButtonsSettings or raises the existing
%      singleton*.
%
%      H = CustomButtonsSettings returns the handle to a new CustomButtonsSettings or the handle to
%      the existing singleton*.
%
%      CustomButtonsSettings('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CustomButtonsSettings.M with the given input arguments.
%
%      CustomButtonsSettings('Property','Value',...) creates a new CustomButtonsSettings or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CustomButtonsSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CustomButtonsSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CustomButtonsSettings

% Last Modified by GUIDE v2.5 17-Aug-2015 20:41:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CustomButtonsSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @CustomButtonsSettings_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before CustomButtonsSettings is made visible.
function CustomButtonsSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CustomButtonsSettings (see VARARGIN)
%
% MODIFICATIONS:
% varargin must exist and the components are:
% varargin{1} - the handles from the kview GUI.


% assign varargin data
kviewGUI_handles = varargin{1};


% get convert settings
CustButtSett = getappdata(kviewGUI_handles.main_GUI,'CustButtSett');


% store data in GUI
setappdata(hObject,'kviewGUI_handles',kviewGUI_handles);
setappdata(hObject,'CustButtSett',CustButtSett);


% fill the GUI with the informations
for ii=1:3
        if ~isempty(CustButtSett{ii,1})
            set(handles.(['CustButtonTab' int2str(ii)]),'Enable','on','String',CustButtSett{ii,2});
        else
            set(handles.(['CustButtonTab' int2str(ii)]),'Enable','off','String','No Table Selected');
        end
end


% Choose default command line output for CustomButtonsSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CustomButtonsSettings wait for user response (see UIRESUME)
% uiwait(handles.CustomButtonSettMainGUI);


% --- Outputs from this function are returned to the command line.
function varargout = CustomButtonsSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get data from GUI
kviewGUI_handles = getappdata(handles.CustomButtonSettMainGUI,'kviewGUI_handles');
CustButtSett = getappdata(handles.CustomButtonSettMainGUI,'CustButtSett');


% save the new import conversion settings
setappdata(kviewGUI_handles.main_GUI,'CustButtSett',CustButtSett);
save(strrep(which('kview.m'),'kview.m','kviewSettings.mat'),'CustButtSett','-append');




function cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.CustomButtonSettMainGUI);


function deselect_pushbutton_Callback(hObject, eventdata, handles, TabNum)
% hObject    handle to deselect_pb_1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get convert settings
CustButtSett = getappdata(handles.CustomButtonSettMainGUI,'CustButtSett');

% empty the selected line
CustButtSett(TabNum,:) = {'',''};

% set modified data into the GUI
setappdata(handles.CustomButtonSettMainGUI,'CustButtSett',CustButtSett);

% change text into the GUI
set(handles.(['CustButtonTab' int2str(TabNum)]),'Enable','off','String','No Table Selected');



function select_pb_Callback(hObject, eventdata, handles, TabNum)
% hObject    handle to select_pb_1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get data
CustButtSett = getappdata(handles.CustomButtonSettMainGUI,'CustButtSett');
kviewGUI_handles = getappdata(handles.CustomButtonSettMainGUI,'kviewGUI_handles');
ButtonTableDir = getappdata(kviewGUI_handles.main_GUI,'ButtonTableDir');


% Select the conversion table
[ButtonTableName,ButtonTableDir,FilterIndex] = uigetfile('*.buttontable','Select the Buttons Table',ButtonTableDir); 
if FilterIndex == 0
    return
end

% set modified data into the GUI
CustButtSett(TabNum,:) = {ButtonTableDir,ButtonTableName};
setappdata(handles.CustomButtonSettMainGUI,'CustButtSett',CustButtSett);
set(handles.(['CustButtonTab' int2str(TabNum)]),'Enable','on','String',ButtonTableName);
