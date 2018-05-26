function hOut = kview_CreateFcn(varargin)
% kview_CreateFcn creates the kview GUI.
%
%
% SYNTAX:
%   kview_CreateFcn
%
%
% INPUT:
%   varargin    a string  
%
% OUTPUT:
%   hOut    	handle of the GUI. Return FALSE if the GUI is not open and
%               the 'query' argument was supplied to the function.
%
%
% -------------------------------------------------------------------------
%  Copyright (C) 2016
%  All Rights Reserved.
%
%  Date:    12/10/2016
%  Author:  Michele Oro Nobili


%% ----------------------------------------------------- Initialization ---

persistent hsingleton;

if ~isempty(varargin)
    if strcmp(varargin{1},'functionhandles')
        hOut = localfunctions;
        return
    end
end


if ishandle(hsingleton)
    hOut = hsingleton;
    return;
elseif ~isempty(varargin)
    if strcmp(varargin{1},'query')
        hOut = false;
        return;
    end
end


% --- check for GUI Layout toolbox
installedToolbox = ver;
if ~any(strcmp('GUI Layout Toolbox',{installedToolbox.Name}))
	error(['GUI Layout toolbox is not installed. Kview needs the GUI Layout toolbox to run. ',...
        'You can download and install it from the Add-On Explorer or from File Exchange at this ',...
        'link: <a href="https://it.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox">LINK</a>']);
end




% --- GUI Figure
% Create the GUI figure (not visible)
hOut = figure(...
    'PaperUnits','points',...
    'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'IntegerHandle','off',...
    'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
    'MenuBar','none',...
    'Name','kview',...
    'NumberTitle','off',...
    'PaperPosition',[7.09200297864125 70.9200297864125 226.94409531652 170.20807148739],...
    'PaperSize',[595.275552 841.889736],...
    'PaperType',get(0,'defaultfigurePaperType'),...
    'Position',[300 300 1100 340],...
    'Resize','on',...
    'HandleVisibility','off',...
    'UserData',[],...
    'Tag','main_GUI',...
    'Visible','off',...
    'CloseRequestFcn',@kviewGUI_CloseRequestFcn,...
    'WindowKeyPressFcn',@kviewGUI_KeyPressedCallback);
handles.(get(hOut,'Tag')) = hOut;


% Set GUI position in the middle of the screen
ScreenSize = get(0,'ScreenSize');
hOut.Position(1:2) = (ScreenSize(3:4)-hOut.Position(3:4))/2;


%% ---------------------------------------------- Graphic Section: Main ---

h = uiextras.VBox('Parent',hOut,'Tag','VBox1','Padding',5,'Spacing',5);
handles.(get(h,'Tag')) = h;


% ----------- Insert VBox1 content
h = uiextras.HButtonBox('Parent',handles.VBox1,'Tag','HButtonBox1','HorizontalAlignment','left','ButtonSize',[155 32],'Spacing',5);
handles.(get(h,'Tag')) = h;

h = uiextras.Grid('Parent',handles.VBox1,'Tag','Grid1','Spacing',5);
handles.(get(h,'Tag')) = h;

h = uiextras.HBox('Parent',handles.VBox1,'Tag','HBox2','Spacing',3);
handles.(get(h,'Tag')) = h;

h = uiextras.HBox('Parent',handles.VBox1,'Tag','HBox3','Spacing',3);
handles.(get(h,'Tag')) = h;

set(handles.VBox1,'Sizes',[40 -1 25 0]);
set(handles.VBox1,'MinimumSizes',[40 0 25 0]);


% ----------- Insert HButtonBox1 content
h = uicontrol(...
    'Parent',handles.HButtonBox1,...
    'Callback',{@kviewImportFromMatlab,0,'workspace'},...
    'CData',[],...
    'FontSize',10,...
    'Position',[13 300 155 32],...
    'String','Import from WorkSpace',...
    'Tag','ImportFromWS');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HButtonBox1,...
    'Callback',{@kviewImportFile,0},...
    'FontSize',10,...
    'Position',[334 300 155 32],...
    'String','Import from File',...
    'Tag','import_file');
handles.(get(h,'Tag')) = h;



% ----------- Insert Grid1 content
h = uicontrol(...
    'Parent',handles.Grid1,...
    'BackgroundColor',[1 1 1],... 
    'Callback',@Listbox_Callback,...
    'FontSize',10,...
    'Max',10,...
    'Min',1,...
    'Style','listbox',...
    'String',{},...
    'Value',1,...
    'Tag','listbox1',...
    'KeyPressFcn',@kviewListbox_KeyPressedCallback);
handles.(get(h,'Tag')) = h;

h = uiextras.Empty('Parent',handles.Grid1,'Tag','Empty1');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.Grid1,...
    'BackgroundColor',[1 1 1],... 
    'Callback',@Listbox_Callback,...
    'FontSize',10,...
    'Max',10,...
    'Style','listbox',...
    'String',{},...
    'Value',1,...
    'Tag','listbox2',...
    'KeyPressFcn',@kviewListbox_KeyPressedCallback);
handles.(get(h,'Tag')) = h;

h = uiextras.Empty('Parent',handles.Grid1,'Tag','Empty2');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.Grid1,...
    'BackgroundColor',[1 1 1],... 
    'Callback',@Listbox_Callback,...
    'FontSize',10,...
    'Max',10,...
    'Style','listbox',...
    'String',{},...
    'Value',1,...
    'Tag','listbox3',...
    'KeyPressFcn',@kviewListbox_KeyPressedCallback);
handles.(get(h,'Tag')) = h;

h = uiextras.HBox('Parent',handles.Grid1,'Tag','HBox1');
handles.(get(h,'Tag')) = h;

h = uiextras.VBox('Parent',handles.Grid1,'Tag','VBox2','Spacing',5);
handles.(get(h,'Tag')) = h;

h = uiextras.Empty('Parent',handles.Grid1,'Tag','Empty3');
handles.(get(h,'Tag')) = h;

set(handles.Grid1','ColumnSizes',[-1 -1 -1 132],'RowSizes',[-1 25]);


% ----------- Insert HBox1 content
h = uicontrol(...
    'Parent',handles.HBox1,...
    'Callback',@XAxisSetDefault_Callback,...
    'String','Set default',...
    'Tag','XAxisSet_pushbutton');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HBox1,...
    'FontSize',9,...
    'FontWeight','bold',...
    'HorizontalAlignment','left',...
    'String','X axis: ',...
    'Style','text',...
    'Tag','XAxisStatic');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HBox1,...
    'FontSize',9,...
    'HorizontalAlignment','left',...
    'String','None',...
    'Style','text',...
    'Tag','XAxisVarName');
handles.(get(h,'Tag')) = h;

set(handles.HBox1,'Sizes',[70 50 -1]);

% ----------- Insert VBox2 content 

h = uicontrol(...
    'Parent',handles.VBox2,...
    'Callback',{@kviewPlot,'NewFigure'},...
    'FontSize',10,...
    'String','New Plot',...
    'Tag','new_plot');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.VBox2,...
    'Callback',{@kviewPlot,'CurrentFigure'},...
    'FontSize',10,...
    'String','Add to Current Plot',...
    'Tag','AddToCurrentPlot');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.VBox2,...
    'BackgroundColor',[1 1 1],...
    'FontSize',9,...
    'HorizontalAlignment','left',...
    'String',{'New Figure'; 'Current Figure'},...
    'Style','popupmenu',...
    'TooltipString','Select in which figure you want to plot',...
    'Value',1,...
    'Tag','TargetFigure');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.VBox2,...
    'FontSize',10,...
    'String','Dynamic Plot',...
    'Style','checkbox',...
    'Tag','DynamicPlotCheck',...
    'Value',0);
handles.(get(h,'Tag')) = h;

h = uiextras.Empty('Parent',handles.VBox2,'Tag','Empty4');
handles.(get(h,'Tag')) = h;


set(handles.VBox2,'MinimumSizes',[32 32 32 20 32],'Sizes',[32 32 32 20 32]);


