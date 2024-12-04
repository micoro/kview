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
hOut = uifigure(...
    'IntegerHandle','off',...
    'Name','kview',...
    'NumberTitle','off',...
    'Position',[300 300 1100 450],...
    'Resize','on',...
    'AutoResizeChildren', 'on',...
    'HandleVisibility','off',...
    'WindowStyle','normal',...
    'Tag','main_GUI',...
    'Visible','off',...  
    'CloseRequestFcn',{@closeRequestCallback,app});   % 'WindowKeyPressFcn',@kviewGUI_KeyPressedCallback);
app.GUI.(get(hOut,'Tag')) = hOut;


% Set GUI position in the middle of the screen
movegui(hOut,"center");


%% Graphic Section: Main

h = uix.VBox('Parent',hOut,'Tag','VBox1','Padding',5,'Spacing',5);
app.GUI.(get(h,'Tag')) = h;


% ----------- Insert VBox1 content
h = uix.HButtonBox('Parent',app.GUI.VBox1,'Tag','HButtonBox1','HorizontalAlignment','left','ButtonSize',[180 32],'Spacing',5);
app.GUI.(get(h,'Tag')) = h;

h = uix.Grid('Parent',app.GUI.VBox1,'Tag','Grid1','Spacing',5);
app.GUI.(get(h,'Tag')) = h;

% h = uix.HBox('Parent',app.GUI.VBox1,'Tag','HBox3','Spacing',3);
% app.GUI.(get(h,'Tag')) = h;

h = uix.Panel(...
    'Parent',app.GUI.VBox1,...
    'Units','pixels',...
    'FontSize',10,...
    'Clipping','on',...
    'Tag','CustomPanel1', ...
    'Padding',2);
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.VBox1,'Heights',[40 -1 0]);
set(app.GUI.VBox1,'MinimumHeights',[40 100 0]);


