function export2excel(hObject,~)
% Write selected variables into an excel file.
%
%
% SYNTAX:
%   kvEportToExcel(hObject,eventdata)
%
% INPUT:
%   hObject        handle to one object of the GUI. Any object is fine: it
%                  is needed only to retrive data from the figure.
%   eventdata      unused.


%% ---------------------------------------------------- Initialize data ---

app.GUI = guidata(hObject);

contents_listbox1 = cellstr(get(app.GUI.listbox1,'String'));
contents_listbox2 = cellstr(get(app.GUI.listbox2,'String'));
contents_listbox3 = cellstr(get(app.GUI.listbox3,'String'));
value_listbox1 = get(app.GUI.listbox1,'Value');
value_listbox2 = get(app.GUI.listbox2,'Value');
value_listbox3 = get(app.GUI.listbox3,'Value');
DatasetsStruct = getappdata(app.GUI.main_GUI,'DatasetsStruct');


% Check if one of the fields is empty
if isempty(contents_listbox1)
    disp('ERROR: the datasets list is empty.');
    return
elseif isempty(contents_listbox2)
    disp('ERROR: the subsystems list is empty.');
    return
elseif isempty(contents_listbox3)
    disp('ERROR: the variables list is empty.');
    return
end


%% -------------------------------------------------------- Write Excel ---

% Choose path and name of the file.
[FileName,PathName,FilterIndex] = uiputfile('*.xls');
if FilterIndex == 0
    return
end

step = 0;
hwb = waitbar(0,['Dataset ' int2str(step) '/' int2str(length(value_listbox1))]);


for ii=value_listbox1
    
    % pre-allocating cells
    variable_names=cell(1,length(value_listbox2));
    variable_units=cell(1,length(value_listbox2));
    variable_matrix=NaN(length(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{value_listbox2(1)}).(contents_listbox3{value_listbox3(1)}).data),length(value_listbox3));

    % cycle trought all selected variables and subsystems to take the
    % needed informations
    count=0;
    for jj=value_listbox2
        for kk = value_listbox3
            count=count+1;
            variable_names{count}= [contents_listbox2{jj} '.' contents_listbox3{kk}];
            
            % Check if the field "unit" exist and in case use it.
            if isfield(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}),'unit');
                variable_units{count}= DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit;
            else
                variable_units{count}= '';
            end
            
            variable_matrix(:,count)= DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data;
        end
    end
    
    % Max length is 31 character. Following characters are cut out.
    if length(contents_listbox1{ii})>31  
        SheetName = contents_listbox1{ii}(1:31); 
        disp(['WARNING: ' contents_listbox1{ii} ' dataset name was too long: excel sheet names accept only 31 character. The name was cut.']);
    else
        SheetName = contents_listbox1{ii};
    end
    
    % Write excel sheet.
    xlswrite(fullfile(PathName,FileName),variable_names,SheetName);
    xlswrite(fullfile(PathName,FileName),variable_units,SheetName,'A2');
    xlswrite(fullfile(PathName,FileName),variable_matrix,SheetName,'A4');
    
    step = step + 1;
    waitbar(step/length(value_listbox1),hwb,['Dataset ' int2str(step) '/' int2str(length(value_listbox1))]);
    
end

close(hwb);
display(['File ' FileName ' done.']);

end
