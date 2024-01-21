function importFromFile(app,ConvertData)
% kview function to import data from files.
%
% SYNTAX:
%   kviewImportFile(hObject,eventdata,CovertData)
%
% INPUT:
%   hObject        handle to one object of the GUI. Any object is fine: it
%                  is needed only to retrive data from the figure.
%   eventdata      unused.
%   ConvertData    0 - no conversion
%                  1,2,3 - use the corresponding import conversion settings
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    08/05/2015
%   Author:  Michele Oro Nobili 



%% ---------------------------------------------------- Initialize data ---

% Get data
Dir = app.UtilityData.FileImportDir;

% Initialize data
choice = 'Yes';
DatasetsName = {app.DatasetList.Name};
ImportedFileName = {};


% Create cell array for file filtering
ExtFiltering =  {'*.mat','Accepted formats';...
    '*.mat','Matlab file'};

for ii = 1:size(app.kvSettings.UserDefExt,1)
    ExtFiltering{1,1} = [ExtFiltering{1,1} ';*.' app.kvSettings.UserDefExt{ii,1}];
    ExtFiltering(ii+1,:) = {['*.' app.kvSettings.UserDefExt{ii,1}] app.kvSettings.UserDefExt{ii,2}};
end

ExtFiltering(end+1,:) = {'*','All type of file'};



%% -------------------------------------------------------- Import data ---

% Begin body
[FileNameFull,Dir,FilterIndex] = uigetfile(ExtFiltering,...
    'Select file to load:',Dir,'Multiselect','on');
if FilterIndex == 0
    return
end

% Update remembered ImportFile directory
setappdata(app.GUI.main_GUI,'FileImportDir',Dir);


if ~iscell(FileNameFull)
    FileNameFull = {FileNameFull};
end


for ii=1:length(FileNameFull)

    [~,FileName,FileExtension] = fileparts(FileNameFull{ii});
    FileExtension = FileExtension(2:end);
    corrected_FileName = matlab.lang.makeValidName(FileName);
    if length(corrected_FileName)>63
        corrected_FileName = corrected_FileName(1:63);
        disp(['WARNING: file name ' FileName ' was over matlab name limit (63 characters) and has been truncated.']);
    end
    
    if ~any(strcmpi({'mat'},FileExtension)) && ~any(strcmpi(app.kvSettings.UserDefExt(:,1),FileExtension))
        display(['ERROR: extension ''' FileExtension ''' of the file ' FileNameFull{ii} ' was not recognized.']);
        return
    end

    % ------- OVERWRITE OR NOT SECTION --------------------%

    if any(strcmp(corrected_FileName,DatasetsName)) 
        
        if ~any(strcmp(choice,{'YesAll','NoAll'}))
            choice = kvoverwritedlg(corrected_FileName);
        end
    
        switch choice

            case {'No','NoAll'}
                continue

            case {'Yes','YesAll'}
                % pass

            case ''
                disp('Importing process interrupted.');
                return

        end
    
    end
        
    ImportedFileName{end+1} = corrected_FileName; %#ok<AGROW>

    % -----------------------------------------------------%



    % ------- EXTENSION IMPORT FUNC -----------------------%

    switch lower(FileExtension)

        case 'mat'
            [out1, out2] = kviewImportFromMatlab(hObject,[],0,'file',fullfile(Dir,FileNameFull{ii}),corrected_FileName);

            if ~isempty(out2)
                for jj = 1:length(out2)
                    app.DatasetList.(out2{jj}) = out1{jj};
                end
                ImportedFileName(end:end+max(length(out2),1)-1) = out2;
            else
                ImportedFileName(end) = [];
            end
            
        otherwise
            ReadFileFunc = str2func(app.kvSettings.UserDefExt{strcmpi(app.kvSettings.UserDefExt(:,1),FileExtension),3});
            app.DatasetList.(corrected_FileName) = ReadFileFunc(fullfile(Dir,FileNameFull{ii}));

    end

    % -----------------------------------------------------%

end
    


%% --------------------------------------------------------- Conversion ---

if ConvertData ~= 0
    % get data
    ImpConvSett = getappdata(app.GUI.main_GUI,'ImpFileConvSett');
    
    % Initialize data
    DatasetsToConvert = cell(1,length(ImportedFileName));
    
    disp('Starting conversion process...');
    
    for ii = 1:length(ImpConvSett{ConvertData}(:,1))
             
        if ~isempty(ImpConvSett{ConvertData}{ii,1})
            ConvTableDir = ImpConvSett{ConvertData}{ii,1};
            ConvTableName = ImpConvSett{ConvertData}{ii,2};
            ConvDirection = ImpConvSett{ConvertData}{ii,3};
            
            % Group all the Datasets that will be converted
            for jj = 1:length(ImportedFileName)
                DatasetsToConvert{jj} = app.DatasetList.(ImportedFileName{jj});
            end
            
            % Do the conversion (use external function)
            DatasetsConverted = kview_DatasetConversion(DatasetsToConvert,'FileName',ConvTableName,'FileDir',ConvTableDir,'ConvDirection',ConvDirection);
            
            % Re-insert all the converted Datasets to the main app.DatasetList
            for jj = 1:length(ImportedFileName)
                app.DatasetList.(ImportedFileName{jj}) = DatasetsConverted{jj};
            end
        end
    
    end
    
    disp('Conversion process completed.');
     
end            


%% ------------------------------------------------------------- Ending ---


set(app.GUI.listbox1,'String',fieldnames(app.DatasetList));


% Automatically select the new elements in listbox1. 
TempValueListbox1 = cellfun(@(x) find(strcmp(x,fieldnames(app.DatasetList))),ImportedFileName);
set(app.GUI.listbox1,'Value',TempValueListbox1);


% Update shared data
kviewRefreshListbox(app.GUI.listbox1);

end