% ----------- Insert HButtonBox1 content
h = uibutton(...
    'Parent',app.GUI.HButtonBox1,...
    'ButtonPushedFcn',@(~,~) app.importFromMatlab(),...
    'Position',[13 300 155 32],...
    'Text','Import from WorkSpace',...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','ImportFromWS');
app.GUI.(get(h,'Tag')) = h;

h = uibutton(...
    'Parent',app.GUI.HButtonBox1,...
    'ButtonPushedFcn',@(~,~) app.importFromFile(),...
    'Position',[334 300 155 32],...
    'Text','Import from File',...
    'FontSize',app.UtilityData.FontSize,...
    'Tooltip','Right-click for more options',...
    'Tag','ImportFromFile');
app.GUI.(get(h,'Tag')) = h;



% ----------- Insert Grid1 content
h = uilistbox(...
    'Parent',app.GUI.Grid1,...
    'BackgroundColor',[1 1 1],... 
    'ValueChangedFcn',@(hObject,~) listboxClickCallback(hObject,[],app,false),...
    'DoubleClickedFcn',@(hObject,~) listboxClickCallback(hObject,[],app,true),...
    'MultiSelect','on',...
    'Items',{},...
    'Value',{},...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','listbox1');
app.GUI.(get(h,'Tag')) = h;

% h = uix.Empty('Parent',app.GUI.Grid1,'Tag','Empty1');
% app.GUI.(get(h,'Tag')) = h;
h = uidropdown(...
    'Parent',app.GUI.Grid1,...
    'BackgroundColor',[1 1 1],...
    'DropDownOpeningFcn',@(hObject,~) createCustomPanelDropDownItemList(hObject,app),...
    'ValueChangedFcn',@(hObject,~)customPanelManager(hObject,[],app),...
    'Items',{  '-- None --'},...
    'Value','-- None --',...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','CustomMenu1_popupmenu');
app.GUI.(get(h,'Tag')) = h;

h = uitree(...
    'Parent',app.GUI.Grid1,...
    'BackgroundColor',[1 1 1],...  
    'SelectionChangedFcn',@(hObject,~) listboxClickCallback(hObject,[],app,false),...    'DoubleClickedFcn',@(hObject,~) listboxClickCallback(hObject,[],app,true),...
    'MultiSelect','on',...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','listbox2');
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.Grid1,'Tag','Empty2');
app.GUI.(get(h,'Tag')) = h;

h = uilistbox(...
    'Parent',app.GUI.Grid1,...
    'BackgroundColor',[1 1 1],... 
    'ValueChangedFcn',@(hObject,~) listboxClickCallback(hObject,[],app,false),...
    'DoubleClickedFcn',@(hObject,~) listboxClickCallback(hObject,[],app,true),...
    'MultiSelect','on',...
    'Items',{},...
    'Value',{},...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','listbox3');
app.GUI.(get(h,'Tag')) = h;

h = uix.HBox('Parent',app.GUI.Grid1,'Tag','HBox1');
app.GUI.(get(h,'Tag')) = h;

h = uix.VBox('Parent',app.GUI.Grid1,'Tag','VBox2','Spacing',5);
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.Grid1,'Tag','Empty3');
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.Grid1','Widths',[-1 -1 -1 130],'Heights',[-1 25]);


% ----------- Insert HBox1 content
h = uibutton(...
    'Parent',app.GUI.HBox1,...
    'ButtonPushedFcn',{@XAxisSetDefault_Callback, app},...
    'Text','Set default',...
    'FontSize',app.UtilityData.FontSize,...
    'Tooltip','Right-click for more options',...
    'Tag','XAxisSet_pushbutton');
app.GUI.(get(h,'Tag')) = h;

h = uilabel(...
    'Parent',app.GUI.HBox1,...
    'FontSize',9,...
    'FontWeight','bold',...
    'HorizontalAlignment','left',...
    'Text','   X axis:  ',...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','XAxisStatic');
app.GUI.(get(h,'Tag')) = h;

h = uilabel(...
    'Parent',app.GUI.HBox1,...
    'HorizontalAlignment','left',...
    'Text','None',...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','XAxisVarName');
app.GUI.(get(h,'Tag')) = h;

set(app.GUI.HBox1,'Widths',[80 70 -1]);

% ----------- Insert VBox2 content 

h = uicheckbox(...
    'Parent',app.GUI.VBox2,...
    'Text','Always On Top',...
    'FontSize',app.UtilityData.FontSize,...
    'ValueChangedFcn',@(hObject,~) alwaysOnTopToggle(hObject,app),...
    'Tag','alwaysontopcheckbox',...
    'Value',0);
app.GUI.(get(h,'Tag')) = h;

h = uibutton(...
    'Parent',app.GUI.VBox2,...
    'Text','Plot',...
    'FontSize',app.UtilityData.FontSize,...
    'ButtonPushedFcn',@(~,~) app.plot(app.UtilityData.DoubleClickTarget),...
    'Tooltip','Right-click for more options',...
    'Tag','plot_pushbutton');
app.GUI.(get(h,'Tag')) = h;

h = uicheckbox(...
    'Parent',app.GUI.VBox2,...
    'Text','Dynamic Plot',...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','DynamicPlotCheck',...
    'Value',0);
app.GUI.(get(h,'Tag')) = h;

h = uicheckbox(...
    'Parent',app.GUI.VBox2,...
    'Text','Show Legend',...
    'FontSize',app.UtilityData.FontSize,...
    'Tag','LegendCheck',...
    'Value',1);
app.GUI.(get(h,'Tag')) = h;

h = uilabel(...
    'Parent',app.GUI.VBox2,...
    "Text","Link Axes:",...
    'FontSize',app.UtilityData.FontSize);

h = uidropdown(...
    'Parent',app.GUI.VBox2,...
    'BackgroundColor',[1 1 1],...
    'FontSize',app.UtilityData.FontSize,...
    'Items',["off" "x" "y" "z" "xy" "xz" "yz" "xyz"],...
    'Value',"x",...
    "ValueChangedFcn",@(hObject,~) setLinkAxesDimension(hObject,app),...
    'Tag','LinkAxesDimensionDropDown');
app.GUI.(get(h,'Tag')) = h;

h = uix.Empty('Parent',app.GUI.VBox2,'Tag','Empty4');
app.GUI.(get(h,'Tag')) = h;


set(app.GUI.VBox2,'MinimumHeights',[20 32 20 20 20 20 32],'Heights',[20 32 20 20 20 20 32]);


% ----------- Insert HBox3 content

% h = uix.Empty('Parent',app.GUI.HBox3,'Tag','Empty8');
% app.GUI.(get(h,'Tag')) = h;
% 
% h = uipanel(...
%     'Parent',app.GUI.HBox3,...
%     'Units','pixels',...
%     'FontSize',10,...
%     'Clipping','on',...
%     'Tag','CustomPanel1');
% app.GUI.(get(h,'Tag')) = h;
% 
% h = uix.Empty('Parent',app.GUI.HBox3,'Tag','Empty9');
% app.GUI.(get(h,'Tag')) = h;
% % h = uix.Empty('Parent',app.GUI.HBox3,'Tag','Empty9rr');
% % app.GUI.(get(h,'Tag')) = h;
% % h = uix.Empty('Parent',app.GUI.HBox3,'Tag','Empty9ee');
% % app.GUI.(get(h,'Tag')) = h;
% h = uipanel(...
%     'Parent',app.GUI.HBox3,...
%     'Units','pixels',...
%     'FontSize',10,...
%     'Clipping','on',...
%     'Tag','CustomPanel2');
% app.GUI.(get(h,'Tag')) = h;
% 
% h = uix.Empty('Parent',app.GUI.HBox3,'Tag','Empty10');
% app.GUI.(get(h,'Tag')) = h;
% 
% set(app.GUI.HBox3,'MinimumWidths',[0 200 0 200 0],'Widths',[-1 540 -2 540 -1]);


%% ------------------------------------------------------- Context Menu ---

% Create Context Menu
h = uicontextmenu(... 
    'Parent',app.GUI.main_GUI,...
    'ContextMenuOpeningFcn',@(~,~)ImportFromFileContextMenu_CreateCallback(app),...
    'Tag','ImportFromFileContextMenu');
set(app.GUI.ImportFromFile,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

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
    'Tag','plotbuttoncontextmenu');
set(app.GUI.plot_pushbutton,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',app.GUI.main_GUI,...
    'Tag','ImportFromWSMenu');
set(app.GUI.ImportFromWS,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

h = uicontextmenu(...
    'Parent',app.GUI.main_GUI,...
    'Callback',@(hObject,~) StandardXaxisMenu_Callback(hObject,[],app),...
    'Tag','StandardXaxisMenu');
set(app.GUI.XAxisSet_pushbutton,'uicontextmenu', h);
app.GUI.(get(h,'Tag')) = h;

%% --------------------------------------------------------------- Menu ---


% --- File Menu

h = uimenu(...
    'Parent',app.GUI.main_GUI,...
    'Label','Settings',...
    'Tag','file_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.file_menu,...
    'Callback',@(~,~) kvsettingsGUI(app),...
    'Label','Customization',...
    'Tag','settings');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.file_menu,...
    'Label','Sort',...
    'Tag','sort_menu');
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

% --- Info Menu
h = uimenu(...
    'Parent',app.GUI.main_GUI,...
    'Label','Info',...
    'Tag','info_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.info_menu,...
    'Callback',@(~,~)open(fullfile(fileparts(which('kview.m')),'..','doc','GettingStarted.mlx')),...
    'Label','Getting Started',...
    'Tag','gettingstarted_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.info_menu,...
    'Callback',@(~,~)open(fullfile(fileparts(which('kview.m')),'..','doc','examples','html','mainpage.html')),...
    'Label','Documentation',...
    'Enable','off',...
    'Tag','documentation_menu');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.info_menu,...
    'Callback',{@aboutWindow,hOut},...
    'Label','About && github',...
    'Separator','on',...
    'Tag','credits_menu');
app.GUI.(get(h,'Tag')) = h;

% --- Plot pushbutton Menu

h = uimenu(...
    'Parent',app.GUI.plotbuttoncontextmenu,...
    'Callback',@(~,~) app.plot('CurrentFigureNewAxes'),...
    'Label','Plot on new axes (same figure)',...
    'Tag','contextmenuplotbuttononcurrentsecondYaxis');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.plotbuttoncontextmenu,...
    'Callback',@(~,~) app.plot('CurrentFigure'),...
    'Label','Add to current axes',...
    'Tag','contextmenuplotbuttononcurrent');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.plotbuttoncontextmenu,...
    'Callback',@(~,~) app.plot('CurrentFigure','useSecondYAxis',true),...
    'Label','Add to current axes (on the right)',...
    'Tag','contextmenuplotbuttononcurrentsecondYaxis');
app.GUI.(get(h,'Tag')) = h;


% --- Listbox Menu

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',@(~,~) app.plot('CurrentFigureNewAxes'),...
    'Label','Plot on new axes (same figure)',...
    'Tag','contextmenuplotoncurrentsecondYaxis');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',@(~,~) app.plot('CurrentFigure'),...
    'Label','Add to current axes',...
    'Tag','contextmenuplotoncurrent');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',@(~,~) app.plot('CurrentFigure','useSecondYAxis',true),...
    'Label','Add to current axes (on the right)',...
    'Tag','contextmenuplotoncurrentsecondYaxis');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',{@SetXAxis_Callback, app},...
    'Separator','on',...
    'Label','Set as X axis',...
    'Tag','SetXAxis');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Label','Double-Click Target',...
    'Separator','on',...
    'Tag','doubleclicktarget');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.doubleclicktarget,...
    'Callback',@(hObject,~) setDoubleClickTarget_Callback(hObject,app,"NewFigure"),...
    'Checked','on',...
    'Label','New Figure',...
    'Tag','doubleclicktarget_new');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.doubleclicktarget,...
    'Callback',@(hObject,~) setDoubleClickTarget_Callback(hObject,app,"CurrentFigure"),...
    'Label','Current Figure',...
    'Tag','doubleclicktarget_current');
