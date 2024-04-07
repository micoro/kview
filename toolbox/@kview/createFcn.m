function hOut = createFcn(app)
% CREATEFCN creates the kview GUI.
% 
% DESCRIPTION: creates the kview GUI and many of the callback functions
% used by it. It is not meant to be called directly by the user.
%
% SYNTAX:
%   kview.createFcn(app)
%   hOut = kview.createFcn(app)
%
%
% INPUT:
%   app         the kview object  
%
% OUTPUT:
%   hOut    	handle of the GUI



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
    'CloseRequestFcn',{@closeRequestCallback,app});
app.GUI.(get(hOut,'Tag')) = hOut;


% Set GUI position in the middle of the screen
movegui(hOut,"center");


%% Graphic Section: Main

h = uix.VBox('Parent',hOut,'Tag','VBox1','Padding',5,'Spacing',5);
app.GUI.(get(h,'Tag')) = h;


% ----------- Insert VBox1 content
h = uix.HButtonBox('Parent',app.GUI.VBox1,'Tag','HButtonBox1','HorizontalAlignment','left','ButtonSize',[155 32],'Spacing',5);
app.GUI.(get(h,'Tag')) = h;

h = uix.Grid('Parent',app.GUI.VBox1,'Tag','Grid1','Spacing',5);
app.GUI.(get(h,'Tag')) = h;

h = uix.HBox('Parent',app.GUI.VBox1,'Tag','HBox2','Spacing',3);
app.GUI.(get(h,'Tag')) = h;

h = uix.HBox('Parent',app.GUI.VBox1,'Tag','HBox3','Spacing',3);
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.VBox1,'Heights',[40 -1 25 0]);
set(app.GUI.VBox1,'MinimumHeights',[40 0 25 0]);


% ----------- Insert HButtonBox1 content
h = uicontrol(...
    'Parent',app.GUI.HButtonBox1,...
    'Callback',@(~,~) app.importFromMatlab(app,0,'workspace'),...
    'CData',[],...
    'FontSize',10,...
    'Position',[13 300 155 32],...
    'String','Import from WorkSpace',...
    'Tag','ImportFromWS');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.HButtonBox1,...
    'Callback',@(~,~) app.importFromFile(app,0),...
    'FontSize',10,...
    'Position',[334 300 155 32],...
    'String','Import from File',...
    'Tag','import_file');
app.GUI.(get(h,'Tag')) = h;



% ----------- Insert Grid1 content
h = uicontrol(...
    'Parent',app.GUI.Grid1,...
    'BackgroundColor',[1 1 1],... 
    'Callback',@(hObject,~) listboxClickCallback(hObject,[],app),...
    'FontSize',10,...
    'Max',10,...
    'Min',1,...
    'Style','listbox',...
    'String',{},...
    'Value',1,...
    'Tag','listbox1',...
    'KeyPressFcn',{@kviewListbox_KeyPressedCallback,app});
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.Grid1,'Tag','Empty1');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.Grid1,...
    'BackgroundColor',[1 1 1],... 
    'Callback',@(hObject,~) listboxClickCallback(hObject,[],app),...
    'FontSize',10,...
    'Max',10,...
    'Style','listbox',...
    'String',{},...
    'Value',1,...
    'Tag','listbox2',...
    'KeyPressFcn',{@kviewListbox_KeyPressedCallback,app});
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.Grid1,'Tag','Empty2');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.Grid1,...
    'BackgroundColor',[1 1 1],... 
    'Callback',@(hObject,~) listboxClickCallback(hObject,[],app),...
    'FontSize',10,...
    'Max',10,...
    'Style','listbox',...
    'String',{},...
    'Value',1,...
    'Tag','listbox3',...
    'KeyPressFcn',{@kviewListbox_KeyPressedCallback,app});
app.GUI.(get(h,'Tag')) = h;

h = uix.HBox('Parent',app.GUI.Grid1,'Tag','HBox1');
app.GUI.(get(h,'Tag')) = h;

