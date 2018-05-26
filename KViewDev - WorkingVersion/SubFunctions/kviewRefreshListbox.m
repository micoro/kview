function kviewRefreshListbox(hObject,~)
% This function is used internally to refresh the GUI listboxes.




%% ---------------------------------------------------- Initialize data ---
handles = guidata(hObject);
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
SortOrderMethod = getappdata(handles.main_GUI,'SortOrderMethod');
OrigListboxSelection = {};
CommonFieldsListbox = {};

CallerListboxTag = get(hObject,'Tag');


%% ------------------------------------------------ Elements in listbox ---

% Create a list of all the elements that will be shown in the listbox.
%
% CommonFields is initialized with all the fields of the first selected.
% Dataset. Then in the following loop each non common element is cancelled.

switch CallerListboxTag
    
    case 'listbox1'
        
        ListboxNum = 1;
        NextListboxHandle = handles.listbox2;
        
        if ~isempty(contents_listbox1)
            OrigListboxSelection = contents_listbox1(value_listbox1);
        end
        
        CommonFieldsListbox = fieldnames(DatasetsStruct);
        
        
    case 'listbox2'
        
        ListboxNum = 2;
        NextListboxHandle = handles.listbox3;   
        
        if isempty(contents_listbox1)
            
            set(handles.listbox2,'String',{});
            
        else
            
            if ~isempty(contents_listbox2)
                OrigListboxSelection = contents_listbox2(value_listbox2);
            end
            

            CommonFieldsListbox = fieldnames(DatasetsStruct.(contents_listbox1{value_listbox1(1)}));
            for jj=value_listbox1(2:end)
                DatasetTmp=fieldnames(DatasetsStruct.(contents_listbox1{jj}));
                for ii=CommonFieldsListbox.'
                    if isempty(ii)
                        continue
                    elseif ~any(strcmp(ii,DatasetTmp))
                        CommonFieldsListbox(strcmp(ii,CommonFieldsListbox)) = [];
                    end
                end
            end
            
        end
        
    case 'listbox3'
        
        ListboxNum = 3;
        if isempty(contents_listbox2)
            set(handles.listbox3,'String',{});
        else
            
            if ~isempty(contents_listbox3)
                OrigListboxSelection = contents_listbox3(value_listbox3);
            end
            
            CommonFieldsListbox = fieldnames(DatasetsStruct.(contents_listbox1{value_listbox1(1)}).(contents_listbox2{value_listbox2(1)}));
            for jj=value_listbox1
                for ii=value_listbox2
                    DatasetTmp2=fieldnames(DatasetsStruct.(contents_listbox1{jj}).(contents_listbox2{ii}));
                    for kk=CommonFieldsListbox.'
                        if isempty(kk)
                            continue
                        elseif ~any(strcmp(kk,DatasetTmp2))
                            CommonFieldsListbox(strcmp(kk,CommonFieldsListbox))=[];
                        end
                    end
                end
            end
        
        end
        
        
end


%% --------------------------------------------------------- Sort/Order ---

switch SortOrderMethod{ListboxNum}
    
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
set(hObject,'String',CommonFieldsListbox);


%% ------------------------------------------------------ Listbox Value ---

% First check if the listbox is empty, then check which elements are
% selected in listbox and if they still exist re-select them. Otherwise
% set the first element as the selected one.
if isempty(CommonFieldsListbox) || isempty(OrigListboxSelection)
    set(hObject,'Value',1);
elseif all(cellfun(@(x) any(strcmp(x,CommonFieldsListbox)),OrigListboxSelection))
    TempValueListbox = cellfun(@(x) find(strcmp(x,CommonFieldsListbox)),OrigListboxSelection);
    set(hObject,'Value',TempValueListbox);
else
    set(hObject,'Value',1);
end


%% ------------------------------------------------- Go to Next listbox ---
if any(strcmp(CallerListboxTag,{'listbox1' 'listbox2'}))
    kviewRefreshListbox(NextListboxHandle);
end


end