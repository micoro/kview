function kviewPlot(hObject,~, Target, varargin)
% Function to plot curves with kview standards.
%
% SYNTAX:   
%   kviewPlot(hObject,eventdata,Target)
%   kviewPlot(hObject,eventdata,Target,DatasetsStruct)
%
% INPUT:
%   hObject     Used to get the kview GUI handle. Any handle of an object
%               belonging to the GUI can be used.
%   eventadata  Not used
%   Target      where will be created the plot. Possible values are:
%               "NewFigure", "CurrentFigure", "Click" and "Dynamic"
%   
% INPUT [OPTIONAL]:
%   DatasetsStruct  If a datasets struct is supplied here it takes 
%                   precedence over the DatasetsStruct stored into the GUI.
%
% -------------------------------------------------------------------------
%   Copyright (C) 2015, All Rights Reserved.
%
%   Date:    05/09/2015
%   Author:  Michele Oro Nobili 
%
%   v1.1 - modified the code to cycle color and line style. 





%% ----------------------------------------------------- Initialization ---

% get data
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');
XAxisVarName = getappdata(handles.main_GUI,'XAxisVarName');
XAxisSubsysName = getappdata(handles.main_GUI,'XAxisSubsysName');
kviewColorOrder = getappdata(handles.main_GUI,'kviewColorOrder');
kviewColorOrderMethod = getappdata(handles.main_GUI,'kviewColorOrderMethod');
kviewLineStyleOrder = getappdata(handles.main_GUI,'kviewLineStyleOrder');
kviewLineStyleOrderMethod = getappdata(handles.main_GUI,'kviewLineStyleOrderMethod');
kviewMarkerOrder = getappdata(handles.main_GUI,'kviewMarkerOrder');
kviewLineWidth = getappdata(handles.main_GUI,'kviewLineWidth');
ShowLegend = getappdata(handles.main_GUI,'ShowLegend');
kvFigureProperty = getappdata(handles.main_GUI,'kvFigureProperty');


if isempty(XAxisSubsysName)
    plotXData = false;
else
    plotXData = true;
end

if nargin>3
    DatasetsStruct = varargin{1};
else
    DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
end



% --- Check X Axis ----------
% Check if the selected X axis exist for all the selected datasets
if plotXData
    for ii=value_listbox1
        if isfield(DatasetsStruct.(contents_listbox1{ii}),XAxisSubsysName)
            if ~isfield(DatasetsStruct.(contents_listbox1{ii}).(XAxisSubsysName),XAxisVarName)
                display(['WARNING: the variable ' XAxisSubsysName '.' XAxisVarName ' selected as X axis is not a field of ' contents_listbox1{ii}]);
                plotXData = false;
            end
        else
            display(['WARNING: the subsystem ' XAxisSubsysName ' needed for the X axis is not a field of ' contents_listbox1{ii}]);
            plotXData = false;
        end
    end
end
% ---------------------------


%% ------------------------------------------------------ Select Target ---
switch Target
    case 'NewFigure'
        figure_handle = figure('WindowStyle','docked','Visible','off','NumberTitle','on',kvFigureProperty);
        axes_handle = axes;
    case 'CurrentFigure'
        figure_handle = gcf;
        axes_handle = gca;
        legend(axes_handle,'off');
    case 'Click'
        value_TargetFigure = get(handles.TargetFigure,'Value');
        contents_TargetFigure = cellstr(get(handles.TargetFigure,'String'));
        if strcmp(contents_TargetFigure{value_TargetFigure},'Current Figure')
            figure_handle = gcf;
            axes_handle = gca;
        else
            figure_handle = figure('WindowStyle','docked','NumberTitle','on',kvFigureProperty);
            axes_handle = axes;
        end
    case 'Dynamic'
        DynamicTargetHandle = getappdata(handles.main_GUI,'DynamicTargetHandle');
        if ishandle(DynamicTargetHandle)
            if isappdata(DynamicTargetHandle,'iskviewDynamicTarget')
                figure_handle = clf(figure(DynamicTargetHandle));
            else
                figure_handle = figure('WindowStyle','normal','NumberTitle','off','HandleVisibility','off');
                setappdata(handles.main_GUI,'DynamicTargetHandle',figure_handle);
                setappdata(figure_handle,'iskviewDynamicTarget',1);
            end
        else
            figure_handle = figure('WindowStyle','normal','NumberTitle','off','HandleVisibility','off');
            setappdata(handles.main_GUI,'DynamicTargetHandle',figure_handle);
            setappdata(figure_handle,'iskviewDynamicTarget',1);
        end
        axes_handle = axes('XGrid','on','YGrid','on','Box','on','FontSize',16,'parent',figure_handle);

end

set(axes_handle,'NextPlot','add');
set(datacursormode(figure_handle),'UpdateFcn',@kvDatacursor); 
set(figure_handle, 'DefaultTextInterpreter', 'none', 'DefaultLegendInterpreter', 'none');

drawnow limitrate

% --------------------- Initialize data --------------------------------- %
if isempty(contents_listbox3)
    display('WARNING: nothing to plot.');
    return 
end
y_axis = contents_listbox3{value_listbox3(1)};
axis_unit = cell(2);

if plotXData
    if isfield(DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(XAxisSubsysName).(XAxisVarName),'unit')
        axis_unit{1} = DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(XAxisSubsysName).(XAxisVarName).unit;
    end
end
if isfield(DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(contents_listbox2{value_listbox2(1)}).(y_axis),'unit')
    axis_unit{2} = DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(contents_listbox2{value_listbox2(1)}).(y_axis).unit;
end
% ----------------------------------------------------------------------- %                   


