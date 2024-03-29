classdef kview < handle
% KVIEW is the main function for the kview.
% 
% Full help: <a href="matlab:open(fullfile(fileparts(which('kview.m')),'html','mainpage.html'))">kview help page</a>
% 
% SYNTAX:
%
% INPUTS:
%
% OUTPUTS:
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    12/10/2016
%   Author:  Michele Oro Nobili 

    properties
        DatasetList                 struct 
        Settings                    struct
        XAxis                       string
        UtilityData                 struct = struct
        kvFigureProperty            struct = struct % contains the properties to use in the figures created by kview
        kvLineProperty              struct = struct % contains the properties to use in the lines created by kview

        % a struct containing all the handles to the GUI. The main figure
        % handle is preallocated
        GUI                         struct = struct("FigureHandle",[])
    end
    
    methods

        % main function
        function app = kview(varargin)
        
            persistent kvSingleton
            
            % if app already exist simply return it
            if ~isempty(kvSingleton) && isvalid(kvSingleton)
                app = kvSingleton;
                return
            end
            
            % if the caller was only checking on existance just return the
            % app (evn if not constructed yet)
            if nargin && any(strcmpi(varargin{1},["isopen","query","check"]))
                return
            end

            % create the default DatasetList
            app.DatasetList = struct('Name',{},'Table',{});
            
            % import settings
            app.Settings = kview.getSettings();

            % Preallocate some data needed for utility
            app.UtilityData.FileImportDir = '';
            app.UtilityData.ConvTableDir = strrep(which('kview.m'),'@kview/kview.m','ConversionTables');
            app.UtilityData.ButtonTableDir = strrep(which('kview.m'),'@kview/kview.m','ButtonTables');
            app.UtilityData.SortOrderMethod = {'original' 'alphabetical' 'alphabetical'};
            app.UtilityData.DynamicTargetHandle = [];
            app.UtilityData.CopiedElements = {struct,0};
            app.UtilityData.ShowLegend = false;
            app.UtilityData.defaultGroup = struct("Name","all","Type","all","Content",[]);

            % set kvLineProperty
            app.kvLineProperty;
            app.kvLineProperty.LineWidth = 1;
            %app.kvLineProperty.ColorOrderMethod = 'Auto';
            %app.kvLineProperty.LineStyleOrderMethod = 'Auto';
            %app.kvLineProperty.MarkerOrder = {'none'};

            % set kvFigureProperty
            app.kvFigureProperty;
            app.kvFigureProperty.defaultAxesXLimMode = 'auto';
            app.kvFigureProperty.defaultAxesXLim = [0 1];
            app.kvFigureProperty.defaultAxesYLimMode = 'auto';
            app.kvFigureProperty.defaultAxesYLim = [0 1];
            app.kvFigureProperty.defaultAxesXGrid = 'on';
            app.kvFigureProperty.defaultAxesYGrid = 'on';
            app.kvFigureProperty.defaultAxesBox = 'on';
            app.kvFigureProperty.defaultAxesFontSize = 16;
            app.kvFigureProperty.defaultAxesColorOrder = get(0,'DefaultAxesColorOrder');
            app.kvFigureProperty.defaultAxesLineStyleOrder = {'-','--','-.',':'};

            % create the GUI
            app.GUI.FigureHandle = kview.createFcn(app);

            % update the custom panels based on settings
            for ii = 1:size(app.Settings.CustomPanels,1)
                kviewAddCustomPanel(app.GUI.FigureHandle,...
                    app.Settings.CustomPanels{ii,1}, ...
                    app.Settings.CustomPanels{ii,2});
            end

            % assign the kvSingleton
            kvSingleton = app;

        end

        function selection = selectedDataset(app)
            % check if the listbox is empty
            if isempty(app.GUI.listbox1.String); selection = false; return; end

            % get the selected dataset
            listboxItem = string(app.GUI.listbox1.String);
            [~, indexMatching] = intersect([app.DatasetList.Name],listboxItem(app.GUI.listbox1.Value),"stable");
            selection = app.DatasetList(indexMatching);
        end

        function selectedIndex = selectedDatasetIndex(app)
            % check if the listbox is empty
            if isempty(app.GUI.listbox1.String); selectedIndex = false; return; end

            % get the selected datasets
            [~, selectedIndex] = intersect([app.DatasetList.Name],app.GUI.listbox1.String(app.GUI.listbox1.Value),"stable");
        end

        function selection = selectedGroup(app)
            % gets the kvGroups from the first selected dataset: the
            % assumption is that if the selection is available from the
            % group listbox then a check has already been done to assure
            % that all the available groups are equal for the selected 
            % datasets

            % check if the listbox is empty
            if isempty(app.GUI.listbox2.String); selectedIndex = false; return; end

            % get the selected groups
            selDataset = app.selectedDataset;
            fullGroupList = [app.UtilityData.defaultGroup selDataset(1).Table.Properties.CustomProperties.kvGroup];
            [~, indexMatching] = intersect([fullGroupList.Name],app.GUI.listbox2.String(app.GUI.listbox2.Value),"stable");
            selection = fullGroupList(indexMatching);
        end

        function selection = selectedVariable(app)
            % check if the listbox is empty
            if isempty(app.GUI.listbox2.String); selectedIndex = false; return; end

            % get the selected variables
            selection = string(app.GUI.listbox3.String(app.GUI.listbox3.Value));
        end

        function set.XAxis(app, Value)
            app.XAxis = Value;
            if isempty(Value)
                app.GUI.XAxisVarName.String = "None";
            else 
                app.GUI.XAxisVarName.String = Value; 
            end
        end 

        function delete(app)
            %DELETE the figure (will automatically delete all the children)
            delete(app.GUI.FigureHandle)
        end

    end


    methods (Static, Access=private)
        out = createFcn(app)
    end

    methods (Static)

        out = getSettings()

        function [filteredSignalList, filteredSignalListShortened] = filterByGroup(dataset, group)

            if isempty(group) || strcmp(group,'all')
                filteredSignalList = dataset.Table.Properties.VariableNames;
                filteredSignalListShortened = filteredSignalList;
            else

                switch group.Type

                    case "prefix"
                        filteredSignalList = dataset.Table.Properties.VariableNames(...
                            startsWith(dataset.Table.Properties.VariableNames,group.Content));
                        filteredSignalListShortened = replace(filteredSignalList, group.Content + (" "|"_"),"");

                    case "custom"
                        filteredSignalList = intersect(group.Content,dataset.Table.Properties.VariableNames,"stable");
                        filteredSignalListShortened = filteredSignalList;
                       
                    case "all"
                        filteredSignalList = dataset.Table.Properties.VariableNames;
                        filteredSignalListShortened = filteredSignalList;

                end
            end
        end


        function out = isOpen()
            % check if the kview app is already open
            app = kview("isopen");
            if ~isempty(app) && isvalid(app) && ~isempty(app.GUI.FigureHandle)
                out = app;
            else
                out = false;
            end
        end
    end
end
