function refresh(app, listboxHandle)
% This function is used internally to refresh the GUI listboxes.

arguments
    app
    listboxHandle handle = app.GUI.listbox1
end


%% ---------------------------------------------------- Initialize data ---
contents_listbox1 = app.GUI.listbox1.Items;
contents_listbox2 = app.GUI.listbox2.Children;
contents_listbox3 = app.GUI.listbox3.Items;
value_listbox1 = app.GUI.listbox1.ValueIndex;
value_listbox2 = app.GUI.listbox2.SelectedNodes;
value_listbox3 = app.GUI.listbox3.ValueIndex;
OrigListboxSelection = {};
CommonFieldsListbox = {};
signalListFullName = {};

CallerListboxTag = get(listboxHandle,'Tag');


%% ------------------------------------------------ Elements in listbox ---

% Create a list of all the elements that will be shown in the listbox.
%
% CommonFields is initialized with all the fields of the first selected.
% Dataset. Then in the following loop each non common element is cancelled.

switch CallerListboxTag
    
    case 'listbox1'
        
        ListboxNum = 1;
        NextListboxHandle = app.GUI.listbox2;
        
        if ~isempty(contents_listbox1)
            OrigListboxSelection = contents_listbox1(value_listbox1);
        end
        
        CommonFieldsListbox = [app.DatasetList.Name];
        
        
    case 'listbox2'
        
        ListboxNum = 2;
        NextListboxHandle = app.GUI.listbox3;   
        
        if ~isempty(contents_listbox2)
            selectedNodes = app.GUI.listbox2.SelectedNodes;
            if ~isempty(selectedNodes)
                OrigListboxSelection = [app.GUI.listbox2.SelectedNodes.NodeData];
            end
        end

        % cleare the uitree 
        allNodes = app.GUI.listbox2.Children;
        if ~isempty(allNodes); allNodes.delete; end

        if isempty(contents_listbox1)
            % do nothing
        else
          
            commonGroupList = [app.DatasetList(value_listbox1(1)).Table.Properties.CustomProperties.kvGroup];

            for iDataset = app.DatasetList(value_listbox1(2:end))
                commonGroupList = app.kvGroupComparison(commonGroupList,iDataset.Table.Properties.CustomProperties.kvGroup);
            end

            % CommonFieldsListbox = [app.DatasetList(value_listbox1(1)).Table.Properties.CustomProperties.kvGroup.Name];
            % for  iDataset = app.DatasetList(value_listbox1(2:end))
            %     CommonFieldsListbox = intersect(CommonFieldsListbox, [iDataset.Table.Properties.CustomProperties.kvGroup.Name],"stable");
            % end

            commonGroupList = [app.UtilityData.defaultGroup, commonGroupList];
            CommonFieldsListbox = [commonGroupList.Name];
            
        end
        
    case 'listbox3'
        
        ListboxNum = 3;
        if isempty(contents_listbox2)
            app.GUI.listbox3.Items = {};
        else
            
            if ~isempty(contents_listbox3)
                OrigListboxSelection = contents_listbox3(value_listbox3);
            end
            
            selDataset = app.selectedDataset;
            selGroup = app.selectedGroup;
            [signalListFullName, CommonFieldsListbox] = kview.filterByGroup(selDataset(1),selGroup(1));
            for iDataset = app.selectedDataset
                for iGroup = app.selectedGroup
                    [~, signalListShortName] = kview.filterByGroup(iDataset,iGroup);
                    [CommonFieldsListbox,~,indexOrder] = intersect(CommonFieldsListbox,signalListShortName,"stable");
                    signalListFullName = signalListFullName(indexOrder); %reacreate this list with only the needed signal in the correct order
                end
            end
        
        end
        
        
end


%% Sort/Order
  
if listboxHandle.Tag == "listbox3"
    [CommonFieldsListbox, perm] = sort(CommonFieldsListbox);  
    signalListFullName = signalListFullName(perm); 
end

%% Populate the listbox or tree
if listboxHandle.Tag == "listbox2"
    app.populateTree(listboxHandle, commonGroupList);
else
    listboxHandle.Items = CommonFieldsListbox;
    if listboxHandle.Tag == "listbox3"
        listboxHandle.ItemsData = signalListFullName;
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

else
    if isempty(CommonFieldsListbox) || isempty(OrigListboxSelection)
        listboxHandle.ValueIndex = [];
    else
        TempValueListbox = find(matches(CommonFieldsListbox,OrigListboxSelection));
        if isempty(TempValueListbox);TempValueListbox = 1; end
        listboxHandle.ValueIndex = TempValueListbox;
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