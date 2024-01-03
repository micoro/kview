
function varargout = kviewImportFromMatlab(hObject,~,ConvertData,MatSource,varargin)
% Import data from the workspace or from a .mat file.
%
% DESCRIPTION:
%
%
%
% SYNTAX:
%   kviewImportFromMatlab(hObject,eventdata,ConvertData,MatSource)
%   kviewImportFromMatlab(hObject,eventdata,ConvertData,MatSource,'-all')
%   kviewImportFromMatlab(hObject,eventdata,ConvertData,MatSource,File,FDataName)
%   kviewImportFromMatlab(hObject,eventdata,ConvertData,MatSource,File,FDataName,'-all')
%   [Datasets, DatasetsNames] = kviewImportFromMatlab(__)
%
%
% INPUT:
%   hObject         handle to one object of the GUI. Any object is fine: it
%                   is needed only to retrive data from the figure.
%   eventdata       unused.
%   ConvertData     0 - no conversion
%                   1,2,3 - use the corresponding import conversion settings
%   MatSource       string variable; can be "workspace" or "file"
%
% INPUT [OPTIONAL]:
%   File            file .mat to be imported
%   FDataName       name that will be given to the dataset when importing
%                   the variables contained in the file
%   '-all'          if this optional argument is used, the selection GUI
%                   won't be shown and all the variables will be
%                   automatically imported
%
% OUTPUT [OPTIONAL]:
%   Datasets        datasets imported
%   DatasetsNames   names of the datasets 
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    13/05/2015
%   Author:  Michele Oro Nobili 


%% ---------------------------------------------------- Initialize data ---
 
% Get data
app.GUI = guidata(hObject);
contents_listbox1 = cellstr(get(app.GUI.listbox1,'String'));
DatasetsStruct = getappdata(app.GUI.main_GUI,'DatasetsStruct');
defaultXAxis = getappdata(app.GUI.main_GUI,'defaultXAxis');

% Initialize data
DatasetsName = [DatasetsStruct.Name];
choice = 'Yes';
MatDatasetTemp = struct;
NewDatasets = {};
NewDatasetsNames = {};
ImportAll = false;


if nargin > 4
    if any(strcmp(varargin,'-all'))
        ImportAll = true;
    end
end
        
    

% Check number of outputs
if nargout == 2
    varargout{1}= [];
    varargout{2}= [];
elseif nargout ~= 0
    error('wrong number of outputs.');
end


% Get Base WorkSpace variables
switch MatSource
    case 'workspace'
        MatVar = evalin('base','whos');
        MatImportFunc = @(x) evalin('base',x);
    case 'file'
        MatVar = whos('-file',varargin{1});
        MatImportFunc = @(x) getfield(load(varargin{1},x),x);
    otherwise
        error('Source string was not recognized. Accepted value are "workspace" or "file"');
end 
MatVar(strcmp({MatVar.name},'ans')) = [];

% Pass to the selection dialog only the supported classes
ToDelete = true(1,length(MatVar));
for ii = 1:length(MatVar)
    if any(strcmp(MatVar(ii).class,{'timeseries','tscollection'}))
        ToDelete(ii) = false;
    elseif strcmp(MatVar(ii).class,'struct')
        ToDelete(ii) = false;
        if iskvstruct(MatImportFunc(MatVar(ii).name))
            MatVar(ii).class = 'kvstruct';
        end      
    elseif strcmp(MatVar(ii).class,'table') || strcmp(MatVar(ii).class,'timetable')
        ToDelete(ii) = false;
    elseif any(strcmp(MatVar(ii).class,{'logical','single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'}))
        ToDelete(ii) = all(MatVar(ii).size<2); % single value/parameter
    end
end
MatVar(ToDelete) = [];


%% --------------------------------------------------- Selection dialog ---

if ImportAll
    VarToImport = MatVar;
else
    [VarToImport,ImportMode] = kvimportdlg(MatVar,app.GUI.main_GUI);
end

if isempty(VarToImport)
    return
end


%% ------------------------------------------------------------- Import ---