% ----------- Insert HBox2 content

h = uiextras.Empty('Parent',handles.HBox2,'Tag','Empty5');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HBox2,...
    'BackgroundColor',[1 1 1],...
    'Callback',@(hObject,eventdata)kviewOLD('CustomMenu_popupmenu_Callback',hObject,eventdata,guidata(hObject),1),...
    'FontSize',10,...
    'String',{  '-- None --'; 'Offset and Gain'; 'Custom Buttons 1'; 'Custom Buttons 2'; 'Custom Buttons 3' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','CustomMenu1_popupmenu');
handles.(get(h,'Tag')) = h;

h = uiextras.Empty('Parent',handles.HBox2,'Tag','Empty6');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HBox2,...
    'BackgroundColor',[1 1 1],...
    'Callback',@(hObject,eventdata)kviewOLD('CustomMenu_popupmenu_Callback',hObject,eventdata,guidata(hObject),2),...
    'FontSize',10,...
    'String',{  '-- None --'; 'Offset and Gain'; 'Custom Buttons 1'; 'Custom Buttons 2'; 'Custom Buttons 3' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','CustomMenu2_popupmenu');
handles.(get(h,'Tag')) = h;

h = uiextras.Empty('Parent',handles.HBox2,'Tag','Empty7');
handles.(get(h,'Tag')) = h;

set(handles.HBox2,'MinimumSizes',[0 200 0 200 0],'Sizes',[-1 200 -2 200 -1]);


% ----------- Insert HBox3 content

h = uiextras.Empty('Parent',handles.HBox3,'Tag','Empty8');
handles.(get(h,'Tag')) = h;

h = uipanel(...
    'Parent',handles.HBox3,...
    'Units','pixels',...
    'FontSize',10,...
    'Clipping','on',...
    'Tag','CustomPanel1');
handles.(get(h,'Tag')) = h;

h = uiextras.Empty('Parent',handles.HBox3,'Tag','Empty9');
handles.(get(h,'Tag')) = h;

h = uipanel(...
    'Parent',handles.HBox3,...
    'Units','pixels',...
    'FontSize',10,...
    'Clipping','on',...
    'Tag','CustomPanel2');
handles.(get(h,'Tag')) = h;

h = uiextras.Empty('Parent',handles.HBox3,'Tag','Empty10');
handles.(get(h,'Tag')) = h;

set(handles.HBox3,'MinimumSizes',[0 200 0 200 0],'Sizes',[-1 540 -2 540 -1]);


%% ------------------------------------------------------- Context Menu ---

% Create Context Menu
h = uicontextmenu(...
    'Parent',handles.main_GUI,...
    'Tag','listbox1ContextMenu');
set(handles.listbox1,'uicontextmenu', h);
handles.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',handles.main_GUI,...
    'Tag','listbox2ContextMenu');
set(handles.listbox2,'uicontextmenu', h);
handles.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',handles.main_GUI,...
    'Tag','listbox3ContextMenu');
set(handles.listbox3,'uicontextmenu', h);
handles.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',handles.main_GUI,...
    'Tag','ImportFromFileMenu');
set(handles.import_file,'uicontextmenu', h);
handles.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',handles.main_GUI,...
    'Tag','ImportFromWSMenu');
set(handles.ImportFromWS,'uicontextmenu', h);
handles.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',handles.main_GUI,...
    'Callback',@StandardXaxisMenu_Callback,...
    'Tag','StandardXaxisMenu');
set(handles.XAxisSet_pushbutton,'uicontextmenu', h);
handles.(get(h,'Tag')) = h;


%% --------------------------------------------------------------- Menu ---


% --- File Menu

h = uimenu(...
    'Parent',handles.main_GUI,...
    'Label','File',...
    'Tag','file_menu');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.file_menu,...
    'Callback',@kvSave,...
    'Label','Save',...
    'Tag','file_menu_save');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.file_menu,...
    'Label','Export to',...
    'Separator','on',...
    'Tag','ExportTo');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.ExportTo,...
    'Callback',@kvEportToExcel,...
    'Label','File excel (.xls)',...
    'Tag','export_to_excel');
handles.(get(h,'Tag')) = h;


% --- Edit Menu
h = uimenu(...
    'Parent',handles.main_GUI,...
    'Label','Edit',...
    'Tag','edit_menu');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.edit_menu,...
    'Label','Undo',...
    'Enable','off',...
    'Tag','undo_menu','Accelerator','z');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.edit_menu,...
    'Label','Redo',...
    'Enable','off',...
    'Tag','redo_menu','Accelerator','y');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.edit_menu,...
    'Label','Sort',...
    'Tag','sort_menu',...
    'Separator','on');
handles.(get(h,'Tag')) = h;

for ii = 1:3
    
    h = uimenu(...
        'Parent',handles.sort_menu,...
        'Label',['Listbox ' int2str(ii)],...
        'Tag',['sl' int2str(ii) '_menu']);
    handles.(get(h,'Tag')) = h;
    
    h = uimenu(...
        'Parent',handles.(['sl' int2str(ii) '_menu']),...
        'Label','Original',...
        'Callback',{@SortMenu_Callback,ii,1},...
        'Tag',['sl' int2str(ii) '_orig_menu']);
    handles.(get(h,'Tag')) = h;
    
    h = uimenu(...
        'Parent',handles.(['sl' int2str(ii) '_menu']),...
        'Label','Ascii',...
        'Callback',{@SortMenu_Callback,ii,2},...
        'Tag',['sl' int2str(ii) '_ascii_menu']);
    handles.(get(h,'Tag')) = h;
    
    h = uimenu(...
        'Parent',handles.(['sl' int2str(ii) '_menu']),...
        'Label','Alphabetical',...
        'Callback',{@SortMenu_Callback,ii,3},...
        'Tag',['sl' int2str(ii) '_alphab_menu']);
    handles.(get(h,'Tag')) = h;
    
end


% --- Settings Menu
h = uimenu(...
    'Parent',handles.main_GUI,...
    'Label','Settings',...
    'Tag','settings_menu');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.settings_menu,...
    'Callback',@kvGenericSettingsGUI,...
    'Label','Generic',...
    'Tag','import_settings');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.settings_menu,...
    'Label','Import Settings',...
    'Separator','on',...
    'Tag','import_settings');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.import_settings,...
    'Callback',@(hObject,~)ImportSettings(guidata(hObject),1),...
    'Label','From File',...
    'Tag','impsett_fromfile');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.import_settings,...
    'Callback',@(hObject,~)ImportSettings(guidata(hObject),2),...
    'Label','From WorkSpace',...
    'Tag','impsett_fromws');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.settings_menu,...
    'Callback',@(hObject,~)CustomButtonsSettings(guidata(hObject)),...
    'Label','Custom Buttons Sett.',...
    'Tag','custombuttonsett_menu');
handles.(get(h,'Tag')) = h;


% --- Info Menu
h = uimenu(...
    'Parent',handles.main_GUI,...
    'Label','Info',...
    'Tag','info_menu');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.info_menu,...
    'Callback',@(~,~)open(fullfile(fileparts(which('kview.m')),'html','mainpage.html')),...
    'Label','Documentation',...
    'Tag','documentation_menu');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.info_menu,...
    'Callback',@CreditsWindow,...
    'Label','Credits',...
    'Separator','on',...
    'Tag','credits_menu');
handles.(get(h,'Tag')) = h;


% --- Listbox Menu

h = uimenu(...
    'Parent',handles.listbox3ContextMenu,...
    'Callback',@SetXAxis_Callback,...
    'Label','Set as X axis',...
    'Tag','SetXAxis');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.listbox3ContextMenu,...
    'Callback',@(hObject,eventdata)kviewOLD('ExpSingleVarToWs_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Export to WS',...
    'Separator','on',...
    'Tag','ExpSingleVarToWs');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.listbox3ContextMenu,...
    'Callback',@(hObject,eventdata)kviewOLD('ImportSingleVarFromWS_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Import from WS',...
    'Tag','ImportSingleVarFromWS');