h = uix.VBox('Parent',app.GUI.Grid1,'Tag','VBox2','Spacing',5);
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.Grid1,'Tag','Empty3');
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.Grid1','Widths',[-1 -1 -1 132],'Heights',[-1 25]);


% ----------- Insert HBox1 content
h = uicontrol(...
    'Parent',app.GUI.HBox1,...
    'Callback',{@XAxisSetDefault_Callback, app},...
    'String','Set default',...
    'Tag','XAxisSet_pushbutton');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.HBox1,...
    'FontSize',9,...
    'FontWeight','bold',...
    'HorizontalAlignment','left',...
    'String','X axis: ',...
    'Style','text',...
    'Tag','XAxisStatic');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.HBox1,...
    'FontSize',9,...
    'HorizontalAlignment','left',...
    'String','None',...
    'Style','text',...
    'Tag','XAxisVarName');
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.HBox1,'Widths',[70 50 -1]);

% ----------- Insert VBox2 content 

h = uicontrol(...
    'Parent',app.GUI.VBox2,...
    'Callback',@(~,~) app.plot('NewFigure'),...
    'FontSize',10,...
    'String','New Plot',...
    'Tag','new_plot');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.VBox2,...
    'Callback',@(~,~) app.plot('CurrentFigure'),...
    'FontSize',10,...
    'String','Add to Current Plot',...
    'Tag','AddToCurrentPlot');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.VBox2,...
    'BackgroundColor',[1 1 1],...
    'FontSize',9,...
    'HorizontalAlignment','left',...
    'String',{'New Figure'; 'Current Figure'},...
    'Style','popupmenu',...
    'TooltipString','Select in which figure you want to plot',...
    'Value',1,...
    'Tag','TargetFigure');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.VBox2,...
    'FontSize',10,...
    'String','Dynamic Plot',...
    'Style','checkbox',...
    'Tag','DynamicPlotCheck',...
    'Value',0);
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.VBox2,'Tag','Empty4');
app.GUI.(get(h,'Tag')) = h;


set(app.GUI.VBox2,'MinimumHeights',[32 32 32 20 32],'Heights',[32 32 32 20 32]);


% ----------- Insert HBox2 content

h = uix.Empty('Parent',app.GUI.HBox2,'Tag','Empty5');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.HBox2,...
    'BackgroundColor',[1 1 1],...
    'Callback',@(hObject,eventdata)kviewOLD('CustomMenu_popupmenu_Callback',hObject,eventdata,guidata(hObject),1),...
    'FontSize',10,...
    'String',{  '-- None --'; 'Offset and Gain'; 'Custom Buttons 1'; 'Custom Buttons 2'; 'Custom Buttons 3' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','CustomMenu1_popupmenu');
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.HBox2,'Tag','Empty6');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',app.GUI.HBox2,...
    'BackgroundColor',[1 1 1],...
    'Callback',@(hObject,eventdata)kviewOLD('CustomMenu_popupmenu_Callback',hObject,eventdata,guidata(hObject),2),...
    'FontSize',10,...
    'String',{  '-- None --'; 'Offset and Gain'; 'Custom Buttons 1'; 'Custom Buttons 2'; 'Custom Buttons 3' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','CustomMenu2_popupmenu');
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.HBox2,'Tag','Empty7');
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.HBox2,'MinimumWidths',[0 200 0 200 0],'Widths',[-1 200 -2 200 -1]);


% ----------- Insert HBox3 content

h = uix.Empty('Parent',app.GUI.HBox3,'Tag','Empty8');
app.GUI.(get(h,'Tag')) = h;

h = uipanel(...
    'Parent',app.GUI.HBox3,...
    'Units','pixels',...
    'FontSize',10,...
    'Clipping','on',...
    'Tag','CustomPanel1');
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.HBox3,'Tag','Empty9');
app.GUI.(get(h,'Tag')) = h;

h = uipanel(...
    'Parent',app.GUI.HBox3,...
    'Units','pixels',...
    'FontSize',10,...
    'Clipping','on',...
    'Tag','CustomPanel2');
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.HBox3,'Tag','Empty10');
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.HBox3,'MinimumWidths',[0 200 0 200 0],'Widths',[-1 540 -2 540 -1]);


