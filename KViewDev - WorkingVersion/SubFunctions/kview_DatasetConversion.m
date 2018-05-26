function ConvertedDatasets = kview_DatasetConversion(Datasets,varargin)
% This function is used to Convert the dataset of kview.
%
%
% SYNTAX:
%   ConvertedDatasets = kview_DatasetConversion(Datasets,'PropertyName',PropertyValue,...)
%
%
% INPUT:
%   Datasets        - is a cell containing the datasets to be converted
%                     (need to be in kview format).
%
% PROPERTY [OPTIONAL]:
%   FileName        - the name of the *.convtable file;
%   FileDir         - the directory were the conversion tables are located. 
%                     Default value is the current working directory.
%   ConvDirection   - the direction of the conversion. Accepted values are 
%                     'AtoB', 'BtoA' or 'Manual'. 
%
% OUTPUT:
%   ConvertedDataset - is a cell containing the converted datasets in the
%                      same order as the input dataset
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2015, All Rights Reserved.
%
%   Date:    05/09/2015
%   Author:  Michele Oro Nobili 




%% ----------------------------------------------------- Initialization ---

% Initialize data with default values
ConvDirection = 'Manual';
FileDir = '';
FileName = '';


% reading the inputs of the function
if isempty(varargin)
    [FileName,FileDir,FilterIndex] = uigetfile('*.convtable','Select the Conversion Table',FileDir); 
    if FilterIndex == 0; return; end;
else
    for ii = 1:2:length(varargin)     
        switch varargin{ii}         
            case 'FileName'
                FileName = varargin{ii+1};
            case 'FileDir'
                FileDir = varargin{ii+1};
            case 'ConvDirection'
                if ~any(strcmp(varargin{ii+1},{'AtoB','BtoA','Manual'}))
                    display(['ERROR: the Conversion Direction "' varargin{ii+1} '" supplied was not recognized.']);
                    return
                end
                ConvDirection = varargin{ii+1};
            otherwise
                display(['ERROR: the property ' varargin{ii} ' was not recognized.']);
                return
        end
    end
end
    

%% -------------------------------------------------------- Read KindID ---

% Open the file to read
if exist([FileDir FileName],'file')
    FileID = fopen([FileDir FileName]);
else
    error(['Conversion table: ' FileDir FileName ' was not found.']);
end

% read KindID A
ScannedLineTemp = textscan(FileID,'%s',1,'delimiter','\n','commentStyle','#','MultipleDelimsAsOne', 1);
PosInLine = 0;
[ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);