handles.(get(h,'Tag')) = h;


for ii = 1:3

    h = uimenu(...
        'Parent',handles.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@CutElement_Callback,handles.(['listbox' int2str(ii)])},...
        'Label','Cut',...
        'Tag',['l' int2str(ii) '_cut_element']);
    handles.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',handles.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@CopyElement_Callback,handles.(['listbox' int2str(ii)])},...
        'Label','Copy',...
        'Tag',['l' int2str(ii) '_copy_element']);
    handles.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',handles.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@PasteElement_Callback,handles.(['listbox' int2str(ii)])},...
        'Label','Paste',...
        'Tag',['l' int2str(ii) '_paste_element']);
    handles.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',handles.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@DeleteElement_Callback,handles.(['listbox' int2str(ii)])},...
        'Label','Delete',...
        'Separator','on',...
        'Tag',['l' int2str(ii) '_delete_element']);
    handles.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',handles.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@RenameElement_Callback,handles.(['listbox' int2str(ii)])},...
        'Label','Rename',...
        'Tag',['l' int2str(ii) '_rename_element']);
    handles.(get(h,'Tag')) = h;
    
end
set(handles.l3_cut_element,'Separator','on');

h = uimenu(...
    'Parent',handles.listbox1ContextMenu,...
    'Label','Send To',...
    'Separator','on',...
    'Tag','send_to_1');
handles.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',handles.send_to_1,...
        'Callback',@(hObject,eventdata)kviewOLD('export_to_ws_Callback',hObject,eventdata,guidata(hObject)),...
        'Label','Workspace',...
        'Tag','send_to_1_workspace');
    handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.listbox1ContextMenu,...
    'Callback',@DatasetConversion_Callback,...
    'Label','Dataset Conversion',...
    'Separator','on',...
    'Tag','DatasetConversion');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.listbox3ContextMenu,...
    'Callback',@ChangeUnit_Callback,...
    'Label','Change Unit',...
    'Separator','on',...
    'Tag','ChangeUnitMenu');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.ImportFromFileMenu,...
    'Callback',{@kviewImportFile,1},...
    'Label','with Conversion Table 1',...
    'Tag','iff_wConvTable1');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.ImportFromFileMenu,...
    'Callback',{@kviewImportFile,2},...
    'Label','with Conversion Table 2',...
    'Tag','iff_wConvTable2');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.ImportFromFileMenu,...
    'Callback',{@kviewImportFile,3},...
    'Label','with Conversion Table 3',...
    'Tag','iff_wConvTable3');
handles.(get(h,'Tag')) = h;


h = uimenu(...
    'Parent',handles.ImportFromWSMenu,...
    'Callback',{@kviewImportFromMatlab,1,'workspace'},...
    'Label','with Conversion Table 1',...
    'Tag','ifws_wConvTable1');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.ImportFromWSMenu,...
    'Callback',{@kviewImportFromMatlab,2,'workspace'},...
    'Label','with Conversion Table 2',...
    'Tag','ifws_wConvTable2');
handles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',handles.ImportFromWSMenu,...
    'Callback',{@kviewImportFromMatlab,3,'workspace'},...
    'Label','with Conversion Table 3',...
    'Tag','ifws_wConvTable3');
handles.(get(h,'Tag')) = h;


%% ---------------------------------------- Settings & Application Data ---

% Set custom property of the GUI (could not be done from GUIDE)
setappdata(hOut, 'IgnoreCloseAll', 1);
set(hOut, 'WindowStyle', 'normal');

% Preallocate some important appdata for kview
if ~isappdata(hOut,'FileImportDir')
    setappdata(hOut,'FileImportDir','');
end
if ~isappdata(hOut,'DatasetsStruct')
    setappdata(hOut,'DatasetsStruct',struct);
end
if ~isappdata(hOut,'ConvTableDir')
    ConvTableDir = strrep(which('kview.m'),'kview.m','ConversionTables');
    setappdata(hOut,'ConvTableDir',ConvTableDir);
end
if ~isappdata(hOut,'ButtonTableDir')
    ButtonTableDir = strrep(which('kview.m'),'kview.m','ButtonTables');
    setappdata(hOut,'ButtonTableDir',ButtonTableDir);
end

% Load settings parameter
guidata(hOut,handles);
kviewLoadSettings(hOut);

% set kvFigureProperty
kvFigureProperty.defaultAxesXLimMode = 'auto';
kvFigureProperty.defaultAxesXLim = [0 1];
kvFigureProperty.defaultAxesYLimMode = 'auto';
kvFigureProperty.defaultAxesYLim = [0 1];
kvFigureProperty.defaultAxesXGrid = 'on';
kvFigureProperty.defaultAxesYGrid = 'on';
kvFigureProperty.defaultAxesBox = 'on';
kvFigureProperty.defaultAxesFontSize = 16;
setappdata(hOut,'kvFigureProperty',kvFigureProperty);


% Set Other data
setappdata(hOut,'SortOrderMethod',{'original' 'alphabetical' 'alphabetical'});
set([handles.('sl1_orig_menu') handles.('sl2_alphab_menu') handles.('sl3_alphab_menu')] ,'Checked','on');
setappdata(hOut,'DynamicTargetHandle',hOut);  % preallocate with a generic handle (hOut used for convenience)
setappdata(hOut,'CopiedElements',{struct,0});
setappdata(hOut,'kviewColorOrder',get(0,'DefaultAxesColorOrder'));
setappdata(hOut,'kviewColorOrderMethod','Auto');
setappdata(hOut,'kviewLineStyleOrder',{'-','--','-.',':'});
setappdata(hOut,'kviewLineStyleOrderMethod','Auto');
setappdata(hOut,'kviewMarkerOrder',{'none'});
setappdata(hOut,'kviewLineWidth',1);
setappdata(hOut,'ShowLegend',false);


%% --------------------------------------------------- Output and Other ---

hsingleton = hOut;

guidata(hOut,handles);
set(hOut,'Visible','on');
drawnow;

end


function kviewGUI_CloseRequestFcn(hObject,~)
% Close request function to display a question dialog box 

selection = questdlg('You really want to close the kview?',...
    'Close kview',...
    'Yes','No','Yes'); 
switch selection, 
    case 'Yes'
        HideShowMatlab('Show'); % DEV NOTE: here to test this functionality
        delete(hObject);
    case 'No'
        return 
end

end


function SortMenu_Callback(hObject,~,ListboxNum,MethodNum)
% Function to select the sorting order of the listboxes.

% get handles
handles = guidata(hObject);

% change the checked option
set(get(get(hObject,'Parent'),'Children'),'Checked','off');
set(hObject,'Checked','on');

% store the choice in the MainGUI to be retrived by the RefreshListbox function
SortOrderMethod = getappdata(handles.main_GUI,'SortOrderMethod');
switch MethodNum
    
    case 1
        SortOrderMethod{ListboxNum} = 'original';
        
    case 2
        SortOrderMethod{ListboxNum} = 'ascii';
        
    case 3
        SortOrderMethod{ListboxNum} = 'alphabetical';       
        
end
setappdata(handles.main_GUI,'SortOrderMethod',SortOrderMethod);


% Refresh the listboxes to apply the new order
kviewRefreshListbox(handles.(['listbox' int2str(ListboxNum)]),[]);


end


function StandardXaxisMenu_Callback(hObject,~)
% This function create a Menu with the list of variables being contained in
% the subsystem selected for the default X axis. If clicked the variable is 
% set as the X axis.

% Clear ContextMenu from a previuos list
previous_list = get(hObject,'Children');
delete(previous_list);