%% ------------------------------------------------------- Context Menu ---

% Create Context Menu
h = uicontextmenu(...
    'Parent',app.GUI.main_GUI,...
    'Tag','listbox1ContextMenu');
set(app.GUI.listbox1,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',app.GUI.main_GUI,...
    'Tag','listbox2ContextMenu');
set(app.GUI.listbox2,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',app.GUI.main_GUI,...
    'Tag','listbox3ContextMenu');
set(app.GUI.listbox3,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',app.GUI.main_GUI,...
    'Tag','ImportFromFileMenu');
set(app.GUI.import_file,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',app.GUI.main_GUI,...
    'Tag','ImportFromWSMenu');
set(app.GUI.ImportFromWS,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',app.GUI.main_GUI,...
    'Callback',@StandardXaxisMenu_Callback,...
    'Tag','StandardXaxisMenu');
set(app.GUI.XAxisSet_pushbutton,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;


%% --------------------------------------------------------------- Menu ---


% --- File Menu

h = uimenu(...
    'Parent',app.GUI.main_GUI,...
    'Label','File',...
    'Tag','file_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.file_menu,...
    'Callback',@kvSave,...
    'Label','Save',...
    'Tag','file_menu_save');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.file_menu,...
    'Label','Export to',...
    'Separator','on',...
    'Tag','ExportTo');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ExportTo,...
    'Callback',@export2excel,...
    'Label','File excel (.xls)',...
    'Tag','export_to_excel');
app.GUI.(get(h,'Tag')) = h;


% --- Edit Menu
h = uimenu(...
    'Parent',app.GUI.main_GUI,...
    'Label','Edit',...
    'Tag','edit_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.edit_menu,...
    'Label','Undo',...
    'Enable','off',...
    'Tag','undo_menu','Accelerator','z');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.edit_menu,...
    'Label','Redo',...
    'Enable','off',...
    'Tag','redo_menu','Accelerator','y');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.edit_menu,...
    'Label','Sort',...
    'Tag','sort_menu',...
    'Separator','on');
app.GUI.(get(h,'Tag')) = h;

for ii = 1:3
    
    h = uimenu(...
        'Parent',app.GUI.sort_menu,...
        'Label',['Listbox ' int2str(ii)],...
        'Tag',['sl' int2str(ii) '_menu']);
    app.GUI.(get(h,'Tag')) = h;
    
    h = uimenu(...
        'Parent',app.GUI.(['sl' int2str(ii) '_menu']),...
        'Label','Original',...
        'Callback',{@sortMenuCallback,app,ii,1},...
        'Tag',['sl' int2str(ii) '_orig_menu']);
    app.GUI.(get(h,'Tag')) = h;
    
    h = uimenu(...
        'Parent',app.GUI.(['sl' int2str(ii) '_menu']),...
        'Label','Ascii',...
        'Callback',{@sortMenuCallback,app,ii,2},...
        'Tag',['sl' int2str(ii) '_ascii_menu']);
    app.GUI.(get(h,'Tag')) = h;
    
    h = uimenu(...
        'Parent',app.GUI.(['sl' int2str(ii) '_menu']),...
        'Label','Alphabetical',...
        'Callback',{@sortMenuCallback,app,ii,3},...
        'Tag',['sl' int2str(ii) '_alphab_menu']);
    app.GUI.(get(h,'Tag')) = h;
    
end


% --- Settings Menu
h = uimenu(...
    'Parent',app.GUI.main_GUI,...
    'Label','Settings',...
    'Tag','settings_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.settings_menu,...
    'Callback',@kvGenericSettingsGUI,...
    'Label','Generic',...
    'Tag','import_settings');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.settings_menu,...
    'Label','Import Settings',...
    'Separator','on',...
    'Tag','import_settings');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.import_settings,...
    'Callback',@(hObject,~)ImportSettings(guidata(hObject),1),...
    'Label','From File',...
    'Tag','impsett_fromfile');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.import_settings,...
    'Callback',@(hObject,~)ImportSettings(guidata(hObject),2),...
    'Label','From WorkSpace',...
    'Tag','impsett_fromws');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.settings_menu,...
    'Callback',@(hObject,~)CustomButtonsSettings(guidata(hObject)),...
    'Label','Custom Buttons Sett.',...
    'Tag','custombuttonsett_menu');