for ii = 1:length(VarToImport)
    
    switch VarToImport(ii).class
        
        % case {'logical','single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'}
        %     TempVar = MatImportFunc(VarToImport(ii).name);
        %     if all(size(TempVar) > 1)
        %         for jj=1:length(TempVar(1,:)) % import as column arrays
        %             MatDatasetTemp.(VarToImport(ii).name).(['value_' int2str(jj)]).data = TempVar(:,jj);
        %             MatDatasetTemp.(VarToImport(ii).name).(['value_' int2str(jj)]).unit = '';
        %         end
        %     else
        %         if size(TempVar,2) > 1
        %         	TempVar = TempVar';
        %         end
        %         MatDatasetTemp.(VarToImport(ii).name).value.data = TempVar;
        %         MatDatasetTemp.(VarToImport(ii).name).value.unit = '';
        %     end
            
        case {'kvstruct','struct'}
            
            NewDatasetsNames{end+1} = matlab.lang.makeUniqueStrings(VarToImport(ii).name, [DatasetsName NewDatasetsNames]);
            NewDatasets{end+1} = kvstruct2kvtable(MatImportFunc(VarToImport(ii).name));


        case 'table'

            NewDatasetsNames{end+1} = matlab.lang.makeUniqueStrings(VarToImport(ii).name, [DatasetsName NewDatasetsNames]);
            NewDatasets{end+1} = MatImportFunc(VarToImport(ii).name);

            
        % case 'timeseries'
        % 
        %     tsTemp = MatImportFunc(VarToImport(ii).name);
        % 
        %     % Time
        %     MatDatasetTemp.(VarToImport(ii).name).Time.data = tsTemp.Time;
        %     MatDatasetTemp.(VarToImport(ii).name).Time.unit = tsTemp.TimeInfo.Unit;
        % 
        %     % Data
        %     MatDatasetTemp.(VarToImport(ii).name).value.data = tsTemp.Data;
        %     MatDatasetTemp.(VarToImport(ii).name).value.unit = tsTemp.DataInfo.Units;
        % 
        % 
        % case 'tscollection'
        % 
        %     if any(strcmp(VarToImport(ii).name,DatasetsName))      
        %         if ~any(strcmp(choice,{'YesAll','NoAll'}))
        %             choice = kvoverwritedlg(VarToImport(ii).name);
        %         end
        %     else 
        %         choice = 'Yes';
        %     end
        % 
        %     switch choice
        % 
        %         case {'No','NoAll'}
        %             continue
        % 
        %         case {'Yes','YesAll'} 
        %             tscTemp = MatImportFunc(VarToImport(ii).name);
        %             tscDatasetTemp = struct;
        % 
        %             % Time
        %             tscDatasetTemp.Time.Time.data = tscTemp.Time;
        %             tscDatasetTemp.Time.Time.unit = tscTemp.TimeInfo.Units;
        % 
        %             if ~isempty(defaultXAxis{2})
        %                 tscDatasetTemp.(defaultXAxis{2}).Time.data = tscTemp.Time;
        %                 tscDatasetTemp.(defaultXAxis{2}).Time.unit = tscTemp.TimeInfo.Units;
        %             end
        % 
        % 
        %             % Data
        %             for jj = fieldnames(get(tscTemp))'
        %                 if isa(tscTemp.(jj{1}),'timeseries')
        %                     tscDatasetTemp.(jj{1}).value.data = tscTemp.(jj{1}).Data;
        %                     tscDatasetTemp.(jj{1}).value.unit = tscTemp.(jj{1}).DataInfo.Units;
        %                 end   
        %             end
        % 
        % 
        %             % Add dataset to the cell array for import
        %             NewDatasetsNames{end+1} = VarToImport(ii).name;
        %             NewDatasets{end+1} = tscDatasetTemp;

        case ''
            disp('Importing process interrupted.');
            return



        otherwise
            error([VarToImport(ii).name ' class not supported.']);

    end
    
    % check if the kvGroup custom property exist and in case creates it.
    if ~isprop(NewDatasets{end},"kvGroup")
        NewDatasets{end} = addprop(NewDatasets{end},"kvGroup","table");
        NewDatasetsNames{end}.Properties.CustomProperties.kvGroup = struct("Name", {}, "Type", {}, "Content", {});
    end

end
    
    
if ~isempty(fieldnames(MatDatasetTemp))
    if strcmp(MatSource,'workspace')
        NewDatasetsNames{end+1} = matlab.lang.makeUniqueStrings('workspace_1', [DatasetsName NewDatasetsNames]);
    else
        NewDatasetsNames{end+1} = varargin{2};
    end
    NewDatasets{end+1} = MatDatasetTemp;
end

if nargout == 2
    varargout{1} = NewDatasets;
    varargout{2} = NewDatasetsNames;
    return 
end

%% --------------------------------------------------------- Conversion ---

if ConvertData ~= 0     
    % get data
    ImpConvSett = getappdata(app.GUI.main_GUI,'ImpWSConvSett');
        
    for ii = 1:length(ImpConvSett{ConvertData}(:,1))
        
        if ~isempty(ImpConvSett{ConvertData}{ii,1})
            ConvTableDir = ImpConvSett{ConvertData}{ii,1};
            ConvTableName = ImpConvSett{ConvertData}{ii,2};
            ConvDirection = ImpConvSett{ConvertData}{ii,3};
            
            % Do the conversion
            NewDatasets = kview_DatasetConversion(NewDatasets,'FileName',ConvTableName,'FileDir',ConvTableDir,'ConvDirection',ConvDirection);
            
        end
        
    end
            
end


%% ----------------------------------------------- Update DatasetsSruct ---

[DatasetsStruct(end+1:end+length(NewDatasetsNames)).Name] = NewDatasetsNames{:};
[DatasetsStruct(end+1-length(NewDatasetsNames):end).Table] = NewDatasets{:};

set(app.GUI.listbox1,'String',[DatasetsStruct.Name]);


% Automatically select the new elements in listbox1. 
TempValueListbox1 = cellfun(@(x) find(strcmp(x,[DatasetsStruct.Name])),NewDatasetsNames);
set(app.GUI.listbox1,'Value',TempValueListbox1);


% Update shared data
setappdata(app.GUI.main_GUI,'DatasetsStruct',DatasetsStruct);

app.refresh();


end

