classdef kview < handle
% KVIEW is the main function for the kview.
% 
% SYNTAX:
%
% INPUTS:
%
% OUTPUTS:
%
%
% -------------------------------------------------------------------------
%   


    properties
        DatasetList                 struct 
        Settings                    struct
        XAxis                       string
        UtilityData                 struct = struct
        kvFigureProperty            struct = struct % contains the properties to use in the figures created by kview

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
            % app (even if not constructed yet)
            if nargin && any(strcmpi(varargin{1},["isopen","query","check"]))
                return
            end

            % create the default DatasetList
            app.DatasetList = struct('Name',{},'Table',{});
            
            % import settings
            app.Settings = kview.getSettings();

            % Preallocate some data needed for utility
            app.UtilityData.SortOrderMethod = {'original' 'alphabetical' 'alphabetical'};
            app.UtilityData.MatImportMethod = function_handle.empty;
            app.UtilityData.DoubleClickTarget = "NewFigure";
            app.UtilityData.DynamicTargetHandle = [];
            app.UtilityData.CopiedElements = {struct,0};
            app.UtilityData.ShowLegend = false;
            app.UtilityData.defaultGroup = app.newkvGroup("all","all",[]);
            app.UtilityData.FontSize = 14;

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
            app.kvFigureProperty.defaultLineLineWidth = 1;
            app.kvFigureProperty.defaultTextInterpreter = 'none';
            app.kvFigureProperty.defaultLegendInterpreter = 'none';
            app.kvFigureProperty.defaultAxesTickLabelInterpreter = 'none';


            % create the GUI
            app.GUI.FigureHandle = kview.createFcn(app);

            % assign the kvSingleton
            kvSingleton = app;

        end

        function selection = selectedDataset(app)
            % check if the listbox is empty
            if isempty(app.GUI.listbox1.Items); selection = []; return; end

            % get the selected dataset
            [~, indexMatching] = intersect([app.DatasetList.Name],app.GUI.listbox1.Value,"stable");
            selection = app.DatasetList(indexMatching);
        end

        function selectedIndex = selectedDatasetIndex(app)
            % check if the listbox is empty
            if isempty(app.GUI.listbox1.Items); selectedIndex = []; return; end

            % get the selected datasets
            [~, selectedIndex] = intersect([app.DatasetList.Name],app.GUI.listbox1.Value,"stable");
        end

        function selection = selectedGroup(app)
            % check if the listbox is empty
            if isempty(app.GUI.listbox2.SelectedNodes); selection = []; return; end

            % get the selected groups
            selection = [app.GUI.listbox2.SelectedNodes.NodeData];
        end

        function selectedVariableNameList = selectedVariableName(app)
            % check if the listbox is empty
            if isempty(app.GUI.listbox3.Items); selectedVariableNameList = []; return; end

            % get the selected variables name visualized in the listbox
            selectedVariableNameList = string([app.GUI.listbox3.Value{:}]);
   
        end

        function selectedVariableNameList = selectedVariableNameCropped(app)
            % check if the listbox is empty
            if isempty(app.GUI.listbox2.Items); selectedVariableNameList = []; return; end

            % get the selected variables name visualized in the listbox
            selectedVariableNameList = string(app.GUI.listbox3.Value);
    
        end


        function addDataset(app,t,datasetName,opt)
            %ADDDATASET function to add dataset into the kview object
            %
            % ADDDATASET(app,t)
            % ADDDATASET(app,t,datasetName)
            % ADDDATASET(...,Name-Value)
            %
            % INPUT
            %   app: kview object 
            %   t: table to add to the kview
            %   datasetName: optional input. The name to be used when
            %       importing th new table.
            %  
            % NAME-VALUE
            %   refreshFlag: logical, default is true. Depending on this 
            %   value the kview may be refreshed after the import.


            arguments
                app % kview object
                t % class validation done below, two options possible
                datasetName string {mustBeTextScalar, mustBeValidVariableName} = "dataset"
                opt.refreshFlag logical = true
            end

            % validating input: must be table or timetable
            if ~istable(t) && ~istimetable(t)
                error("Data imported by the kview must be in table or timetable format.")
            end

            % make the name unique
            datasetName = matlab.lang.makeUniqueStrings(datasetName, [app.DatasetList.Name]);

            % check if the kvGroup custom property exist and in case creates it.
            if ~isprop(t,"kvGroup")
                t = addprop(t,"kvGroup","table");
                t.Properties.CustomProperties.kvGroup = app.newkvGroup({}, {}, {}); % create empty kvGroup struct
            end

            % import the data into the kview object
            app.DatasetList(end+1).Name = datasetName;
            app.DatasetList(end).Table = t;
            
            % message
            disp(datasetName + " imported into the kview.");

            % refresh the kview to show the added datasets
            if opt.refreshFlag
                app.refresh();
            end

        end


        function exportToWorkspace(app)
            for iDataset = app.selectedDataset()
                assignin("base",iDataset.Name,iDataset.Table);
            end
        end


        function exportToMat(app)
            if numel(app.selectedDataset) == 1
                defName = app.selectedDataset.Name;
            else
                defName = '';
            end
            [filename,path]  = uiputfile({'*.mat','MAT-files (*.mat)'},'Save',defName);
            matobject = matfile(fullfile(path,filename));
            for iDataset = app.selectedDataset()
                matobject.(iDataset.Name) = iDataset.Table;
            end
        end


        function importFromFile(app)
            
            % preallocate
            matImportMethod = function_handle.empty;

            % path is retained from different calls to this function
            persistent path
            if isnumeric(path); path = '';end

            cellArrayOfAvailableExtensions = {'*.mat','Matlab file (*.mat)'};
            
            % find indices in the CustomImportTable that are not .mat files
            notMatIndex = ~matches(app.Settings.CustomImportTable{:,"Extension"},["mat",".mat","*.mat"]);

            % create filter for the uigetfile function
            cellArrayOfAvailableExtensions = [cellArrayOfAvailableExtensions;...
                ["*." + erase(app.Settings.CustomImportTable{notMatIndex,"Extension"},("*."|"*"|".")),...
                app.Settings.CustomImportTable{notMatIndex,"Text"} + " (*." + erase(app.Settings.CustomImportTable{notMatIndex,"Extension"},("*."|"*"|".")) + ")"]];
            cellArrayOfAvailableExtensions = [cellArrayOfAvailableExtensions; {'*','All files'}];
            
            % add all supported file extensions as first option
            cellArrayOfAvailableExtensions = [strjoin(["*.mat" "*." + erase(app.Settings.CustomImportTable{notMatIndex,"Extension"},("*."|"*"|".")).'],';'),"All supported file extensions" ;...  
                cellArrayOfAvailableExtensions]; 

            % uigetfile
            [file,path,extIndex] = uigetfile(cellArrayOfAvailableExtensions,'Select file to import',path,"MultiSelect","on");
            
            % if nothing is selected return (uigetfile returns a 0 in ext)
            if extIndex == 0
                return
            end
            
            % make sure that file is alwyas a cell array even if only one
            % file is selected
            if ~iscell(file)
                file = {file};
            end

            for iFile = file
                
                [~,~,ext] = fileparts(iFile);

                if matches(ext,["mat",".mat","*.mat"])

                    % if importing a matfile find the correct method of
                    % import

                    if isempty(matImportMethod)
                        if isempty(app.UtilityData.MatImportMethod)

                            customMatImportTable = app.Settings.CustomImportTable(matches(app.Settings.CustomImportTable{:,"Extension"},["mat",".mat","*.mat"]),:);

                            [methodSelected, selectLogical] = listdlg('ListString', ...
                                [{'table and timetable'},customMatImportTable{:,"Text"}],...
                                'SelectionMode','single','PromptString',"Import method for Mat-files","InitialValue",1);
                            if ~selectLogical 
                                return
                            elseif methodSelected == 1
                                matImportMethod = 'table and timetable';
                            else
                                matImportMethod = customMatImportTable{methodSelected,"Function"};
                            end
                        else
                            matImportMethod = app.UtilityData.MatImportMethod;
                        end
                    end

                    if isequal(matImportMethod,'table and timetable')
                        importData = load(fullfile(path,iFile{1}));
                        for iField = fieldnames(importData)'
                            if istimetable(importData.(iField{1})) || istable(importData.(iField{1}))
                                app.addDataset(importData.(iField{1}),iField{1});
                            else
                                warning(iField{1} + " from file " + iFile{1} + " is not a table or timetable and was not imported.");
                            end
                        end
                    else
                        feval(matImportMethod, fullfile(path,iFile{1}));
                    end
                else
                    % if importing a different extension find if it is
                    % available in the app.Settings.CustomImportTable
                    customImportIndex = find(matches(app.Settings.CustomImportTable{:,"Extension"},[string(ext) string(remove(ext,".",""))]));
                    if numel(customImportIndex) == 0
                        error("No custom import setting was found for extension '" + ext + "'");
                    elseif numel(customImportIndex) >= 2
                        error("Too many import setting found for extension '" + ext + "'");
                    else
                        feval(app.Settings.CustomImportTable{customImportIndex,"Function"}, fullfile(path,iFile{1}));
                    end
                end

            end
        end
        

        function set.XAxis(app, Value)
            app.XAxis = Value;
            if isempty(Value) || Value == ""
                app.GUI.XAxisVarName.Text = "None";
            else 
                app.GUI.XAxisVarName.Text = Value; 
            end
        end 

        function delete(app)
            %DELETE the figure (will automatically delete all the children)
            delete(app.GUI.FigureHandle)
        end

    end

    methods (Static, Access=private)
        out = createFcn(app)
        populateTree(treeHandle, kvGroupList)
    end

    methods (Static)

        out = getSettings() 
        out = newkvGroup(name, type, content)
        out = kvGroupComparison(kvGroupArrayA,kvGroupArrayB)

        function [filteredSignalList, filteredSignalListShortened] = filterByGroup(dataset, group)

            if isempty(group) || strcmp(group,'all')
                filteredSignalList = dataset.Table.Properties.VariableNames;
                filteredSignalListShortened = filteredSignalList;
            else

                switch group.Type

                    case "prefix"
                        filteredSignalList = dataset.Table.Properties.VariableNames(...
                            startsWith(dataset.Table.Properties.VariableNames,group.Content + (" "|"_"|".")));
                        filteredSignalListShortened = replace(filteredSignalList, group.Content + (" "|"_"|"."),"");

                    case "custom"
                        filteredSignalList = intersect(group.Content,dataset.Table.Properties.VariableNames,"stable");
                        filteredSignalListShortened = filteredSignalList;
                       
                    case "all"
                        filteredSignalList = dataset.Table.Properties.VariableNames;
                        filteredSignalListShortened = filteredSignalList;

                end
            end
        end


        function [flag, app] = isOpen()
            % check if the kview app is already open
            app = kview("isopen");
            if ~isempty(app) && isvalid(app) && ~isempty(app.GUI.FigureHandle)
                flag = true;
            else
                flag = false;
            end
        end
    end
end
