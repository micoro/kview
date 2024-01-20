function varargout = ImportSettings(varargin)
% IMPORTSETTINGS MATLAB code for ImportSettings.fig
%      IMPORTSETTINGS, by itself, creates a new IMPORTSETTINGS or raises the existing
%      singleton*.
%
%      H = IMPORTSETTINGS returns the handle to a new IMPORTSETTINGS or the handle to
%      the existing singleton*.
%
%      IMPORTSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPORTSETTINGS.M with the given input arguments.
%
%      IMPORTSETTINGS('Property','Value',...) creates a new IMPORTSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImportSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImportSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImportSettings

% Last Modified by GUIDE v2.5 13-Aug-2015 13:32:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImportSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @ImportSettings_OutputFcn, ...
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


% --- Executes just before ImportSettings is made visible.
function ImportSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImportSettings (see VARARGIN)
%
% MODIFICATIONS:
% varargin must exist and the components are:
% varargin{1} - the handles from the kview GUI.
% varargin{2} - an integer that represent the type of GUI arised: 1 means
% that it is a "Import From File" setting and a 2 stands for "Import From
% WS".

% assign varargin data
kviewGUI_handles = varargin{1};
ImportFrom = varargin{2};


% get convert settings
if ImportFrom == 1
    set(hObject,'Name','Import From File Settings');
    ImpConvSett = getappdata(kviewGUI_handles.main_GUI,'ImpFileConvSett');
elseif ImportFrom == 2
    set(hObject,'Name','Import From Workspace Settings');
    ImpConvSett = getappdata(kviewGUI_handles.main_GUI,'ImpWSConvSett');
end


% store data in GUI
setappdata(hObject,'ImportFrom',ImportFrom);
setappdata(hObject,'kviewGUI_handles',kviewGUI_handles);
setappdata(hObject,'ImpConvSett',ImpConvSett);


% fill the GUI with the informations
for ii=1:3
    for jj=1:3 % length(ImpConvSett{ii})
        if ~isempty(ImpConvSett{ii}{jj,1})
            set(handles.(['text_convtab_' int2str(ii) '_' int2str(jj)]),'Enable','on','String',ImpConvSett{ii}{jj,2});
            if strcmp(ImpConvSett{ii}{jj,3},'AtoB')
                value = 1;
            elseif strcmp(ImpConvSett{ii}{jj,3},'BtoA')
                value = 2;
            else
                display(['Error: ' ImpConvSett{ii}{jj,3} ' is not a valid conversion direction.']);
            end
            set(handles.(['SelConvDir_' int2str(ii) '_' int2str(jj)]),'Value',value,'Enable','on');
        else
            set(handles.(['text_convtab_' int2str(ii) '_' int2str(jj)]),'Enable','off','String','No Table Selected');
            set(handles.(['SelConvDir_' int2str(ii) '_' int2str(jj)]),'Value',1,'Enable','off');
        end
    end
end


% Choose default command line output for ImportSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImportSettings wait for user response (see UIRESUME)
% uiwait(handles.ImpSettingsMainGUI);


% --- Outputs from this function are returned to the command line.
function varargout = ImportSettings_OutputFcn(hObject, eventdata, handles) 
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
ImportFrom = getappdata(handles.ImpSettingsMainGUI,'ImportFrom');
kviewGUI_handles = getappdata(handles.ImpSettingsMainGUI,'kviewGUI_handles');
ImpConvSett = getappdata(handles.ImpSettingsMainGUI,'ImpConvSett');


% save the new import conversion settings
if ImportFrom == 1
    ImpFileConvSett = ImpConvSett;
    setappdata(kviewGUI_handles.main_GUI,'ImpFileConvSett',ImpFileConvSett);
    save(strrep(which('kview.m'),'kview.m','kviewSettings.mat'),'ImpFileConvSett','-append');
elseif ImportFrom == 2
    ImpWSConvSett = ImpConvSett;
    setappdata(kviewGUI_handles.main_GUI,'ImpWSConvSett',ImpWSConvSett);
    save(strrep(which('kview.m'),'kview.m','kviewSettings.mat'),'ImpWSConvSett','-append');
end



function cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.ImpSettingsMainGUI);


function deselect_pushbutton_Callback(hObject, eventdata, handles, ImpConvNum, ConvTabNum)
% hObject    handle to deselect_pb_1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get convert settings
ImpConvSett = getappdata(handles.ImpSettingsMainGUI,'ImpConvSett');

% empty the selected line
ImpConvSett{ImpConvNum}(ConvTabNum,:) = {'','',''};

% set modified data into the GUI
setappdata(handles.ImpSettingsMainGUI,'ImpConvSett',ImpConvSett);

% change text into the GUI
set(handles.(['text_convtab_' int2str(ImpConvNum) '_' int2str(ConvTabNum)]),'Enable','off','String','No Table Selected');
set(handles.(['SelConvDir_' int2str(ImpConvNum) '_' int2str(ConvTabNum)]),'Value',1,'Enable','off');


function select_pb_1_1_Callback(hObject, eventdata, handles, ImpConvNum, ConvTabNum)
% hObject    handle to select_pb_1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get data
ImpConvSett = getappdata(handles.ImpSettingsMainGUI,'ImpConvSett');
kviewGUI_handles = getappdata(handles.ImpSettingsMainGUI,'kviewGUI_handles');
ConvTableDir = getappdata(kviewGUI_handles.main_GUI,'ConvTableDir');
ConvDirValue = get(handles.(['SelConvDir_' int2str(ImpConvNum) '_' int2str(ConvTabNum)]),'Value');

if ConvDirValue==1
    ConvDirStr = 'AtoB';
elseif ConvDirValue==2
    ConvDirStr = 'BtoA';
end

% Select the conversion table
[ConvTableName,ConvTableDir,FilterIndex] = uigetfile('*.convtable','Select the Conversion Table',ConvTableDir); 
if FilterIndex == 0
    return
end

% set modified data into the GUI
ImpConvSett{ImpConvNum}(ConvTabNum,:) = {ConvTableDir,ConvTableName,ConvDirStr};
setappdata(handles.ImpSettingsMainGUI,'ImpConvSett',ImpConvSett);
set(handles.(['text_convtab_' int2str(ImpConvNum) '_' int2str(ConvTabNum)]),'Enable','on','String',ConvTableName);
set(handles.(['SelConvDir_' int2str(ImpConvNum) '_' int2str(ConvTabNum)]),'Enable','on');



function SelConvDir_Callback(hObject, eventdata, handles, ImpConvNum, ConvTabNum)
% hObject    handle to select_pb_1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get data
ImpConvSett = getappdata(handles.ImpSettingsMainGUI,'ImpConvSett');
ConvDirContents = cellstr(get(handles.(['SelConvDir_' int2str(ImpConvNum) '_' int2str(ConvTabNum)]),'String'));
ConvDirValue = get(handles.(['SelConvDir_' int2str(ImpConvNum) '_' int2str(ConvTabNum)]),'Value');


% set the conversion direction value
ImpConvSett{ImpConvNum}{ConvTabNum,3} = ConvDirContents{ConvDirValue};

% set modified data into the GUI
setappdata(handles.ImpSettingsMainGUI,'ImpConvSett',ImpConvSett);