% Get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
value_listbox1 = get(handles.listbox1,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
defaultXAxis = getappdata(handles.main_GUI,'defaultXAxis');


% Initialize XaxisList
if isempty(contents_listbox1)
	XaxisList = [];   
elseif isfield(DatasetsStruct.(contents_listbox1{value_listbox1(1)}),defaultXAxis{2})
    XaxisList = fieldnames(DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(defaultXAxis{2}));
    
    for jj=value_listbox1(2:end)
        
        if isfield(DatasetsStruct.(contents_listbox1{jj}),defaultXAxis{2})
            ListTmp=fieldnames(DatasetsStruct.(contents_listbox1{jj}).(defaultXAxis{2}));
        else
            XaxisList = [];
            break
        end
        
        for ii=XaxisList.'
            if isempty(ii)
                continue
            elseif ~any(strcmp(ii,ListTmp))
                XaxisList(strcmp(ii,XaxisList)) = [];
            end
        end
        
    end
    
else
    XaxisList = [];
end

uimenu(...
    'Parent',hObject,...
    'Callback',{@CreateStandardXaxisList,''},...
    'Label','None');


for ii = 1:length(XaxisList)
    h = uimenu(...
        'Parent',hObject,...
        'Callback',{@CreateStandardXaxisList,XaxisList{ii}},...
        'Label',XaxisList{ii});
    if ii == 1
        set(h,'Separator','on');
    end
end



% --- Nested Function

    function CreateStandardXaxisList(~,~,XaxisVarName)
        if isempty(XaxisVarName)
            setappdata(handles.main_GUI,'XAxisSubsysName','');
            set(handles.XAxisVarName,'String','None');           
        else
            setappdata(handles.main_GUI,'XAxisSubsysName',defaultXAxis{2});
            set(handles.XAxisVarName,'String',XaxisVarName);
        end
        setappdata(handles.main_GUI,'XAxisVarName',XaxisVarName);
    end

end


function Listbox_Callback(hObject, eventdata)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

handles = guidata(hObject);
ListboxContent = cellstr(get(hObject,'String'));
DynamicCheckValue = get(handles.DynamicPlotCheck,'Value');


kviewRefreshListbox(hObject, eventdata);


if isempty(ListboxContent)||strcmp(ListboxContent{1},'')   % DEV NOTE: the second part can be taken out. An empty listbox should have {} and not {''}. The second is an error in the code.
    return
end


if strcmp(get(handles.main_GUI,'SelectionType'),'open')
    kviewPlot(hObject,[],'Click');
elseif DynamicCheckValue == 1
	kviewPlot(hObject,[],'Dynamic');
end

end


function varargout = CopyElement_Callback(hObject,~,ListboxHandle)

% get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
varargout{1} = true;


switch get(ListboxHandle,'tag')
    
    case 'listbox1'   
        ListboxNum = 1;
        for ii = value_listbox1
            CopiedElements.(contents_listbox1{ii}) = DatasetsStruct.(contents_listbox1{ii});
        end
        
        
    case 'listbox2'
        ListboxNum = 2;    
        if length(value_listbox1)>1
            display('ERROR: Cannot copy. Too many Datasets selected.');
            varargout{1} = false;
            return
        end
        for jj = value_listbox2
            CopiedElements.(contents_listbox2{jj}) = DatasetsStruct.(contents_listbox1{value_listbox1}).(contents_listbox2{jj});
        end
        
    case 'listbox3'
        ListboxNum = 3;
        if length(value_listbox1)>1 || length(value_listbox2)>1
            display('ERROR: Cannot copy. Too many Datasets or Subsystems selected.');
            varargout{1} = false;
            return
        end
        for kk = value_listbox3
            CopiedElements.(contents_listbox3{kk}) = DatasetsStruct.(contents_listbox1{value_listbox1}).(contents_listbox2{value_listbox2}).(contents_listbox3{kk});
        end
        
end

% store the data into the GUI
setappdata(handles.main_GUI,'CopiedElements',{CopiedElements,ListboxNum});

end


function CutElement_Callback(hObject,~,ListboxHandle)
% This function wraps CopyElement_Callback and DeleteElement_Callback

Success = CopyElement_Callback(hObject,[],ListboxHandle);

if Success
    DeleteElement_Callback(hObject,[],ListboxHandle,false);
end

end


function PasteElement_Callback(hObject,~,ListboxHandle)

% get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
CopiedElements = getappdata(handles.main_GUI,'CopiedElements');
PasteName = cell(1,length(fieldnames(CopiedElements{1})));
PNum = 0;

% Check if the correct listbox is selected.
if ~strcmp(get(ListboxHandle,'tag'),['listbox' int2str(CopiedElements{2})])
    return
end

if ( CopiedElements{2}>1 && length(value_listbox1)>1 ) || ( CopiedElements{2}>2 && length(value_listbox2)>1 )
    if strcmp(questdlg('You are pasting the data in more than one Dataset/Subsystem. Are you sure?','Multiple Paste','Yes','No','Yes'),'No')
        return
    end
end

switch get(ListboxHandle,'tag')
    
    case 'listbox1'
        
        for ii = fieldnames(CopiedElements{1})'
            
            PNum = PNum + 1;
            PasteName{PNum} = CheckFieldName(DatasetsStruct,ii{1});
            DatasetsStruct.(PasteName{PNum}) = CopiedElements{1}.(ii{1});
            
        end
        
        
    case 'listbox2'
        
        for ii = value_listbox1
            for jj = fieldnames(CopiedElements{1})'
                
                PNum = PNum + 1;
                PasteName{PNum} = CheckFieldName(DatasetsStruct.(contents_listbox1{ii}),jj{1});
                DatasetsStruct.(contents_listbox1{ii}).(PasteName{PNum}) = CopiedElements{1}.(jj{1});
                
            end
        end
      
        
    case 'listbox3'
        
        for ii = value_listbox1
            for jj = value_listbox2
                for kk = fieldnames(CopiedElements{1})'
                    
                    PNum = PNum + 1;
                    PasteName{PNum} = CheckFieldName(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}),kk{1});
                    DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(PasteName{PNum}) = CopiedElements{1}.(kk{1});
                    
                end
            end
        end
      
end



% Update the DatasetsStruct
setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);
kviewRefreshListbox(ListboxHandle,[]);

% Select the pasted datasets
NewListboxValue = [];
SelectedListboxHandle = get(ListboxHandle,'String');
for ii = PasteName
    NewListboxValue = [NewListboxValue find(strcmp(ii,SelectedListboxHandle))];
end 
set(ListboxHandle,'Value',NewListboxValue);
kviewRefreshListbox(ListboxHandle,[]);


%% ---------------------------------------------------- Nested Function ---

    % Check if the copied elements can fit into the focused listbox and if
    % there is already a field with the same name.
    function PasteName = CheckFieldName(ContainerStruct,FieldName)
        
        % Check if the pasting name is already taken
        PasteName = FieldName;
        if isfield(ContainerStruct,PasteName)
            PasteName = [FieldName '_Copy'];
        end 
        if isfield(ContainerStruct,PasteName)
            Num = 2;
            while isfield(ContainerStruct,[PasteName int2str(Num)])
                Num = Num + 1;
                if Num > 1000
                    display('ERROR: it seems that there are more than 1000 copied elements with the same name.');
                    display('To avoid infinite loops the Paste action was blocked');
                    return
                end
            end       
            PasteName = [PasteName int2str(Num)];
        end
    end


end


function DeleteElement_Callback(hObject,~,ListboxHandle,varargin)
% Optional input is AskConfim (true or false). Used for the Cut callback.


% get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
AskConfirm = true;

if length(varargin)>0
    AskConfirm = varargin{1};
end

if AskConfirm
    if strcmp(questdlg('Are you sure?','Delete','Yes','No','Yes'),'No')
        return
    end
end

switch get(ListboxHandle,'tag')
    
    case 'listbox1'      
        ListboxHandle = handles.listbox1;
        for ii=value_listbox1
            DatasetsStruct = rmfield(DatasetsStruct,contents_listbox1{ii});
        end
        set(handles.listbox1,'Value',1);
        set(handles.listbox1,'String',fieldnames(DatasetsStruct));
        
    case 'listbox2'   
        ListboxHandle = handles.listbox2;
        for ii=value_listbox1
            for jj=value_listbox2
                DatasetsStruct.(contents_listbox1{ii}) = rmfield(DatasetsStruct.(contents_listbox1{ii}),contents_listbox2{jj});
            end
        end       
        
    case 'listbox3'   
        ListboxHandle = handles.listbox3;
        for ii=value_listbox1
            for jj=value_listbox2
                for kk=value_listbox3
                    DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}) = rmfield(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}),contents_listbox3{kk});
                end
            end
        end

