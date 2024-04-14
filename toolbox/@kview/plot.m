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

%% Check X Axis
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

drawnow limitrate

%% Initialize data 
if isempty(handles.listbox3.Items)
    disp('WARNING: nothing to plot.');
    return 
end


%% Cycling logic and legend nameing scheme
% determine how to cycle linecolor and linestyle and what to write in the
% legend (using line 'DisplayName' property)

% assign the type of cycle to the three different level 
% dataset, group and variable

% default values
datasetCycle = "none";
groupCycle = "none";
variableCycle = "none";

% displayNameMethod can be varible or dataset 
% variable is the default, dataset is used only if just one variable is
% present and more than one dataset is plotted.
displayNameMethod = "variable";
displayNameItem = "";

% auto logic to assign the value
if length(app.selectedVariableName) > 1
    displayNameMethod = "variable";
    variableCycle = "color";
    if length(app.selectedDatasetIndex) > 1
        datasetCycle = "style";
    else 
        groupCycle = "style";
    end
else
    if length(app.selectedDatasetIndex) > 1
        displayNameMethod = "dataset";
        datasetCycle = "color";
        groupCycle = "style";
    else 
        groupCycle = "color";
    end
end


%% PLOT 
for iDataset = dataset
    if displayNameMethod == "variable"
        displayNameItem = app.selectedVariableName;
        if length(dataset)>1
            displayNameItem = append(iDataset.Name,".",displayNameItem);
        end
    elseif  displayNameMethod == "dataset"
        displayNameItem = iDataset.Name;
    end

     if plotXData
        hLineList = plot(axes_handle, ...
            iDataset.Table(:,[app.selectedVariableName; app.XAxis]), ...
            app.XAxis, ...
            app.selectedVariableName);
    else  
        hLineList = plot(axes_handle, ...
            iDataset.Table(:,app.selectedVariableName), ...
            app.selectedVariableName);
     end
     [hLineList.DisplayName] = displayNameItem{:};
     if datasetCycle == "color"; axes_handle.ColorOrderIndex = axes_handle.ColorOrderIndex+1; end
     if datasetCycle == "style"; axes_handle.LineStyleOrderIndex = axes_handle.LineStyleOrderIndex+1; end
end


% Set Figure name 
if strcmp(targetFigure,'Dynamic')
    set(figure_handle,'Name','kview Dynamic Plot');
else
    drawnow % force update of the axes to be sure that the label is already present otherwise the code is too fast and reads and empty label
    set(figure_handle,'Name',axes_handle.YLabel.String);
end


%% Legend
if app.GUI.LegendCheck.Value
    legend(axes_handle,"show");
end


%% End

% raise the kview above the newly creted figure
set(figure_handle,'Visible','on');
drawnow;
figure(handles.main_GUI);

end