app.GUI.(get(h,'Tag')) = h;


h = uimenu(...
    'Parent',app.GUI.listbox2ContextMenu,...
    'Callback',@(~,~)autokvGroup(app),...
    'Label','Auto Group',...
    'Tag','autokvgroup');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox1ContextMenu,...
    'Label','Export To',...
    'Separator','on',...
    'Tag','send_to_1');
app.GUI.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',app.GUI.send_to_1,...
        'Callback',@(~,~) app.exportToWorkspace(),...
        'Label','Workspace',...
        'Tag','export_to_workspace');
    app.GUI.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',app.GUI.send_to_1,...
        'Callback',@(~,~) app.exportToMat(),...
        'Label','Mat-File',...
        'Separator','on',...
        'Tag','export_to_matfile');
    app.GUI.(get(h,'Tag')) = h;

for ii = [1 3]

    h = uimenu(...
        'Parent',app.GUI.(['listbox' int2str(ii) 'ContextMenu']),...
        'Callback',{@duplicateElementCallback,app,app.GUI.(['listbox' int2str(ii)])},...
        'Label','Duplicate',...
        'Separator','on',...
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

h = uimenu(...
    'Parent',app.GUI.listbox1ContextMenu,...
    'Callback',@DatasetConversion_Callback,...
    'Label','Dataset Conversion',...
    'Separator','on',...
    'Enable','off',...
    'Tag','DatasetConversion');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.listbox3ContextMenu,...
    'Callback',@ChangeUnit_Callback,...
    'Label','Change Unit',...
    'Separator','on',...
    'Enable','off',...
    'Tag','ChangeUnitMenu');