end

          
% Update and refresh GUI
setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);
kviewRefreshListbox(ListboxHandle,[]);

end


function RenameElement_Callback(hObject,~,ListboxHandle)
% ListboxHandle handle to se selected/focused listbox

% get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');

SelectedListboxContent = get(ListboxHandle,'String');
SelectedListboxValue = get(ListboxHandle,'Value');


% check number of items selected
if length(SelectedListboxValue)>1
    display('ERROR: you have selected too many items in the listbox. When you are renameing an item you can select only one at time.');
    return
end

% get new name
NewName = inputdlg('Enter new name:','Rename',[1 50],(SelectedListboxContent(SelectedListboxValue)),'on');

% check new name
if isempty(NewName)
    return
elseif strcmp(NewName{1},SelectedListboxContent(SelectedListboxValue))
    return
elseif ~isvarname(NewName{1})
    display(['ERROR: ' NewName{1} ' is not a valid name.']);
    return
elseif any(strcmp(NewName{1},SelectedListboxContent))
    choice = questdlg([NewName{1} ' already exhist. Overwrite it?'],'Overwrite dialog','Yes','No','No');
    if ~strcmp(choice,'Yes')
        return
    end
end
        
% act depending on the listbox focused
switch get(ListboxHandle,'tag')
    
    case 'listbox1'
        
        DatasetsStruct = RenameField(DatasetsStruct);
        
        
    case 'listbox2'
        
        for ii = value_listbox1
            DatasetsStruct.(contents_listbox1{ii}) = RenameField(DatasetsStruct.(contents_listbox1{ii}));
        end
        
    case 'listbox3'
        
        for ii = value_listbox1
            for jj = value_listbox2
                DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}) = RenameField(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}));
            end
        end
        
end


% update datasetstruct and listbox contents
setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);
kviewRefreshListbox(ListboxHandle,[]);

% Select the renamed dataset
set(ListboxHandle,'Value',find(strcmp(NewName{1},get(ListboxHandle,'String'))));

% refresh again
kviewRefreshListbox(ListboxHandle,[]);


% --- Nested Functions ---

    function TempStruct = RenameField(TempStruct)
        FieldNames = fieldnames(TempStruct);
        FieldNames(strcmp(SelectedListboxContent{SelectedListboxValue},FieldNames)) = NewName;
        
        TempStruct.(NewName{1}) = TempStruct.(SelectedListboxContent{SelectedListboxValue});
        TempStruct = rmfield(TempStruct,SelectedListboxContent{SelectedListboxValue});
        
        TempStruct = orderfields(TempStruct,FieldNames);
    end

end


function SetXAxis_Callback(hObject,~)

handles = guidata(hObject);
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');

if length(value_listbox2)==1 && length(value_listbox3)==1
    setappdata(handles.main_GUI,'XAxisVarName',contents_listbox3{value_listbox3});
    setappdata(handles.main_GUI,'XAxisSubsysName',contents_listbox2{value_listbox2});
    set(handles.XAxisVarName,'String',[contents_listbox2{value_listbox2} '.' contents_listbox3{value_listbox3}]);
else
    display('ERROR: you have selected too many subsystems or variables.')
end
end


function XAxisSetDefault_Callback(hObject,~)
% Reset the X axis to the default value.

handles = guidata(hObject);
defaultXAxis = getappdata(handles.main_GUI,'defaultXAxis');
setappdata(handles.main_GUI,'XAxisVarName',defaultXAxis{1});
setappdata(handles.main_GUI,'XAxisSubsysName',defaultXAxis{2});

if isempty(defaultXAxis{1})
    set(handles.XAxisVarName,'String','None');
else
    set(handles.XAxisVarName,'String',defaultXAxis{1});
end

end


function DatasetConversion_Callback(hObject,~)
% Function to apply a dataset conversion table from the GUI.

handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
value_listbox1 = get(handles.listbox1,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
ConvTableDir = getappdata(handles.main_GUI,'ConvTableDir');

% Initialize data
DatasetsToConvert = cell(1,length(value_listbox1));

% Select the conversion table
[ConvTableName,ConvTableDir,FilterIndex] = uigetfile('*.convtable','Select the Conversion Table',ConvTableDir); 
if FilterIndex == 0
    return
end

% Group all the Datasets that will be converted 
for ii = 1:length(value_listbox1)
    DatasetsToConvert{ii} = DatasetsStruct.(contents_listbox1{value_listbox1(ii)});
end

% Do the conversion (use external function)
DatasetsConverted = kview_DatasetConversion(DatasetsToConvert,'FileName',ConvTableName,'FileDir',ConvTableDir);

% Re-insert all the converted Datasets to the main DatasetsStruct 
for ii = 1:length(value_listbox1)
    DatasetsStruct.(contents_listbox1{value_listbox1(ii)}) = DatasetsConverted{ii};
end

% Update GUI
setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);
setappdata(handles.main_GUI,'ConvTableDir',ConvTableDir);
kviewRefreshListbox(handles.listbox1);

end


function ChangeUnit_Callback(hObject,~)
% Function to change the unit type.


%% ----------------------------------------------------- Initialization ---

% get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');


ImposeUnitTrue = 0;


% SI dimension of the first unit selected
if ~isfield(DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(contents_listbox2{value_listbox2(1)}).(contents_listbox3{value_listbox3(1)}),'unit') % if the unit field does not exist auto correct the problem and create it (empty).
    SI_ref = '';
else
    SI_ref = unit(DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(contents_listbox2{value_listbox2(1)}).(contents_listbox3{value_listbox3(1)}).unit).name;
end
OriginalUnit = DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(contents_listbox2{value_listbox2(1)}).(contents_listbox3{value_listbox3(1)}).unit;


% Check if the conversion can be done on all units and if they are of the
% same kind (length, mass, torque, etc...)
for ii=value_listbox1(1:end)
    for jj=value_listbox2(1:end)
        for kk=value_listbox3(1:end)
            if ~isfield(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}),'unit');
                  DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit = ''; % if the unit field does not exist auto correct the problem and create it (empty).
            end
            if ~strcmp(SI_ref,unit(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit).name)
                display('Error: not all variable have units of the same kind.');
                return
            end
            if all(~strcmp(OriginalUnit,{'diverse' DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit}))
                OriginalUnit = 'diverse';
            end
        end
    end
end


%% ------------------------------------------------------ Select ToUnit ---

% Create a list of possibilities depending on the unit type
switch SI_ref
    case 's'                            % time
        UnitList = {'s'};
    case '1/s'                          % frequency
        UnitList = {'Hz'};
    case 'm'                            % length
        UnitList = {'km','m','mm'};
    case 'm/s'                          % velocity
        UnitList = {'km/h','m/s'};
    case 'm/s^2'                        % acceleration
        UnitList = {'m/s^2','g'};
    case 'rad'                          % angle
        UnitList = {'rad','deg','round'};
    case 'rad/s'                        % angular velocity
        UnitList = {'rad/s','deg/s','rpm'};
    case 'rad/s^2'                      % angluar acceleration
        UnitList = {'rad/s^2','deg/s^2'};
    case 'kg/m/s^2'                     % pression
        UnitList = {'bar','Pa','MPa'};
    case 'm*kg/s^2'                     % force
        UnitList = {'N'};
    case 'm^2*kg/s^2'                   % moment
        UnitList = {'Nm','kgm'};
    case ''                             % empty/no unit
        UnitList = {};
        
    otherwise
        disp(['ERROR: the unit of variable ' contents_listbox1{ii} '.' contents_listbox2{jj} '.' contents_listbox3{kk} ' was not recognized.']);
        disp('Check if the variable has a valid unit, otherwise the current version of kview may not be able to recognize that unit.');
        disp('Only the "Impose Unit" option will be available.');
        UnitList = {};
        