app.GUI.(get(h,'Tag')) = h;


% --- Info Menu
h = uimenu(...
    'Parent',app.GUI.main_GUI,...
    'Label','Info',...
    'Tag','info_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.info_menu,...
    'Callback',@(~,~)open(fullfile(fileparts(which('kview.m')),'html','mainpage.html')),...
    'Label','Documentation',...
    'Tag','documentation_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.info_menu,...
    'Callback',@creditsWindow,...
    'Label','Credits',...
    'Separator','on',...
    'Tag','credits_menu');
app.GUI.(get(h,'Tag')) = h;


% --- Listbox Menu

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',{@SetXAxis_Callback, app},...
    'Label','Set as X axis',...
    'Tag','SetXAxis');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',@(hObject,eventdata)kviewOLD('ExpSingleVarToWs_Callback',hObject,eventdata,guidata(hObdeleteElementCallbackject)),...
    'Label','Export to WS',...
    'Separator','on',...
    'Tag','ExpSingleVarToWs');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',@(hObject,eventdata)kviewOLD('ImportSingleVarFromWS_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Import from WS',...
    'Tag','ImportSingleVarFromWS');
app.GUI.(get(h,'Tag')) = h;


h = uimenu(...
    'Parent',app.GUI.listbox2ContextMenu,...
    'Callback',@(~,~)autokvGroup(app),...
    'Label','Auto Group',...
    'Tag','autokvgroup');
app.GUI.(get(h,'Tag')) = h;


for ii = 1:3

    h = uimenu(...
        'Parent',app.GUI.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@duplicateElementCallback,app,app.GUI.(['listbox' int2str(ii)])},...
        'Label','Duplicate',...
        'Tag',['l' int2str(ii) '_duplicate_element']);
    app.GUI.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',app.GUI.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@deleteElementCallback,app,app.GUI.(['listbox' int2str(ii)])},...
        'Label','Delete',...
        'Separator','on',...
        'Tag',['l' int2str(ii) '_delete_element']);
    app.GUI.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',app.GUI.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@renameElementCallback,app,app.GUI.(['listbox' int2str(ii)])},...
        'Label','Rename',...
        'Tag',['l' int2str(ii) '_rename_element']);
    app.GUI.(get(h,'Tag')) = h;
    
end
set(app.GUI.l3_duplicate_element,'Separator','on');
set(app.GUI.l2_duplicate_element,'Separator','on');

h = uimenu(...
    'Parent',app.GUI.listbox1ContextMenu,...
    'Label','Send To',...
    'Separator','on',...
    'Tag','send_to_1');
app.GUI.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',app.GUI.send_to_1,...
        'Callback',@(hObject,eventdata)kviewOLD('export_to_ws_Callback',hObject,eventdata,guidata(hObject)),...
        'Label','Workspace',...
        'Tag','send_to_1_workspace');
    app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox1ContextMenu,...
    'Callback',@DatasetConversion_Callback,...
    'Label','Dataset Conversion',...
    'Separator','on',...
    'Tag','DatasetConversion');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',@ChangeUnit_Callback,...
    'Label','Change Unit',...
    'Separator','on',...
    'Tag','ChangeUnitMenu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ImportFromFileMenu,...
    'Callback',@(~,~) app.importFromFile(app,1),...
    'Label','with Conversion Table 1',...
    'Tag','iff_wConvTable1');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ImportFromFileMenu,...
    'Callback',@(~,~) app.importFromFile(app,2),...
    'Label','with Conversion Table 2',...
    'Tag','iff_wConvTable2');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ImportFromFileMenu,...
    'Callback',@(~,~) app.importFromFile(app,3),...
    'Label','with Conversion Table 3',...
    'Tag','iff_wConvTable3');
