function varargout = importFromMatlab(app,~,MatSource,varargin)
% Import data from the workspace or from a .mat file.
%
% DESCRIPTION:
%
%
%
% SYNTAX:
%   importFromMatlab(app,eventdata,MatSource)
%   importFromMatlab(app,eventdata,MatSource,'-all')
%   importFromMatlab(app,eventdata,MatSource,File,FDataName)
%   importFromMatlab(app,eventdata,MatSource,File,FDataName,'-all')
%   [Datasets, DatasetsNames] = importFromMatlab(__)
%
%
% INPUT:
%   app             kview app 
%   eventdata       unused.
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
% See also: selectVariablesdlg.


%% ---------------------------------------------------- Initialize data ---
 

% Initialize data
DatasetsName = [app.DatasetList.Name];
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
    elseif strcmp(MatVar(ii).class,'Simulink.SimulationOutput')
        ToDelete(ii) = false;
    elseif strcmp(MatVar(ii).class,{'Simulink.SimulationData.Dataset','Simulink.SimulationData.Signal'})
        ToDelete(ii) = false;
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
    [VarToImport] = selectVariablesdlg(MatVar);
end

if isempty(VarToImport)
    return
end


%% ------------------------------------------------------------- Import ---

for ii = 1:length(VarToImport)
    
    switch VarToImport(ii).class
        
        case {'logical','single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'}
            NewDatasetsNames{end+1} = matlab.lang.makeUniqueStrings(VarToImport(ii).name, [DatasetsName NewDatasetsNames]);
            NewDatasets{end+1} = array2table(MatImportFunc(VarToImport(ii).name));

        case 'struct'
            
            NewDatasetsNames{end+1} = matlab.lang.makeUniqueStrings(VarToImport(ii).name, [DatasetsName NewDatasetsNames]);
            NewDatasets{end+1} = struct2table(MatImportFunc(VarToImport(ii).name));

        case {'Simulink.SimulationData.Dataset','Simulink.SimulationData.Signal'}

            NewDatasetsNames{end+1} = matlab.lang.makeUniqueStrings(VarToImport(ii).name, [DatasetsName NewDatasetsNames]);
            NewDatasets{end+1} = extractTimetable(VarToImport(ii).name);

        case {'table','timetable'}

            NewDatasetsNames{end+1} = matlab.lang.makeUniqueStrings(VarToImport(ii).name, [DatasetsName NewDatasetsNames]);
            NewDatasets{end+1} = MatImportFunc(VarToImport(ii).name);

            
        case 'timeseries'
            NewDatasetsNames{end+1} = matlab.lang.makeUniqueStrings(VarToImport(ii).name, [DatasetsName NewDatasetsNames]);
            NewDatasets{end+1} = timeseries2timetable(MatImportFunc(VarToImport(ii).name));

        case ''
            disp('Importing process interrupted.');
            return



        otherwise
            error([VarToImport(ii).name ' class not supported.']);

    end
    

    % check if the kvGroup custom property exist and in case creates it.
    if ~isprop(NewDatasets{end},"kvGroup")
        NewDatasets{end} = addprop(NewDatasets{end},"kvGroup","table");
        NewDatasets{end}.Properties.CustomProperties.kvGroup = app.newkvGroup({}, {}, {}); % create empty kvGroup struct
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

% datasets name should be of type string and not char
NewDatasetsNames = string(NewDatasetsNames);

if nargout == 2
    varargout{1} = NewDatasets;
    varargout{2} = NewDatasetsNames;
    return 
end


%% ----------------------------------------------- Update DatasetsSruct ---

nameToAssign = arrayfun(@string,NewDatasetsNames,'UniformOutput',false);
[app.DatasetList(end+1:end+length(NewDatasetsNames)).Name] = deal(nameToAssign{:});
[app.DatasetList(end+1-length(NewDatasetsNames):end).Table] = NewDatasets{:};

set(app.GUI.listbox1,'Items',[app.DatasetList.Name]);


% Automatically select the new elements in listbox1. 
TempValueListbox1 = find(matches([app.DatasetList.Name],NewDatasetsNames));
app.GUI.listbox1.Value=app.GUI.listbox1.Items(TempValueListbox1);


app.refresh();


end