app.GUI.(get(h,'Tag')) = h;

% buttons context menu

h = uimenu(...
    'Parent',app.GUI.ImportFromWSMenu,...
    'Callback',@(~,~) app.importFromMatlab(),...
    'Label','with Conversion Table 1',...
    'Enable','off',...
    'Tag','ifws_wConvTable1');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ImportFromWSMenu,...
    'Callback',@(~,~) app.importFromMatlab(),...
    'Label','with Conversion Table 2',...
    'Enable','off',...
    'Tag','ifws_wConvTable2');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ImportFromWSMenu,...
    'Callback',@(~,~) app.importFromMatlab(),...
    'Label','with Conversion Table 3',...
    'Enable','off',...
    'Tag','ifws_wConvTable3');
app.GUI.(get(h,'Tag')) = h;


%% Settings & Application Data

% Set Other data
set([app.GUI.('sl1_orig_menu') app.GUI.('sl2_alphab_menu') app.GUI.('sl3_alphab_menu')] ,'Checked','on');


% Output and Other

set(hOut,'Visible','on');
drawnow;

end


%% Callback functions

function closeRequestCallback(~,~,app)
% Close request function to display a question dialog box

selection = uiconfirm(app.GUI.main_GUI,'Close kview?',...
    'Confirm Close');