end


UnitList{end+1} = 'Impose Unit';
choice = kvunitseldlg(UnitList,OriginalUnit);

if choice == 0 
    display('Unit conversion cancelled.');
    return
end

ToUnit = UnitList{choice};


% In case "Impose Unit" is selected
if strcmp(ToUnit,'Impose Unit')
    ImposeUnitTrue = 1;
    UnitList = {'km','m','mm',...
        'km/h','m/s',...
        'm/s^2','g',...
        's',...
        'rad','deg','round',...
        'rad/s','deg/s','rpm',...
        '1/s','Hz',...
        'rad/s^2','deg/s^2',...
        'bar','Pa','MPa',...
        'N',...
        'Nm','kgm',...
        'no unit'};
    choice = kvunitseldlg(UnitList,OriginalUnit);
    if choice == 0 
        display('Unit conversion cancelled.');
        return
    end
    ToUnit = UnitList{choice};
    if strcmp(ToUnit,'no unit')
        ToUnit = '';
    end
end


%% ---------------------------------------------------- Unit Conversion ---


% Perform the unit conversion
for ii=value_listbox1(1:end)
    for jj=value_listbox2(1:end)
        for kk=value_listbox3(1:end)
            if ImposeUnitTrue
                DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit = ToUnit;
            else
                DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk})= kviewConvUnit(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}),ToUnit);
            end
        end
    end
end


%% ------------------------------------------------------ End and Other ---

% save the updated Datasets Structure
setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);



end


% --- Import/Export Functions ---

function varargout = kviewImportFromMatlab(hObject,~,ConvertData,MatSource,varargin)
% Import data from the workspace or from a .mat file.
%
% DESCRIPTION:
%
%
%
% SYNTAX:
%   kviewImportFromMatlab(hObject,eventdata,ConvertData,MatSource)
%   kviewImportFromMatlab(hObject,eventdata,ConvertData,MatSource,'-all')
%   kviewImportFromMatlab(hObject,eventdata,ConvertData,MatSource,File,FDataName)
%   kviewImportFromMatlab(hObject,eventdata,ConvertData,MatSource,File,FDataName,'-all')
%   [Datasets, DatasetsNames] = kviewImportFromMatlab(__)
%
%
% INPUT:
%   hObject         handle to one object of the GUI. Any object is fine: it
%                   is needed only to retrive data from the figure.
%   eventdata       unused.
%   ConvertData     0 - no conversion
%                   1,2,3 - use the corresponding import conversion settings
%   MatSource       string variable; can be "workspace" or "file"
%
% INPUT [OPTIONAL]:
%   File            file .mat to be imported
%   FDataName       name that will be given to the dataset when importing
%                   the variables contained in the file
%   '-all'          if this optional argument is used, the selection GUI
%                   won't be shown and all the variables will be
%                   automatically imported
%
% OUTPUT [OPTIONAL]:
%   Datasets        datasets imported
%   DatasetsNames   names of the datasets 
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    13/05/2015
%   Author:  Michele Oro Nobili 


%% ---------------------------------------------------- Initialize data ---
 
% Get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
defaultXAxis = getappdata(handles.main_GUI,'defaultXAxis');

% Initialize data
DatasetsName = fieldnames(DatasetsStruct);
choice = 'Yes';
MatDatasetTemp = struct;
NewDatasets = {};
NewDatasetsNames = {};
ImportAll = false;


if nargin > 4
    if any(strcmp(varargin,'-all'))
        ImportAll = true;
    end
end
        
    

% Check number of outputs
if nargout == 2
    varargout{1}= [];
    varargout{2}= [];
elseif nargout ~= 0
    error('wrong number of outputs.');
end


% Get Base WorkSpace variables
switch MatSource
    case 'workspace'
        MatVar = evalin('base','whos');
        MatImportFunc = @(x) evalin('base',x);
    case 'file'
        MatVar = whos('-file',varargin{1});
        MatImportFunc = @(x) getfield(load(varargin{1},x),x);
    otherwise
        error('Source string was not recognized. Accepted value are "workspace" or "file"');
end 
MatVar(strcmp({MatVar.name},'ans')) = [];

% Pass to the selection dialog only the supported classes
ToDelete = true(1,length(MatVar));
for ii = 1:length(MatVar)
    if any(strcmp(MatVar(ii).class,{'timeseries','tscollection'}))
        ToDelete(ii) = false;
    elseif strcmp(MatVar(ii).class,'struct')
        ToDelete(ii) = false;
        if iskvstruct(MatImportFunc(MatVar(ii).name))
            MatVar(ii).class = 'kvstruct';
        end            
    elseif any(strcmp(MatVar(ii).class,{'logical','single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'}))
        ToDelete(ii) = all(MatVar(ii).size<2); % single value/parameter
    end
end
MatVar(ToDelete) = [];


%% --------------------------------------------------- Selection dialog ---

if ImportAll
    VarToImport = MatVar;
else
    [VarToImport,ImportMode] = kvimportdlg(MatVar,handles.main_GUI);
end

if isempty(VarToImport)
    return
end


%% ------------------------------------------------------------- Import ---

for ii = 1:length(VarToImport)
    
    switch VarToImport(ii).class
        
        case {'logical','single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'}
            TempVar = MatImportFunc(VarToImport(ii).name);
            if all(size(TempVar) > 1)
                for jj=1:length(TempVar(1,:)) % import as column arrays
                    MatDatasetTemp.(VarToImport(ii).name).(['value_' int2str(jj)]).data = TempVar(:,jj);
                    MatDatasetTemp.(VarToImport(ii).name).(['value_' int2str(jj)]).unit = '';
                end
            else
                if size(TempVar,2) > 1
                	TempVar = TempVar';
                end
                MatDatasetTemp.(VarToImport(ii).name).value.data = TempVar;
                MatDatasetTemp.(VarToImport(ii).name).value.unit = '';
            end
            
        case {'kvstruct','struct'}
            
            if any(strcmp(VarToImport(ii).name,DatasetsName))      
                if ~any(strcmp(choice,{'YesAll','NoAll'}))
                    choice = kvoverwritedlg(VarToImport(ii).name);
                end
            else 
                choice = 'Yes';
            end
            
            switch choice

                case {'No','NoAll'}
                    continue

                case {'Yes','YesAll'}
                    NewDatasetsNames{end+1} = VarToImport(ii).name;
                    NewDatasets{end+1} = MatImportFunc(VarToImport(ii).name);

                case ''
                    disp('Importing process interrupted.');
                    return
            end 

            
        case 'timeseries'
            
            tsTemp = MatImportFunc(VarToImport(ii).name);
            
            % Time
            MatDatasetTemp.(VarToImport(ii).name).Time.data = tsTemp.Time;
            MatDatasetTemp.(VarToImport(ii).name).Time.unit = tsTemp.TimeInfo.Unit;
            
            % Data
            MatDatasetTemp.(VarToImport(ii).name).value.data = tsTemp.Data;
            MatDatasetTemp.(VarToImport(ii).name).value.unit = tsTemp.DataInfo.Units;
            
            
        case 'tscollection'
            
            if any(strcmp(VarToImport(ii).name,DatasetsName))      
                if ~any(strcmp(choice,{'YesAll','NoAll'}))
                    choice = kvoverwritedlg(VarToImport(ii).name);
                end
            else 
                choice = 'Yes';
            end
            
            switch choice

                case {'No','NoAll'}
                    continue

                case {'Yes','YesAll'} 
                    tscTemp = MatImportFunc(VarToImport(ii).name);
                    tscDatasetTemp = struct;
                    
                    % Time
                    tscDatasetTemp.Time.Time.data = tscTemp.Time;
                    tscDatasetTemp.Time.Time.unit = tscTemp.TimeInfo.Units;
                    
                    if ~isempty(defaultXAxis{2})
                        tscDatasetTemp.(defaultXAxis{2}).Time.data = tscTemp.Time;
                        tscDatasetTemp.(defaultXAxis{2}).Time.unit = tscTemp.TimeInfo.Units;
                    end
                    

                    % Data
                    for jj = fieldnames(get(tscTemp))'
                        if isa(tscTemp.(jj{1}),'timeseries')
                            tscDatasetTemp.(jj{1}).value.data = tscTemp.(jj{1}).Data;
                            tscDatasetTemp.(jj{1}).value.unit = tscTemp.(jj{1}).DataInfo.Units;
                        end   
                    end


                    % Add dataset to the cell array for import
                    NewDatasetsNames{end+1} = VarToImport(ii).name;
                    NewDatasets{end+1} = tscDatasetTemp;

                case ''
                    disp('Importing process interrupted.');
                    return
            end 
                       
            
        otherwise
            error([VarToImport(ii).name ' class not supported.']);
            
    end
    
