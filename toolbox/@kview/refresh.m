function refresh(app, listboxHandle)
% This function is used internally to refresh the GUI listboxes.

arguments
    app
    listboxHandle handle = app.GUI.listbox1
end


%% ---------------------------------------------------- Initialize data ---
contents_listbox1 = app.GUI.listbox1.String;
contents_listbox2 = app.GUI.listbox2.String;
contents_listbox3 = app.GUI.listbox3.String;
value_listbox1 = app.GUI.listbox1.Value;
value_listbox2 = app.GUI.listbox2.Value;
value_listbox3 = app.GUI.listbox3.Value;
OrigListboxSelection = {};
CommonFieldsListbox = {};

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
        
        if isempty(contents_listbox1)
            
            set(app.GUI.listbox2,'String',{});
            
        else
            
            if ~isempty(contents_listbox2)
                OrigListboxSelection = contents_listbox2(value_listbox2);
            end
            
            commonGroupList = [app.DatasetList(value_listbox1(1)).Table.Properties.CustomProperties.kvGroup];
            for iDataset = app.DatasetList(value_listbox1(2:end))
                for iGroup = commonGroupList
                    if ~isequal(...
                            iDataset.Table.Properties.CustomProperties.kvGroup( ...
                            strcmp([iDataset.Table.Properties.CustomProperties.kvGroup.Name],iGroup.Name)),...
                            iGroup)

                        commonGroupList(strcmp(commonGroupList,iGroup.Name)) = [];
                    end
                end
            end

            % CommonFieldsListbox = [app.DatasetList(value_listbox1(1)).Table.Properties.CustomProperties.kvGroup.Name];
            % for  iDataset = app.DatasetList(value_listbox1(2:end))
            %     CommonFieldsListbox = intersect(CommonFieldsListbox, [iDataset.Table.Properties.CustomProperties.kvGroup.Name],"stable");
            % end

            CommonFieldsListbox = [app.UtilityData.defaultGroup.Name commonGroupList.Name];
            
        end
        
    case 'listbox3'
        
        ListboxNum = 3;
        if isempty(contents_listbox2)
            set(app.GUI.listbox3,'String',{});
        else
            
            if ~isempty(contents_listbox3)
                OrigListboxSelection = contents_listbox3(value_listbox3);
            end
            
            selDataset = app.selectedDataset;
            selGroup = app.selectedGroup;
            if ~isempty(selGroup); selGroup = selGroup(1); end
            [~, CommonFieldsListbox] = kview.filterByGroup(selDataset(1),selGroup);
            for iDataset = app.selectedDataset
                for iGroup = app.selectedGroup
                    [~, signalListShortName] = kview.filterByGroup(iDataset,iGroup);
                    CommonFieldsListbox = intersect(CommonFieldsListbox,signalListShortName,"stable");
                end
            end
        
        end
        
        
end


%% --------------------------------------------------------- Sort/Order ---

switch app.UtilityData.SortOrderMethod{ListboxNum}
    
    case 'original'
        % Do nothing. Use the Structure ordering: normally it is the
        % order in which the element were added to the struct.
        
    case 'ascii'
        CommonFieldsListbox = sort(CommonFieldsListbox);        
        
    case 'alphabetical'
        [~,perm] = sort(lower(CommonFieldsListbox));        
        CommonFieldsListbox = CommonFieldsListbox(perm);
        
end


% apply the selected sorting method
set(listboxHandle,'String',CommonFieldsListbox);


%% ------------------------------------------------------ Listbox Value ---

% First check if the listbox is empty, then check which elements are
% selected in listbox and if they still exist re-select them. Otherwise
% set the first element as the selected one.
if isempty(CommonFieldsListbox) || isempty(OrigListboxSelection)
    set(listboxHandle,'Value',1);
else
    TempValueListbox = find(matches(CommonFieldsListbox,OrigListboxSelection));
    if isempty(TempValueListbox);TempValueListbox = 1; end
    set(listboxHandle,'Value',TempValueListbox);
end


%% ------------------------------------------------- Go to Next listbox ---
if any(strcmp(CallerListboxTag,{'listbox1' 'listbox2'}))
    app.refresh(NextListboxHandle);
end


end