if strcmp(ScannedWordTemp{1}{1},'KindID_A')
    [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
    DataKindA = ScannedWordTemp{1}{1} ;
else
    error('Could not read the KindID_A');
end

% read KindID B
ScannedLineTemp = textscan(FileID,'%s',1,'delimiter','\n','commentStyle','#','MultipleDelimsAsOne', 1);
PosInLine = 0;
[ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);

if strcmp(ScannedWordTemp{1}{1},'KindID_B')
    [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
    DataKindB = ScannedWordTemp{1}{1} ;
else
    error('Could not read the KindID_B');
end


% read next section header
ScannedLineTemp = textscan(FileID,'%s',1,'delimiter','\n','commentStyle','#','MultipleDelimsAsOne', 1);
PosInLine = 0;
[ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
if strcmp(ScannedWordTemp{1}{1},'Section')
    Section = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
else
    warning('Didn''t find a Section header after the KindID in the conversion table. Assigning ''Variables'' value.');
    Section{1} = 'Variables';
end



%% ---------------------------------------------- Read Units Conversion ---

ScannedLineTemp = textscan(FileID,'%s',1,'delimiter','\n','commentStyle','#','MultipleDelimsAsOne', 1);

while strcmp(Section{1},'Unit') && ~feof(FileID)

    PosInLine = 0;
    % read a word
    [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
    
    switch ScannedWordTemp{1}{1}
        
        case {'time','frequency','length','velocity','acceleration','angle','angular_velocity','angular_acceleration','pression','force','torque'}
            UnitKind = ScannedWordTemp;
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            UnitConvTable.(UnitKind{1}{1}) = ScannedWordTemp{1}{1};
            
        case 'Section'
            [Section,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            
    end
    
    ScannedLineTemp = textscan(FileID,'%s',1,'delimiter','\n','commentStyle','#','MultipleDelimsAsOne', 1);
    
end




%% ------------------------------------------ Read Variables Conversion ---

% Initialize ConvTable structure
ConvTable = struct;

% Initialize counter VarNumber
VarNumber = 1;
VarNumberStr = sprintf('Var%.0f', VarNumber);


% cycle each line until end of file
while ~feof(FileID)
    PosInLine = 0;  
    
    % Create the string to be used as structure field. Using a faster
    % method instead of int2str.
    VarNumberStr = sprintf('Var%.0f', VarNumber);
    
    % read a word
    [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
    
    
    switch ScannedWordTemp{1}{1}
        
        case 'subsystem_A'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindA).Subsystem = ScannedWordTemp{1}{1};
        
        case 'subsystem_B'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindB).Subsystem = ScannedWordTemp{1}{1};
        
        case 'varname_A'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindA).VarName = ScannedWordTemp{1}{1};
        
        case 'varname_B'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindB).VarName = ScannedWordTemp{1}{1};
        
        case 'impose_unit_A'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindA).VarImposeUnit = ScannedWordTemp{1}{1};
        
        case 'impose_unit_B'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindB).VarImposeUnit = ScannedWordTemp{1}{1};
        
        case 'pref_unit_A'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindA).VarPrefUnit = ScannedWordTemp{1}{1};
        
        case 'pref_unit_B'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindB).VarPrefUnit = ScannedWordTemp{1}{1};
        
        case 'gain_AdivB'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindA).Gain = 1/str2double(ScannedWordTemp{1}{1});
            ConvTable.(VarNumberStr).(DataKindB).Gain = str2double(ScannedWordTemp{1}{1});
        
        case 'gain_BdivA'
            [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n','='},'MultipleDelimsAsOne', 1);
            ConvTable.(VarNumberStr).(DataKindA).Gain = str2double(ScannedWordTemp{1}{1});
            ConvTable.(VarNumberStr).(DataKindB).Gain = 1/str2double(ScannedWordTemp{1}{1});
        
        case '!---VariablesConversionSeparator---!'
            ConvInfoCheck();
            VarNumber = VarNumber+1;

        case {'',' '}
            % nothing happens, just skip the otherwise case.
        
        otherwise
            display(['ERROR: the word ' ScannedWordTemp{1}{1} ' was not recognized']);
            
    end
    
    ScannedLineTemp = textscan(FileID,'%s',1,'delimiter','\n','commentStyle','#','MultipleDelimsAsOne', 1);
    
end
ConvInfoCheck();
fclose(FileID);


%% ----------------------------------------------- Conversion Direction ---

        
% choose the direction of the conversio ('A to B' or 'B to A')
if strcmp(ConvDirection,'Manual')
    choice = ConvDirDialog(DataKindA,DataKindB);
    % choice = menu('Conversion choice',[DataKindA ' --> ' DataKindB],[DataKindB ' --> ' DataKindA]);
    if choice==0; return; end;
    if choice==1; ConvDirection = 'AtoB'; end;
    if choice==2; ConvDirection = 'BtoA'; end;
end
if strcmp(ConvDirection,'AtoB')
   FromDataKind = DataKindA;
   ToDataKind = DataKindB;
else
   FromDataKind = DataKindB;
   ToDataKind = DataKindA;
end


%% --------------------------------------------------------- Conversion ---

% waitbar initialization
wbarCount = [1 0]; 
wbarMax = 0;
handleWaitbar = waitbar(0, ['Dataset 1 of ' int2str(length(Datasets))]);

if exist('UnitConvTable','var')
    for ii = 1:length(Datasets)
        TempDataset = Datasets{ii};
        wbarMax = length(fieldnames(TempDataset));
        for jj = fieldnames(TempDataset).'
            for kk = fieldnames(TempDataset.(jj{1})).'
                SI_ref = unit(TempDataset.(jj{1}).(kk{1}).unit).name;

                switch SI_ref 

                    case 's'                            % time
                        if isfield(UnitConvTable,'time')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.time);
                        end
                    case '1/s'                          % frequency
                        if isfield(UnitConvTable,'frequency')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.frequency);
                        end
                    case 'm'                            % length
                        if isfield(UnitConvTable,'length')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.length);
                        end
                    case 'm/s'                          % velocity
                        if isfield(UnitConvTable,'velocity')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.velocity);
                        end
                    case 'm/s^2'                        % acceleration
                        if isfield(UnitConvTable,'acceleration')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.acceleration);
                        end
                    case 'rad'                          % angle
                        if isfield(UnitConvTable,'angle')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.angle);
                        end
                    case 'rad/s'                        % angular velocity
                        if isfield(UnitConvTable,'angular_velocity')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.angular_velocity);
                        end
                    case 'rad/s^2'                      % angular acceleration
                        if isfield(UnitConvTable,'angular_acceleration')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.angular_acceleration);
                        end
                    case 'kg/m/s^2'                     % pression
                        if isfield(UnitConvTable,'pression')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.pression);
                        end
                    case 'm*kg/s^2'                     % force
                        if isfield(UnitConvTable,'force')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.force);
                        end
                    case 'm^2*kg/s^2'                   % moment
                        if isfield(UnitConvTable,'torque')
                            TempDataset.(jj{1}).(kk{1}) = kviewConvUnit(TempDataset.(jj{1}).(kk{1}),UnitConvTable.torque);
                        end
                    case ''                             % empty/no unit
                        % pass


                end

            end 
            wbarCount(2) = wbarCount(2)+1;
            waitbar(wbarCount(2)/wbarMax);
        end
        wbarCount(2) = 0;
        wbarCount(1) = wbarCount(1)+1;
        waitbar(0, handleWaitbar, ['Dataset ' int2str(wbarCount(1)) ' of ' int2str(length(Datasets))]);
        ConvertedDatasets{ii} = TempDataset;
    end
