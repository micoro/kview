function importFromMatlab(app)
% IMPORTFROMMATLAB import data from the workspace 
%
% DESCRIPTION:
%   
%
%
% SYNTAX:
%   IMPORTFROMMATLAB(app)
%
%
% INPUT:
%   app: kview object 
%
% See also: kview.addDataset, selectVariablesdlg.


%% ---------------------------------------------------- Initialize data ---
     
% Get Base WorkSpace variables
matVar = evalin('base','whos');
matImportFunc = @(x) evalin('base',x);
matVar(strcmp({matVar.name},'ans')) = []; % the 'ans' variable is ignored by default

% list of supported classes:
supportedClasses = {'table','timetable','timeseries','tscollection','struct',...
    'Simulink.SimulationOutput','Simulink.SimulationData.Dataset','Simulink.SimulationData.Signal',...
    'logical','single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'};

% Pass to the selection dialog only the supported classes
supportedVarList = false(1,length(matVar));
for ii = 1:length(matVar)
    if any(strcmp(matVar(ii).class,supportedClasses))
        supportedVarList(ii) = true;
    % elseif any(strcmp(matVar(ii).class,{'logical','single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'}))
    %     ToDelete(ii) = all(matVar(ii).size<2); % single value/parameter
    end
end
matVar = matVar(supportedVarList);


%%  Import Selection dialog 

[VarToImport] = selectVariablesdlg(matVar);


if isempty(VarToImport)
    return
end


%% Import 

for ii = 1:length(VarToImport)
    
    switch VarToImport(ii).class
        
        case {'logical','single','double','int8','uint8','int16','uint16','int32','uint32','int64','uint64'}
            tableToImport = array2table(matImportFunc(VarToImport(ii).name));

        case 'struct'
            tableToImport = struct2table(matImportFunc(VarToImport(ii).name));

        case {'Simulink.SimulationData.Dataset','Simulink.SimulationData.Signal'}
            tableToImport = extractTimetable(matImportFunc(VarToImport(ii).name));

        case {'table','timetable'}
            tableToImport = matImportFunc(VarToImport(ii).name);

        case 'timeseries'
            tableToImport = timeseries2timetable(matImportFunc(VarToImport(ii).name));

        case ''
            disp('Importing process interrupted.');
            return

        otherwise
            error([VarToImport(ii).name ' class not supported.']);

    end
    
    app.addDataset(tableToImport,VarToImport(ii).name,'refreshFlag',false);

end
   
% refresh the GUI
app.refresh();


end