switch selection
    case 'OK'
        delete(app);
    case 'Cancel'
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


function ImportFromFileContextMenu_CreateCallback(app)
% create the context menu for import from file

% clear the menu
delete(app.GUI.ImportFromFileContextMenu.Children)

h = uimenu(...
    'Parent',app.GUI.ImportFromFileContextMenu,...
    'Enable','off',...
    'Label','Select import method for .mat files',...
    'Tag','importmethoddescription');
app.GUI.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',app.GUI.ImportFromFileContextMenu,...
    'Separator','on',....
    'MenuSelectedFcn',@(hObject,~)ImportFromFileContextMenu_ItemClicked(hObject,app,function_handle.empty),...
    'Label','Always ask',...
    'Tag','importfromfilealwaysask');
app.GUI.(get(h,'Tag')) = h;
if isempty(app.UtilityData.MatImportMethod)
    h.Checked = 'on';
end

h = uimenu(...
    'Parent',app.GUI.ImportFromFileContextMenu,...
    'Separator','on',....
    'MenuSelectedFcn',@(hObject,~)ImportFromFileContextMenu_ItemClicked(hObject,app,'table and timetable'),...
    'Label','Table and Timetable',...
    'Tag','tableandtimetable');
app.GUI.(get(h,'Tag')) = h;
if isequal(app.UtilityData.MatImportMethod,'table and timetable')
    h.Checked = 'on';
end

matIndex = find(matches(app.Settings.CustomImportTable{:,"Extension"},["mat",".mat","*.mat"]));
    for iMatIndex = matIndex(:)'
        h = uimenu(...
            'Parent',app.GUI.ImportFromFileContextMenu,...
            'MenuSelectedFcn',@(hObject,~)ImportFromFileContextMenu_ItemClicked(hObject,app,app.Settings.CustomImportTable{iMatIndex,"Function"}),...
            'Label',app.Settings.CustomImportTable{iMatIndex,"Text"});
        if isequal(app.UtilityData.MatImportMethod,app.Settings.CustomImportTable{iMatIndex,"Function"})
            h.Checked = 'on';
        end
    end
end

function ImportFromFileContextMenu_ItemClicked(hObject,app,importMethod)
    app.UtilityData.MatImportMethod = importMethod;
    set(get(get(hObject,'Parent'),'Children'),'Checked','off');
    set(hObject,'Checked','on');
end

function alwaysOnTopToggle(hObject,app)
    if hObject.Value == 1
        app.GUI.main_GUI.WindowStyle = 'alwaysontop';
    else
        app.GUI.main_GUI.WindowStyle = 'normal';
    end
end

