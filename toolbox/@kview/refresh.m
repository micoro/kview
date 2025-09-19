function refresh(app, listboxHandle)
% This function is used internally to refresh the GUI listboxes.

arguments
    app
    listboxHandle handle = app.GUI.listbox1
end


%% Initialize data 
itemIndexListbox1 = find(matches(app.GUI.listbox1.Items, app.GUI.listbox1.Value));
OrigListboxSelection = {};
CommonFieldsListbox = {};
commonSignalListFullName = {};
commonGroupList = [];

CallerListboxTag = get(listboxHandle,'Tag');


%% Elements in listbox 

% Create a list of all the elements that will be shown in the listbox.
%
% CommonFields is initialized with all the fields of the first selected.
% Dataset. Then in the following loop each non common element is cancelled.

switch CallerListboxTag
    
    case 'listbox1'
        NextListboxHandle = app.GUI.listbox2;
        CommonFieldsListbox = [app.DatasetList.Name];
        
    case 'listbox2'
        NextListboxHandle = app.GUI.listbox3;   
        
        if ~isempty(app.GUI.listbox2.Children)
            selectedNodes = app.GUI.listbox2.SelectedNodes;
            if ~isempty(selectedNodes)
                OrigListboxSelection = [app.GUI.listbox2.SelectedNodes.NodeData];
            end
        end

        % cleare the uitree 
        allNodes = app.GUI.listbox2.Children;
        if ~isempty(allNodes); allNodes.delete; end

        if isempty(itemIndexListbox1)
            % do nothing
        else
          
            commonGroupList = [app.DatasetList(itemIndexListbox1(1)).Table.Properties.CustomProperties.kvGroup];

            for iDataset = app.DatasetList(itemIndexListbox1(2:end))
                commonGroupList = app.kvGroupComparison(commonGroupList,iDataset.Table.Properties.CustomProperties.kvGroup);
            end

            commonGroupList = [app.UtilityData.DefaultGroup, commonGroupList];
            CommonFieldsListbox = [commonGroupList.Name];
            
        end
        
    case 'listbox3'
        if isempty(app.GUI.listbox2.SelectedNodes)
            app.GUI.listbox3.Items = {};
        else
            
            if ~isempty(app.GUI.listbox3.Items)
                OrigListboxSelection =  [];
                for iCount = 1:length(app.GUI.listbox3.Items)
                    for jValue = app.GUI.listbox3.Value
                        if isequal(app.GUI.listbox3.ItemsData(iCount),jValue)
                            OrigListboxSelection = [OrigListboxSelection app.GUI.listbox3.Items(iCount)];
                        end 
                    end
                end
            end
            
            selDataset = app.selectedDataset;
            selGroup = app.selectedGroup;
            [commonSignalListFullName, CommonFieldsListbox] = app.filterByGroup(selDataset(1),selGroup(1));
            commonSignalListFullName = cellfun(@string,cell(1,length(commonSignalListFullName)),'UniformOutput',false);
            for iDataset = app.selectedDataset
                for iGroup = app.selectedGroup
                    [signalListFullName, signalListShortName] = app.filterByGroup(iDataset,iGroup);
                    [CommonFieldsListbox,indexOrderCommon,indexOrderGroup] = intersect(CommonFieldsListbox,signalListShortName,"stable");
                    if isempty(CommonFieldsListbox); continue; end
                    commonSignalListFullName = strcat(commonSignalListFullName(indexOrderCommon), signalListFullName(indexOrderGroup)); %reacreate this list with only the needed signal in the correct order
                end
            end
            commonSignalListFullName = cellfun(@unique,commonSignalListFullName,'UniformOutput',false);

        end
        
        
end


%% Sort/Order
  
if listboxHandle.Tag == "listbox3"
    [CommonFieldsListbox, perm] = sort(CommonFieldsListbox);  
    commonSignalListFullName = commonSignalListFullName(perm); 

    % if the element has a dot in the name it will be shown in the bottom
    % part privileging the elements without dots
    hasDot = contains(CommonFieldsListbox,'.');
    CommonFieldsListbox = [CommonFieldsListbox(~hasDot) CommonFieldsListbox(hasDot)];
    commonSignalListFullName = [commonSignalListFullName(~hasDot) commonSignalListFullName(hasDot)];
end

%% Populate the listbox or tree
if listboxHandle.Tag == "listbox2"
    app.populateTree(listboxHandle, commonGroupList);
    expand(listboxHandle,'all');
else
    listboxHandle.Items = CommonFieldsListbox;
    if listboxHandle.Tag == "listbox3"
        listboxHandle.ItemsData = commonSignalListFullName;
    end
end

%% Listbox Value 

% First check if the listbox is empty, then check which elements are
% selected in listbox and if they still exist re-select them. Otherwise
% set the first element as the selected one.
if listboxHandle.Tag == "listbox2"
    if isempty(listboxHandle.Children) 
        listboxHandle.SelectedNodes = [];
    elseif isempty(OrigListboxSelection)
        listboxHandle.SelectedNodes = listboxHandle.Children(1);
    else 
        nodesToSelect = getAllNodes(listboxHandle,OrigListboxSelection);
        if isempty(nodesToSelect)
            listboxHandle.SelectedNodes = listboxHandle.Children(1);
        else
            listboxHandle.SelectedNodes = nodesToSelect;
            for iNode = nodesToSelect
                if isa(iNode.Parent,'matlab.ui.container.TreeNode')
                    expand(iNode.Parent);
                end
            end
        end

    end
elseif listboxHandle.Tag == "listbox3"
    if isempty(listboxHandle.Items) || isempty(OrigListboxSelection)
        listboxHandle.Value = {};
    else
        listboxHandle.Value = {};
        for iOrigSelection = OrigListboxSelection
            for indexItem = 1:length(listboxHandle.Items)
                if isequal(listboxHandle.Items(indexItem),iOrigSelection)
                    listboxHandle.Value(end+1) = listboxHandle.ItemsData(indexItem);
                end
            end 
        end
    end
end


%% ------------------------------------------------- Go to Next listbox ---
if any(strcmp(CallerListboxTag,{'listbox1' 'listbox2'}))
    app.refresh(NextListboxHandle);
end


end

%% Nested function
function nodesList = getAllNodes(parentHandle, origListboxSelection)
nodesList = [];
for iChild = parentHandle.Children'
    if any(arrayfun(@(x) isequal(x,iChild.NodeData),origListboxSelection))
        nodesList = [nodesList iChild getAllNodes(iChild,origListboxSelection)];
    else
        nodesList = [nodesList getAllNodes(iChild,origListboxSelection)];
    end
end
end