app.GUI.(get(h,'Tag')) = h;


h = uimenu(...
    'Parent',app.GUI.ImportFromWSMenu,...
    'Callback',@(~,~) app.importFromMatlab(app,1,'workspace'),...
    'Label','with Conversion Table 1',...
    'Tag','ifws_wConvTable1');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ImportFromWSMenu,...
    'Callback',@(~,~) app.importFromMatlab(app,2,'workspace'),...
    'Label','with Conversion Table 2',...
    'Tag','ifws_wConvTable2');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ImportFromWSMenu,...
    'Callback',@(~,~) app.importFromMatlab(app,3,'workspace'),...
    'Label','with Conversion Table 3',...
    'Tag','ifws_wConvTable3');
app.GUI.(get(h,'Tag')) = h;


%% Settings & Application Data

set(hOut, 'WindowStyle', 'normal');

% Set Other data
set([app.GUI.('sl1_orig_menu') app.GUI.('sl2_alphab_menu') app.GUI.('sl3_alphab_menu')] ,'Checked','on');


% Output and Other

hsingleton = hOut;

set(hOut,'Visible','on');
drawnow;

end


%% Callback functions

function closeRequestCallback(~,~,app)
% Close request function to display a question dialog box

selection = questdlg('You really want to close the kview?',...
    'Close kview',...
    'Yes','No','Yes');
switch selection
    case 'Yes'
        delete(app);
    case 'No'
        return
end

end


function sortMenuCallback(hObject,~,app,ListboxNum,MethodNum)
% Function to select the sorting order of the listboxes.

% change the checked option
set(get(get(hObject,'Parent'),'Children'),'Checked','off');
set(hObject,'Checked','on');

switch MethodNum
    case 1
        app.UtilityData.SortOrderMethod{ListboxNum} = 'original';
    case 2
        app.UtilityData.SortOrderMethod{ListboxNum} = 'ascii';
    case 3
        app.UtilityData.SortOrderMethod{ListboxNum} = 'alphabetical';       
end
% Refresh the listboxes to apply the new order
app.refresh(app.GUI.(['listbox' int2str(ListboxNum)]));
end


function StandardXaxisMenu_Callback(hObject,~)
% This function create a Menu with the list of variables being contained in
% the subsystem selected for the default X axis. If clicked the variable is 
% set as the X axis.

% Clear ContextMenu from a previuos list
previous_list = get(hObject,'Children');
delete(previous_list);

% Get data
app.GUI = guidata(hObject);
contents_listbox1 = cellstr(get(app.GUI.listbox1,'String'));
value_listbox1 = get(app.GUI.listbox1,'Value');
DatasetsStruct = getappdata(app.GUI.main_GUI,'DatasetsStruct');
defaultXAxis = getappdata(app.GUI.main_GUI,'defaultXAxis');


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
            app.GUI.XAxisVarName.String = 'None';           
        else
            app.GUI.XAxisVarName.String = XaxisVarName;
        end
        setappdata(app.GUI.main_GUI,'XAxisVarName',XaxisVarName);
    end

end


function listboxClickCallback(hObject, ~, app)

ListboxContent = cellstr(get(hObject,'String'));
DynamicCheckValue = get(app.GUI.DynamicPlotCheck,'Value');

app.refresh(hObject);

if isempty(ListboxContent)
    return
end

if strcmp(get(app.GUI.main_GUI,'SelectionType'),'open')
    app.plot('Click');
elseif DynamicCheckValue == 1
    app.plot('Dynamic');
end

end


function duplicateElementCallback(~,~,app,listboxHandle)