end
    
    
if ~isempty(fieldnames(MatDatasetTemp))
    if strcmp(MatSource,'workspace')
        ii = 1;
        while any(strcmp(['workspace_' num2str(ii)],contents_listbox1))
            ii = ii + 1;
        end
        NewDatasetsNames{end+1} = ['workspace_' int2str(ii)];
    else
        NewDatasetsNames{end+1} = varargin{2};
    end
    NewDatasets{end+1} = MatDatasetTemp;
end

if nargout == 2
    varargout{1} = NewDatasets;
    varargout{2} = NewDatasetsNames;
    return 
end

%% --------------------------------------------------------- Conversion ---

if ConvertData ~= 0     
    % get data
    ImpConvSett = getappdata(handles.main_GUI,'ImpWSConvSett');
        
    for ii = 1:length(ImpConvSett{ConvertData}(:,1))
        
        if ~isempty(ImpConvSett{ConvertData}{ii,1})
            ConvTableDir = ImpConvSett{ConvertData}{ii,1};
            ConvTableName = ImpConvSett{ConvertData}{ii,2};
            ConvDirection = ImpConvSett{ConvertData}{ii,3};
            
            % Do the conversion
            NewDatasets = kview_DatasetConversion(NewDatasets,'FileName',ConvTableName,'FileDir',ConvTableDir,'ConvDirection',ConvDirection);
            
        end
        
    end
            
end


%% ----------------------------------------------- Update DatasetsSruct ---

for ii = 1:length(NewDatasetsNames)
    DatasetsStruct.(NewDatasetsNames{ii}) = NewDatasets{ii};
end

set(handles.listbox1,'String',fieldnames(DatasetsStruct));


% Automatically select the new elements in listbox1. 
TempValueListbox1 = cellfun(@(x) find(strcmp(x,fieldnames(DatasetsStruct))),NewDatasetsNames);
set(handles.listbox1,'Value',TempValueListbox1);


% Update shared data
setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);

kviewRefreshListbox(handles.listbox1);


end




function kviewImportFile(hObject,~,ConvertData)
% kview function to import data from files.
%
% SYNTAX:
%   kviewImportFile(hObject,eventdata,CovertData)
%
% INPUT:
%   hObject        handle to one object of the GUI. Any object is fine: it
%                  is needed only to retrive data from the figure.
%   eventdata      unused.
%   ConvertData    0 - no conversion
%                  1,2,3 - use the corresponding import conversion settings
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    08/05/2015
%   Author:  Michele Oro Nobili 



%% ---------------------------------------------------- Initialize data ---

% Get data
handles = guidata(hObject);
Dir = getappdata(handles.main_GUI,'FileImportDir');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
UserDefExt = getappdata(handles.main_GUI,'UserDefExt');

% Initialize data
choice = 'Yes';
DatasetsName = fieldnames(DatasetsStruct);
ImportedFileName = {};


% Create cell array for file filtering
ExtFiltering =  {'*.mat','Accepted formats';...
    '*.mat','Matlab file'};

for ii = 1:size(UserDefExt,1)
    ExtFiltering{1,1} = [ExtFiltering{1,1} ';*.' UserDefExt{ii,1}];
    ExtFiltering(ii+1,:) = {['*.' UserDefExt{ii,1}] UserDefExt{ii,2}};
end

ExtFiltering(end+1,:) = {'*','All type of file'};



%% -------------------------------------------------------- Import data ---

% Begin body
[FileNameFull,Dir,FilterIndex] = uigetfile(ExtFiltering,...
    'Select file to load:',Dir,'Multiselect','on');
if FilterIndex == 0
    return
end

% Update remembered ImportFile directory
setappdata(handles.main_GUI,'FileImportDir',Dir);


if ~iscell(FileNameFull)
    FileNameFull = {FileNameFull};
end