end

% delete waitbar
delete(handleWaitbar);

% --- BEGIN: Temporary code. Need to fix the workflow
if ~exist('ConvertedDatasets','var')
    ConvertedDatasets = Datasets;
end
% --- END: Temporary code. Need to fix the workflow


for ii = 1:length(ConvertedDatasets)
    TempDataset = ConvertedDatasets{ii};
    for jj=fieldnames(ConvTable).'
        if isfield(TempDataset,ConvTable.(jj{1}).(FromDataKind).Subsystem)
            if isfield(TempDataset.(ConvTable.(jj{1}).(FromDataKind).Subsystem),ConvTable.(jj{1}).(FromDataKind).VarName)
                TempDataset.(ConvTable.(jj{1}).(ToDataKind).Subsystem).(ConvTable.(jj{1}).(ToDataKind).VarName) = TempDataset.(ConvTable.(jj{1}).(FromDataKind).Subsystem).(ConvTable.(jj{1}).(FromDataKind).VarName);
                
                % ------------------- Gain ------------------------------ %
                % if a gain field exist apply the gain
                if isfield(ConvTable.(jj{1}).(ToDataKind),'Gain')
                    TempDataset.(ConvTable.(jj{1}).(ToDataKind).Subsystem).(ConvTable.(jj{1}).(ToDataKind).VarName).data =...
                        TempDataset.(ConvTable.(jj{1}).(ToDataKind).Subsystem).(ConvTable.(jj{1}).(ToDataKind).VarName).data*...
                        ConvTable.(jj{1}).(ToDataKind).Gain;
                end
                
                
                % ------------------- Impose Unit ------------------------ %
                % if a VarImposeUnit field exist apply
                if isfield(ConvTable.(jj{1}).(ToDataKind),'VarImposeUnit')
                    TempDataset.(ConvTable.(jj{1}).(ToDataKind).Subsystem).(ConvTable.(jj{1}).(ToDataKind).VarName).unit = ConvTable.(jj{1}).(ToDataKind).VarImposeUnit;
                end
                
                
                % ------------------- Pref Unit ------------------------- %
                % if a preferred unit is written in the table attempts the
                % conversion from the initial unit
                if isfield(ConvTable.(jj{1}).(ToDataKind),'VarPrefUnit')
                    if isfield(TempDataset.(ConvTable.(jj{1}).(ToDataKind).Subsystem).(ConvTable.(jj{1}).(ToDataKind).VarName),'unit')
                        TempDataset.(ConvTable.(jj{1}).(ToDataKind).Subsystem).(ConvTable.(jj{1}).(ToDataKind).VarName) = kviewConvUnit(TempDataset.(ConvTable.(jj{1}).(ToDataKind).Subsystem).(ConvTable.(jj{1}).(ToDataKind).VarName),ConvTable.(jj{1}).(ToDataKind).VarPrefUnit);
                    else
                        display(['ERROR: during conversion of ' ConvTable.(jj{1}).(FromDataKind).VarName '; it was not possible to perform the unit conversion. That variable does not have a ''unit'' field.']);
                    end
                end
                
            end
        end
    end
    ConvertedDatasets{ii} = TempDataset;