switch get(listboxHandle,'tag')
    
    case 'listbox1'
        duplicatedDataset = app.selectedDataset;
        newNameArray = matlab.lang.makeUniqueStrings([duplicatedDataset.Name],[app.DatasetList.Name]);
        [duplicatedDataset.Name] = newNameArray{:};
        app.DatasetList(end+1:end+length(duplicatedDataset)) = duplicatedDataset;
     
    case 'listbox2'
        error('Group duplication is not supported.');
        
    case 'listbox3'
        for iDataset = app.selectedDataset()
            duplicatedVariable = app.selectedVariableName(); 
            duplicatedVariableTable = iDataset.Table(:,duplicatedVariable);
            duplicatedVariableNewName = matlab.lang.makeUniqueStrings(duplicatedVariable,iDataset.Table.Properties.VariableNames);
            duplicatedVariableTable = renamevars(duplicatedVariableTable,duplicatedVariable,duplicatedVariableNewName);
            iDataset.Table = [iDataset.Table duplicatedVariableTable];
            iDataset.Table = movevars(iDataset.Table,duplicatedVariableNewName,"After",duplicatedVariable(end));
            app.DatasetList(strcmp([app.DatasetList.Name],iDataset.Name)) = iDataset;
        end
        
end

app.refresh();

end


function deleteElementCallback(~,~,app,listboxHandle)

switch get(listboxHandle,'tag')
    
    case 'listbox1'      
        app.DatasetList(app.GUI.listbox1.Value) = [];
        
    case 'listbox2'   
        selectedDatasetIndex = app.selectedDatasetIndex();
        selectedGroupList = app.selectedGroup();
        for iCount = selectedDatasetIndex'
            [~, indexMatching] = intersect([app.DatasetList(iCount).Table.Properties.CustomProperties.kvGroup.Name],[selectedGroupList.Name],"stable");
            app.DatasetList(iCount).Table.Properties.CustomProperties.kvGroup(indexMatching) = [];
        end
        
    case 'listbox3'   
        for iDataset = app.selectedDataset()
            app.DatasetList(strcmp([app.DatasetList.Name],iDataset.Name)) = removevars(iDataset.Table,app.selectedVariableName()); 
        end

end

app.refresh();

end


function renameElementCallback(~,~,app,listboxHandle)
% ListboxHandle handle to the selected/focused listbox

selectedListboxContent = get(listboxHandle,'String');
selectedListboxValue = get(listboxHandle,'Value');
currentName = selectedListboxContent(selectedListboxValue);

% check number of items selected
if length(selectedListboxValue)>1
    disp('ERROR: you have selected too many items in the listbox. When you are renameing an item you can select only one at time.');
    return
end

% get new name
newName = inputdlg('Enter new name:','Rename',[1 50],(selectedListboxContent(selectedListboxValue)),'on');

% check new name
if isempty(newName)
    return
elseif strcmp(newName{1},selectedListboxContent(selectedListboxValue))
    return
elseif ~isvarname(newName{1})
    disp(['ERROR: ' newName{1} ' is not a valid name.']);
    return
elseif any(strcmp(newName{1},selectedListboxContent))
    disp(['ERROR: there is already another item with the name ' newName{1}]);
    return
end
        
% act depending on the listbox focused
switch get(listboxHandle,'tag')
    
    case 'listbox1'
        app.DatasetList(strcmp([app.DatasetList.Name],currentName)).Name = newName;
        
    case 'listbox2'
        error('Group renameing is not supported.');  
        
    case 'listbox3'
        for iDatasetIndex = app.selectedDatasetIndex()'
            app.DatasetList(iDatasetIndex).Table = renamevars(app.DatasetList(iDatasetIndex).Table,currentName,newName);
        end
        
end


% update DatasetList and listbox contents
app.refresh();

% Select the renamed dataset
set(listboxHandle,'Value',find(strcmp(newName{1},get(listboxHandle,'String'))));

% refresh again
app.refresh();

end


function SetXAxis_Callback(~,~,app)
% Set the selected variable as the new XAxis
if length(app.GUI.listbox2.Value)==1 && length(app.GUI.listbox3.Value)==1
    app.XAxis = app.GUI.listbox3.String{app.GUI.listbox3.Value};
else
    disp('ERROR: you have selected too many groups or variables.')
