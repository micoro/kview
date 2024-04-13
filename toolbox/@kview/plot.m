function plot(app, targetFigure, varargin)
% PLOT is method of the kview class; plots the selected variables.
%
% SYNTAX:   
%   kviewObject.plot(targetFigure)
%   kviewObject.plot(targetFigure,TableList) -- NOT WORKING, TODO
%   plot(kviewObject,...)
%
% INPUT:
%   kviewObject     the kview Object
%   targetFigure    where will be created the plot. Possible values are:
%                   "NewFigure", "CurrentFigure", "Click" and "Dynamic".
%                   The "Click" options read a popupmenu in the GUI to know
%                   which option to use (NewFigure or CurrentFigure).
%                   "Dynamic" is used buy the GUI to continuosly update a 
%                   specific figure whenever the selection in the GUI 
%                   changes.
%   
% INPUT [OPTIONAL]:
%   TableList       Instead of the selected variables it is possible to 
%                   supply a list of tables to be plotted.



%% Initialization

% get data
handles = app.GUI;
ShowLegend = getappdata(handles.main_GUI,'ShowLegend');


if isempty(app.XAxis)
    plotXData = false;
else
    plotXData = true;
end

if nargin>3
    dataset = varargin{1};
else
    dataset = app.selectedDataset;
end

% Check X Axis
% Check if the selected X axis exist for all the selected datasets
if plotXData
    for iDataset = dataset
        if ~any(strcmp(iDataset.Table.Properties.VariableNames,app.XAxis))
            display('WARNING: the variable ' + app.XAxis + ' selected as X axis is not a variable of ' + iDataset.Name);
            plotXData = false;
            break
        end
    end
end


%% Select Target
if strcmp(targetFigure,'Click')
    targetFigure = app.GUI.TargetFigure.Value;
end

switch targetFigure
    case {'NewFigure','New Figure'}
        figure_handle = figure('WindowStyle','docked','Visible','off','NumberTitle','on',app.kvFigureProperty);
        axes_handle = axes;
    case {'CurrentFigure', 'Current Figure'}
        figure_handle = gcf;
        axes_handle = gca;
    case 'Dynamic'
        DynamicTargetHandle = app.UtilityData.DynamicTargetHandle;
        if ~isempty(DynamicTargetHandle) && isvalid(DynamicTargetHandle)
            figure_handle = clf(DynamicTargetHandle);
        else
            figure_handle = figure('WindowStyle','normal','NumberTitle','off','HandleVisibility','off',app.kvFigureProperty);
            app.UtilityData.DynamicTargetHandle = figure_handle;
        end
        axes_handle = axes(figure_handle);
end

set(axes_handle,'NextPlot','add');
set(figure_handle, 'DefaultTextInterpreter', 'none', 'DefaultLegendInterpreter', 'none');

drawnow limitrate

%% Initialize data 
if isempty(handles.listbox3.Items)
    disp('WARNING: nothing to plot.');
    return 
end
% y_axis = handles.listbox3.Value{1};
% axis_unit = cell(2);
% 
% if plotXData
%     if isfield(DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(XAxisSubsysName).(XAxisVarName),'unit')
%         axis_unit{1} = DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(XAxisSubsysName).(XAxisVarName).unit;
%     end
% end
% if isfield(DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(contents_listbox2{value_listbox2(1)}).(y_axis),'unit')
%     axis_unit{2} = DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(contents_listbox2{value_listbox2(1)}).(y_axis).unit;
% end
                


%% PLOT 
for iDataset = dataset
    if plotXData
        plot(axes_handle, ...
            iDataset.Table(:,[app.selectedVariableName; app.XAxis]), ...
            app.XAxis, ...
            app.selectedVariableName);
    else  
        plot(axes_handle, ...
            iDataset.Table(:,app.selectedVariableName), ...
            app.selectedVariableName);
    end
end


% Set Figure name 
if strcmp(targetFigure,'Dynamic')
    set(figure_handle,'Name','kview Dynamic Plot');
else
    drawnow % force update of the axes to be sure that the label is already present otherwise the code is too fast and reads and empty label
    set(figure_handle,'Name',axes_handle.YLabel.String);
end


%% Legend




%% End

% raise the kview above the newly creted figure
set(figure_handle,'Visible','on');
drawnow;
figure(handles.main_GUI);

end