%% --------------------------------------------------------------- PLOT ---

% Initialize data to determine line color and style 
count.total = 0;
count.Dataset = 0;
count.Subsystem = 0;
count.Variable = 0;
count.Manual = 1;
count.Auto = 1;
count.max.Manual = 1;
count.max.Variable = length(value_listbox3);
count.max.Subsystem = length(value_listbox2); 
count.max.Dataset = length(value_listbox1); 
count.max.Auto = 1; % placeholder

if strcmp(kviewColorOrderMethod,'Auto')
    sequenceArray = zeros(count.max.(kviewLineStyleOrderMethod),1);
else
    sequenceArray = zeros(count.max.(kviewColorOrderMethod),1);
end

% plot lines cycle
for ii=value_listbox1
    
    count.Dataset = count.Dataset + 1;
    count.Subsystem = 0;
    count.Variable = 0;
    
    % Check unit of the XAxis
    if plotXData
        if isfield(DatasetsStruct.(contents_listbox1{ii}).(XAxisSubsysName).(XAxisVarName),'unit') && ~strcmp(axis_unit{1},'diverse')
            if ~strcmp(DatasetsStruct.(contents_listbox1{ii}).(XAxisSubsysName).(XAxisVarName).unit,axis_unit{1})
                axis_unit{1} = 'diverse';
            end
        elseif ~isempty(axis_unit{1})
            axis_unit{1} = 'diverse';
        end
    end
    
    for jj=value_listbox2
        
        count.Subsystem = count.Subsystem + 1;
        count.Variable = 0;      
        
        for kk=value_listbox3
           
            % Check unit of the YAxis
            if isfield(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}),'unit') && ~strcmp(axis_unit{2},'diverse')
                if ~strcmp(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit,axis_unit{2})
                    axis_unit{2} = 'diverse';
                end
            elseif ~isempty(axis_unit{2})
                axis_unit{2} = 'diverse';
            end
            

            % Determine the linestyle and color sequence
            count.Variable = count.Variable + 1;
            count.total = count.total + 1;
            
            if all(strcmp({kviewColorOrderMethod,kviewLineStyleOrderMethod},'Auto'))
                
                ColorNum = rem(count.total-1,length(kviewColorOrder(:,1))) + 1;
                LineStyleNum = floor(rem(count.total-1,length(kviewLineStyleOrder)*length(kviewColorOrder(:,1)))/length(kviewColorOrder(:,1))) + 1;
            
            else
                
                ColorNum = rem(count.(kviewColorOrderMethod)-1,length(kviewColorOrder(:,1))) + 1;
                LineStyleNum = rem(count.(kviewLineStyleOrderMethod)-1,length(kviewLineStyleOrder)) + 1;
                
                if strcmp(kviewColorOrderMethod,'Auto')
                    sequenceArray(LineStyleNum) = sequenceArray(LineStyleNum) + 1;
                    ColorNum = rem(sequenceArray(LineStyleNum)-1,length(kviewColorOrder)) + 1;
                end           

                if strcmp(kviewLineStyleOrderMethod,'Auto')
                    sequenceArray(ColorNum) = sequenceArray(ColorNum) + 1;
                    LineStyleNum = rem(sequenceArray(ColorNum)-1,length(kviewLineStyleOrder)) + 1;
                end
                
            end
            
          
            
            % PLOT CURVE
            l = plot(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data,...
                'DisplayName',[contents_listbox1{ii} '.' contents_listbox2{jj} '.' contents_listbox3{kk}],...
                'LineStyle',kviewLineStyleOrder{LineStyleNum},...
                'LineWidth',kviewLineWidth,...
                'Marker',kviewMarkerOrder{1},...
                'Color',kviewColorOrder(ColorNum,:),...
                'parent',axes_handle);
            if plotXData
                set(l,'XData',DatasetsStruct.(contents_listbox1{ii}).(XAxisSubsysName).(XAxisVarName).data);
            else
                set(l,'XData',1:length(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data));
            end
            setappdata(l,'KviewLineInfo',{contents_listbox1{ii},contents_listbox2{jj},contents_listbox3{kk},XAxisSubsysName,XAxisVarName}); % for future use
        
        end
    end
end


%% ------------------------------------------------------------- Labels ---

% Set Axis label names and unit
if length(value_listbox3)>1
    YVarString = '';
else
    YVarString = contents_listbox3{value_listbox3};
end  

if ~plotXData
    XVarString = 'points';
elseif strcmp(XAxisSubsysName,'kviewXStandard')
    XVarString = XAxisVarName;
else
    XVarString = [XAxisSubsysName '.' XAxisVarName];
end


if isempty(axis_unit{1})
    set(get(axes_handle,'XLabel'),'Interpreter','none','FontSize',16,'String',XVarString);
else
    set(get(axes_handle,'XLabel'),'Interpreter','none','FontSize',16,'String',[XVarString ' [' axis_unit{1} ']']);
end
if isempty(axis_unit{2})    
    set(get(axes_handle,'YLabel'),'Interpreter','none','FontSize',16,'String',YVarString);
else
    set(get(axes_handle,'YLabel'),'Interpreter','none','FontSize',16,'String',[YVarString ' [' axis_unit{2} ']']);
end

% Set Figure name 
if strcmp(Target,'Dynamic')
    set(figure_handle,'Name','kview Dynamic Plot');
else
    set(figure_handle,'Name',YVarString);
end


%% ------------------------------------------------------------- Legend ---




%% ---------------------------------------------------------------- End ---

% raise the kview above the newly creted figure
set(figure_handle,'Visible','on');
drawnow;
figure(handles.main_GUI);
end