end
end


function XAxisSetDefault_Callback(~,~,app)
% Reset the X axis to the default value.
% TODO: check what I have already done on the other PC and re implement
% here

app.XAxis = [];

end


function DatasetConversion_Callback(hObject,~)
% Function to apply a dataset conversion table from the GUI.

app.GUI = guidata(hObject);
contents_listbox1 = cellstr(get(app.GUI.listbox1,'String'));
value_listbox1 = get(app.GUI.listbox1,'Value');
DatasetsStruct = getappdata(app.GUI.main_GUI,'DatasetsStruct');
ConvTableDir = getappdata(app.GUI.main_GUI,'ConvTableDir');

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
app.refresh(app.GUI.listbox1);

end


function ChangeUnit_Callback(hObject,~)
% Function to change the unit type.


%% ----------------------------------------------------- Initialization ---

% get data
app.GUI = guidata(hObject);
contents_listbox1 = cellstr(get(app.GUI.listbox1,'String'));
contents_listbox2 = cellstr(get(app.GUI.listbox2,'String'));
contents_listbox3 = cellstr(get(app.GUI.listbox3,'String'));
value_listbox1 = get(app.GUI.listbox1,'Value');
value_listbox2 = get(app.GUI.listbox2,'Value');
value_listbox3 = get(app.GUI.listbox3,'Value');
DatasetsStruct = getappdata(app.GUI.main_GUI,'DatasetsStruct');


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
setappdata(app.GUI.main_GUI,'DatasetsStruct',DatasetsStruct);



end


% --- Import/Export Functions ---

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
app.GUI = guidata(hObject);
contents_listbox1 = cellstr(get(app.GUI.listbox1,'String'));
value_listbox1 = get(app.GUI.listbox1,'Value');
DatasetsStruct = getappdata(app.GUI.main_GUI,'DatasetsStruct');


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



%% --- KeyPress Function ---

function kviewListbox_KeyPressedCallback(hObject, eventdata, app)

if isempty(eventdata.Modifier)
    
    switch eventdata.Key
        
        case 'delete'           % delete
            deleteElementCallback(hObject,[],app,hObject);

        case 'f2'               % rename
            renameElementCallback(hObject,[],app,hObject)            
            
    end
      
elseif strcmp(eventdata.Modifier,'control')
    
    switch eventdata.Key
        
        case 'd'                % duplicate
            duplicateElementCallback(hObject,[],hObject);
                                 
    end

end


end


function creditsWindow(~,~)
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
app.GUI.(get(hOut,'Tag')) = hOut;

ScreenSize = get(0,'ScreenSize');
hOut.Position(1:2) = (ScreenSize(3:4)-hOut.Position(3:4))/2;

h = uix.VBox('Parent',hOut,'Tag','VBox1','Padding',5,'Spacing',5);
app.GUI.(get(h,'Tag')) = h;

h = uicontrol('Parent',app.GUI.VBox1,...
    'Style','Edit',...
    'Enable','Inactive',...
    'Max',2,...
    'HorizontalAlignment','left',...
    'Tag','editbox');
app.GUI.(get(h,'Tag')) = h;

h = uicontrol('Parent',app.GUI.VBox1,...
    'Callback',@(~,~)delete(hOut),...
    'Style','Pushbutton',...
    'String','OK',...
    'Tag','ok_button');
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.VBox1,'Sizes',[-1 30]);


% Actual message displayed.
message = {'   ';...
    '   Author:  Michele Oro Nobili';...
    '____________________________________________';...
    ' ';...
    ' ';...
    'kview uses the following code distribuited under the BSD license:';...
    ' ';...
    '   -   UnitConversion by John McDermid';...
    ' ';...
    'Full license files can be found in the installation directory.'};



% Insert the test into the Edit box.
set(app.GUI.editbox,'String',message);

% save tha app.GUI
guidata(hOut,app.GUI);

% Show the figure and block any other action
set(hOut,'Visible','on');
drawnow;
uiwait(hOut);

end