function setDoubleClickTarget_Callback(hObject,app,target)
    app.UtilityData.DoubleClickTarget = target;
    set(get(get(hObject,'Parent'),'Children'),'Checked','off');
    set(hObject,'Checked','on');
end



function StandardXaxisMenu_Callback(hObject,~,app)
% This function create a Menu with the list of variables being contained in
% the subsystem selected for the default X axis. If clicked the variable is 
% set as the X axis.

% Clear ContextMenu from a previuos list
previous_list = get(hObject,'Children');
delete(previous_list);

% Get data
favoriteXAxisList = app.Settings.FavoriteXAxisList;


h = uimenu(...
    'Parent',hObject,...
    'Callback',{@assignValueToXAxisCallback,string.empty},...
    'Label','None');
if isempty(app.XAxis)
    set(h,'Checked','on');
end

if favoriteXAxisList ~= ""
    for ii = 1:length(favoriteXAxisList)
        h = uimenu(...
            'Parent',hObject,...
            'Callback',{@assignValueToXAxisCallback,favoriteXAxisList(ii)},...
            'Label',favoriteXAxisList(ii));
        if app.XAxis == favoriteXAxisList(ii)
            set(h,'Checked','on');
        end
    end
end

h = uimenu(...
    'Parent',hObject,...
    'Callback',@(~,~) kvsettingsGUI(app),...
    'Separator','on',...
    'Label','Add more...');

    function assignValueToXAxisCallback(~,~,value)
        app.XAxis = value;
    end

end


function listboxClickCallback(hObject, ~, app,doPlot)

% check if the listbox isempty
if hObject.Tag == "listbox2"
    if isempty(hObject.Children)
        return
    end
else
    if isempty(hObject.Items) 
        return
    end
end

% refresh all the listboxes (needed in case the selection is changed)
if hObject.Tag == "listbox1"
    app.refresh(app.GUI.listbox2);
elseif hObject.Tag == "listbox2"
    app.refresh(app.GUI.listbox3);
end

if doPlot
    % doPlot is true if the listbox was doubleclicked
    app.plot(app.UtilityData.DoubleClickTarget);
elseif app.GUI.DynamicPlotCheck.Value
    % if che dynamic check is true run the plot function
	app.plot('Dynamic');
end

end


function duplicateElementCallback(~,~,app,listboxHandle)

switch get(listboxHandle,'tag')
    
    case 'listbox1'
        duplicatedDataset = app.selectedDataset;
        newNameList = string(matlab.lang.makeUniqueStrings([duplicatedDataset.Name],[app.DatasetList.Name]));
        [duplicatedDataset.Name] = newNameList;
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
        
        app.DatasetList(matches(string(app.GUI.listbox1.Items),app.GUI.listbox1.Value)) = [];
        if isempty(app.DatasetList)
            app.DatasetList = struct('Name',{},'Table',{});
            app.GUI.listbox1.Items = {};
            app.GUI.listbox1.ItemsData = [];
            app.GUI.listbox1.Value = {};
            delete(app.GUI.listbox2.Children);
            app.GUI.listbox3.Items = {};
            app.GUI.listbox3.ItemsData = [];
            app.GUI.listbox3.Value = {};
            return
        end 
            
    case 'listbox2'   
        selectedDatasetIndex = app.selectedDatasetIndex();
        selectedGroupList = app.selectedGroup();
        for iCount = selectedDatasetIndex'
            [~, indexMatching] = intersect([app.DatasetList(iCount).Table.Properties.CustomProperties.kvGroup.Name],[selectedGroupList.Name],"stable");
            app.DatasetList(iCount).Table.Properties.CustomProperties.kvGroup(indexMatching) = [];
        end
        
    case 'listbox3'   
        for iDataset = app.selectedDataset()
            app.DatasetList(strcmp([app.DatasetList.Name],iDataset.Name)).Table = removevars(iDataset.Table,app.selectedVariableName()); 
        end

end

app.refresh();

end


function renameElementCallback(~,~,app,listboxHandle)
% ListboxHandle handle to the selected/focused listbox