end


%% --------------------------------------------------- Nested Functions ---


% Conversion data check 
function ConvInfoCheck()
    % The fields DataKindA and DataKindB must exist even if unused.
    % Otherwise an error arise.
    if ~isfield(ConvTable.(VarNumberStr),(DataKindA))
        ConvTable.(VarNumberStr).(DataKindA) = struct;
    end
    if ~isfield(ConvTable.(VarNumberStr),(DataKindB))
        ConvTable.(VarNumberStr).(DataKindB) = struct;
    end

    % Check if at least one subsystem has been defined.
    if ~isfield(ConvTable.(VarNumberStr).(DataKindA),'Subsystem') && ~isfield(ConvTable.(VarNumberStr).(DataKindB),'Subsystem')
        display('ERROR: in the table one conversion definition is incomplete, the subsystem name is missing.');
        return
    elseif ~isfield(ConvTable.(VarNumberStr).(DataKindA),'Subsystem')
        ConvTable.(VarNumberStr).(DataKindA).Subsystem = ConvTable.(VarNumberStr).(DataKindB).Subsystem;
    elseif ~isfield(ConvTable.(VarNumberStr).(DataKindB),'Subsystem')
        ConvTable.(VarNumberStr).(DataKindB).Subsystem = ConvTable.(VarNumberStr).(DataKindA).Subsystem;
    end

    % Check if at least one varname has been defined.
    if ~isfield(ConvTable.(VarNumberStr).(DataKindA),'VarName') && ~isfield(ConvTable.(VarNumberStr).(DataKindB),'VarName')
        display('ERROR: in the table one conversion definition is incomplete, the variable name is missing.');
        return
    elseif ~isfield(ConvTable.(VarNumberStr).(DataKindA),'VarName')
        ConvTable.(VarNumberStr).(DataKindA).VarName = ConvTable.(VarNumberStr).(DataKindB).VarName;
    elseif ~isfield(ConvTable.(VarNumberStr).(DataKindB),'VarName')
        ConvTable.(VarNumberStr).(DataKindB).VarName = ConvTable.(VarNumberStr).(DataKindA).VarName;
    end
end

end



function choice = ConvDirDialog(DataKindA,DataKindB)
    
    % default value
    choice = 0;
    
    DrawLocation = get(0,'ScreenSize')/2;
    % DrawLocation = get(0,'PointerLocation');
    d = dialog('Position',[DrawLocation(3)-85,DrawLocation(4)-37,170,75],'Name','Conversion choice'); 

    uicontrol('Parent',d,...
        'Style','pushbutton',...
        'Position',[10,5,150,30],...
        'String',[DataKindB ' --> ' DataKindA],...
        'Callback',{@AssignChoice,2});    
    
    uicontrol('Parent',d,...
        'Style','pushbutton',...
        'Position',[10,40,150,30],...
        'String',[DataKindA ' --> ' DataKindB],...
        'Callback',{@AssignChoice,1});
     
    % wait until the dialog is deleted to pass the output to the caller.
    uiwait(d);
    
    
    function AssignChoice(~,~,output)
       choice = output;        
       delete(d);
    end
    
end