for ii=1:length(FileNameFull)

    [~,FileName,FileExtension] = fileparts(FileNameFull{ii});
    FileExtension = FileExtension(2:end);
    corrected_FileName = matlab.lang.makeValidName(FileName);
    if length(corrected_FileName)>63
        corrected_FileName = corrected_FileName(1:63);
        disp(['WARNING: file name ' FileName ' was over matlab name limit (63 characters) and has been truncated.']);
    end
    
    if ~any(strcmpi({'mat'},FileExtension)) && ~any(strcmpi(UserDefExt(:,1),FileExtension))
        display(['ERROR: extension ''' FileExtension ''' of the file ' FileNameFull{ii} ' was not recognized.']);
        return
    end

    % ------- OVERWRITE OR NOT SECTION --------------------%

    if any(strcmp(corrected_FileName,DatasetsName)) 
        
        if ~any(strcmp(choice,{'YesAll','NoAll'}))
            choice = kvoverwritedlg(corrected_FileName);
        end
    
        switch choice

            case {'No','NoAll'}
                continue

            case {'Yes','YesAll'}
                % pass

            case ''
                disp('Importing process interrupted.');
                return

        end
    
    end
        
    ImportedFileName{end+1} = corrected_FileName; %#ok<AGROW>

    % -----------------------------------------------------%



    % ------- EXTENSION IMPORT FUNC -----------------------%

    switch lower(FileExtension)

        case 'mat'
            [out1, out2] = kviewImportFromMatlab(hObject,[],0,'file',fullfile(Dir,FileNameFull{ii}),corrected_FileName);

            if ~isempty(out2)
                for jj = 1:length(out2)
                    DatasetsStruct.(out2{jj}) = out1{jj};
                end
                ImportedFileName(end:end+max(length(out2),1)-1) = out2;
            else
                ImportedFileName(end) = [];
            end
            
        otherwise
            ReadFileFunc = str2func(UserDefExt{strcmpi(UserDefExt(:,1),FileExtension),3});
            DatasetsStruct.(corrected_FileName) = ReadFileFunc(fullfile(Dir,FileNameFull{ii}));

    end

    % -----------------------------------------------------%

end
    


%% --------------------------------------------------------- Conversion ---

if ConvertData ~= 0
    % get data
    ImpConvSett = getappdata(handles.main_GUI,'ImpFileConvSett');
    
    % Initialize data
    DatasetsToConvert = cell(1,length(ImportedFileName));
    
    disp('Starting conversion process...');
    
    for ii = 1:length(ImpConvSett{ConvertData}(:,1))
             
        if ~isempty(ImpConvSett{ConvertData}{ii,1})
            ConvTableDir = ImpConvSett{ConvertData}{ii,1};
            ConvTableName = ImpConvSett{ConvertData}{ii,2};
            ConvDirection = ImpConvSett{ConvertData}{ii,3};
            
            % Group all the Datasets that will be converted
            for jj = 1:length(ImportedFileName)
                DatasetsToConvert{jj} = DatasetsStruct.(ImportedFileName{jj});
            end
            
            % Do the conversion (use external function)
            DatasetsConverted = kview_DatasetConversion(DatasetsToConvert,'FileName',ConvTableName,'FileDir',ConvTableDir,'ConvDirection',ConvDirection);
            
            % Re-insert all the converted Datasets to the main DatasetsStruct
            for jj = 1:length(ImportedFileName)
                DatasetsStruct.(ImportedFileName{jj}) = DatasetsConverted{jj};
            end
        end
    
    end
    
    disp('Conversion process completed.');
     
end            


%% ------------------------------------------------------------- Ending ---


set(handles.listbox1,'String',fieldnames(DatasetsStruct));


% Automatically select the new elements in listbox1. 
TempValueListbox1 = cellfun(@(x) find(strcmp(x,fieldnames(DatasetsStruct))),ImportedFileName);
set(handles.listbox1,'Value',TempValueListbox1);


% Update shared data
setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);

kviewRefreshListbox(handles.listbox1);

end


function kvSave(hObject,~)
% Save data from the kview GUI into .mat format.
%
% SYNTAX:
%   kvSave(hObject,eventdata)
%
% INPUT:
%   hObject        handle to one object of the GUI. Any object is fine: it
%                  is needed only to retrive data from the figure.
%   eventdata      unused.
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    15/05/2015
%   Author:  Michele Oro Nobili 


%% ---------------------------------------------------- Initialize data ---

% Get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
value_listbox1 = get(handles.listbox1,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');


% Choose path and name of the file.
[FileName,PathName,FilterIndex] = uiputfile('*.mat');
if FilterIndex == 0
    return
end


%% --------------------------------------------------------------- Save ---

save(fullfile(PathName,FileName),'-struct','DatasetsStruct');

% DEV NOTE: 
% another possibility is to save only the selected datasets. To do that use
% the following line instead of the above one.

% save(fullfile(PathName,FileName),'-struct','DatasetsStruct',contents_listbox1{value_listbox1});


end



function kvEportToExcel(hObject,~)
% Write selected variables into an excel file.
%
%
% SYNTAX:
%   kvEportToExcel(hObject,eventdata)
%
% INPUT:
%   hObject        handle to one object of the GUI. Any object is fine: it
%                  is needed only to retrive data from the figure.
%   eventdata      unused.


%% ---------------------------------------------------- Initialize data ---

handles = guidata(hObject);

contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');


% Check if one of the fields is empty
if isempty(contents_listbox1)
    disp('ERROR: the datasets list is empty.');
    return
elseif isempty(contents_listbox2)
    disp('ERROR: the subsystems list is empty.');
    return
elseif isempty(contents_listbox3)
    disp('ERROR: the variables list is empty.');
    return
end


%% -------------------------------------------------------- Write Excel ---

% Choose path and name of the file.
[FileName,PathName,FilterIndex] = uiputfile('*.xls');
if FilterIndex == 0
    return
end

step = 0;
hwb = waitbar(0,['Dataset ' int2str(step) '/' int2str(length(value_listbox1))]);


for ii=value_listbox1
    
    % pre-allocating cells
    variable_names=cell(1,length(value_listbox2));
    variable_units=cell(1,length(value_listbox2));
    variable_matrix=NaN(length(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{value_listbox2(1)}).(contents_listbox3{value_listbox3(1)}).data),length(value_listbox3));

    % cycle trought all selected variables and subsystems to take the
    % needed informations
    count=0;
    for jj=value_listbox2
        for kk = value_listbox3
            count=count+1;
            variable_names{count}= [contents_listbox2{jj} '.' contents_listbox3{kk}];
            
            % Check if the field "unit" exist and in case use it.
            if isfield(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}),'unit');
                variable_units{count}= DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit;
            else
                variable_units{count}= '';
            end
            
            variable_matrix(:,count)= DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data;
        end
    end
    
    % Max length is 31 character. Following characters are cut out.
    if length(contents_listbox1{ii})>31  
        SheetName = contents_listbox1{ii}(1:31); 
        disp(['WARNING: ' contents_listbox1{ii} ' dataset name was too long: excel sheet names accept only 31 character. The name was cut.']);
    else
        SheetName = contents_listbox1{ii};
    end
    
    % Write excel sheet.
    xlswrite(fullfile(PathName,FileName),variable_names,SheetName);
    xlswrite(fullfile(PathName,FileName),variable_units,SheetName,'A2');
    xlswrite(fullfile(PathName,FileName),variable_matrix,SheetName,'A4');
    
    step = step + 1;
    waitbar(step/length(value_listbox1),hwb,['Dataset ' int2str(step) '/' int2str(length(value_listbox1))]);
    
end

close(hwb);
display(['File ' FileName ' done.']);

end


% --- KeyPress Functions ---

function kviewGUI_KeyPressedCallback(hObject, eventdata)


if strcmp(eventdata.Modifier,'control')
    
    
    switch eventdata.Key
                    
        case 'z'                % undo
            
        case 'y'                % redo
                  
    end


end


end


function kviewListbox_KeyPressedCallback(hObject, eventdata)

if isempty(eventdata.Modifier)
    
    switch eventdata.Key
        
        case 'delete'           % delete
            DeleteElement_Callback(hObject,[],hObject);
            
    end
      
elseif strcmp(eventdata.Modifier,'control')
    
    switch eventdata.Key
        
        case 'c'                % copy
            CopyElement_Callback(hObject,[],hObject);
            
        case 'x'                % cut
            CutElement_Callback(hObject,[],hObject);
            
        case 'v'                % paste
            PasteElement_Callback(hObject,[],hObject);
                     
    end

end


end


function CreditsWindow(~,~)
% Create a window with information about creator and credits.

% Create the figure (not visible)
hOut = dialog(...
    'PaperUnits','points',...
    'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'IntegerHandle','off',...
    'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
    'MenuBar','none',...
    'Name','Credits',...
    'NumberTitle','off',...
    'PaperPosition',[7.09200297864125 70.9200297864125 226.94409531652 170.20807148739],...
    'PaperSize',[595.275552 841.889736],...
    'PaperType',get(0,'defaultfigurePaperType'),...
    'Position',[300 300 300 350],...
    'Resize','off',...
    'HandleVisibility','off',...
    'Tag','kviewCreditsWindow',...
    'Visible','off');
handles.(get(hOut,'Tag')) = hOut;

ScreenSize = get(0,'ScreenSize');
hOut.Position(1:2) = (ScreenSize(3:4)-hOut.Position(3:4))/2;

h = uiextras.VBox('Parent',hOut,'Tag','VBox1','Padding',5,'Spacing',5);
handles.(get(h,'Tag')) = h;

h = uicontrol('Parent',handles.VBox1,...
    'Style','Edit',...
    'Enable','Inactive',...
    'Max',2,...
    'HorizontalAlignment','left',...
    'Tag','editbox');
handles.(get(h,'Tag')) = h;

h = uicontrol('Parent',handles.VBox1,...
    'Callback',@(~,~)delete(hOut),...
    'Style','Pushbutton',...
    'String','OK',...
    'Tag','ok_button');
handles.(get(h,'Tag')) = h;

set(handles.VBox1,'Sizes',[-1 30]);


% Actual message displayed.
message = {'   ';...
    '   Copyright © 2016,   All Rights Reserved.';...
    ' ';...
    '   kview';...
    '   by Michele Oro Nobili';...
    '   ';...
    '   Author:  Michele Oro Nobili';...
    '   E-mail:  micheleoro.nobili@gmail.com';...
    '____________________________________________';...
    ' ';...
    ' ';...
    'kview uses the following code distribuited under the BSD license:';...
    ' ';...
    '   -   GUI Layout Toolbox by Ben Tordoff';...
    '   -   UnitConversion by John McDermid';...
    '   -   clickableLegend by Ameya Deoras';...
    '   -   findjobj by Yair Altman';...
    ' ';...
    'Full license files can be found in the installation directory.'};



% Insert the test into the Edit box.
set(handles.editbox,'String',message);

% save tha handles
guidata(hOut,handles);

% Show the figure and block any other action
set(hOut,'Visible','on');
drawnow;
uiwait(hOut);

end