if strcmp(get(listboxHandle,'tag'),'listbox2')
    error('Group renaming is not supported.');  
end

selectedListboxValue = listboxHandle.Value;

% check number of items selected
if numel(selectedListboxValue)>1
    disp('ERROR: you have selected too many items in the listbox. When you are renameing an item you can select only one at time.');
    return
end
    currentName = string(selectedListboxValue);


% get new name
newName = inputdlg('Enter new name:','Rename',[1 50],currentName,'on');

% check new name
if isempty(newName)
    return
elseif strcmp(newName{1},currentName) % no change
    return
elseif ~isvarname(newName{1})
    disp(['ERROR: ' newName{1} ' is not a valid name.']);
    return
end
        
% act depending on the listbox focused
switch get(listboxHandle,'tag')
    
    case 'listbox1'
        if any(strcmp([app.DatasetList.Name],newName{1}))
            disp(['ERROR: there is already another item with the name ' newName{1}]);
            return
        end
        app.DatasetList(strcmp([app.DatasetList.Name],currentName)).Name = newName;

    case 'listbox3'
        for iDatasetIndex = app.selectedDatasetIndex()'
            if any(strcmp(app.DatasetList(iDatasetIndex).Table.Properties.VariableNames,newName{1}))
                disp("ERROR: there is already another item with the name " + newName{1} + " in dataset " + app.DatasetList(iDatasetIndex).Name);
                return
            end
            app.DatasetList(iDatasetIndex).Table = renamevars(app.DatasetList(iDatasetIndex).Table,currentName,newName);
        end
        
end


% update DatasetList and listbox contents
app.refresh();

% Select the renamed dataset
set(listboxHandle,'Value',newName);

% refresh again
app.refresh();

end


function SetXAxis_Callback(~,~,app)
% Set the selected variable as the new XAxis
if length(app.GUI.listbox2.SelectedNodes)==1 && length(app.GUI.listbox3.Value)==1
    app.XAxis = app.GUI.listbox3.Value;
else
    disp('ERROR: you have selected too many groups or variables.')
end
end


function setLinkAxesDimension(hObject,app)
    app.UtilityData.LinkAxesDimension = hObject.Value;
end

function XAxisSetDefault_Callback(~,~,app)
% Reset the X axis to the default value.
% TODO: check what I have already done on the other PC and re implement
% here

app.XAxis = [];

end


function customPanelManager(hObject, ~, app)

    % clear the content of the custom panel
    if ~isempty(app.GUI.CustomPanel1.Children)
        delete(app.GUI.CustomPanel1.Children);
    end

    if hObject.Value == ""
        app.GUI.CustomPanel1.Parent.Heights(3) = 0;
    else
        app.customButtons(hObject.Value);
    end

end

function createCustomPanelDropDownItemList(hObject,app)
    customItemList = unique(app.Settings.CustomButtonTable{:,"Group"});
    hObject.Items = [{'-- None --'} "Buttons: " + customItemList(:).'];
    hObject.ItemsData = [{''} customItemList(:).'];
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



function aboutWindow(~,~,hFig)
% Create a window with information about the license, version and github.

installedToolboxes = matlab.addons.toolbox.installedToolboxes();
kviewInfo = installedToolboxes([string({installedToolboxes().Name})] == "kview");
if isempty(kviewInfo)
    kviewInfo = struct('Version','UNKOWN');
end

% Actual message displayed.
message = {'<center><strong style="font-size:20;">kview</strong>';...
    '';...
    ['Version: ' kviewInfo.Version];...
    'Github: <a href="https://github.com/micoro/kview">https://github.com/micoro/kview</a></center>';...
    '<hr>';...
    'kview uses the following code distribuited under the BSD license:';...
    '<ul><li>UnitConversion by John McDermid</li></ul>';...
    'Full license files can be found in the installation directory.'};

uialert(hFig,message,"About",...
    "Icon","none", ...
    "Interpreter","html");

end

