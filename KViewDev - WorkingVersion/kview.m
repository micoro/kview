function varargout = kview(varargin)
% KVIEW is the main function for the kview.
% 
% Full help: <a href="matlab:open(fullfile(fileparts(which('kview.m')),'html','mainpage.html'))">kview help page</a>
% 
% SYNTAX:
%
% INPUTS:
%
% OUTPUTS:
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    12/10/2016
%   Author:  Michele Oro Nobili 



% Create the GUI if needed
kviewGUIHandle = kview_CreateFcn(varargin{:});


% If a arguments were passed select which function will handle them.
if nargin>0
    if ischar(varargin{1})
        switch lower(varargin{1})
            
            case 'handle'
                varargout{1} = kviewGUIHandle;
                
            case 'export'
                % pass data outside kview
                [varargout{1:nargout}] = kviewExport(kviewGUIHandle,varargin{2:nargin});
                
            case 'import'
                % import data into kview
                kviewImport(kviewGUIHandle,varargin{2:nargin});
                
            case 'control'
                % some useful control over kview (like the unit change)
                
            case 'function'
                % with this you can access any other function contained in
                % the kview Function files. Not for normal use, but it may
                % be useful?
                
                funlist = kview_CreateFcn('functionhandles');
                if nargin>1
                    for ii = funlist'
                        if strcmp(func2str(ii{1}),varargin{2});
                            [varargout{1:nargout}] = feval(ii{1},varargin{3:nargin});
                        end
                    end
                else
                    varargout{1} = funlist;
                end
                                
                
            case {'isopen','query'}
                if ishandle(kviewGUIHandle)
                    varargout{1} = true;
                else
                    varargout{1} = false;
                end
                
            otherwise
                display(['ERROR: the keyword ''' varargin{1} ''' was not recognized']);
                return
                
        end
        
    end
end


end




function varargout = kviewExport(kviewGUIHandle,varargin)


% get data
handles = guidata(kviewGUIHandle);
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');
XAxisVarName = getappdata(handles.main_GUI,'XAxisVarName');
XAxisSubsysName = getappdata(handles.main_GUI,'XAxisSubsysName');


switch lower(varargin{1})
    
    case 'selected'
        
        switch lower(varargin{2})
            
            case 'dataset'
                varargout{1} = cell(1,length(value_listbox1));
                for ii = 1:length(value_listbox1)
                    varargout{1}{ii} = DatasetsStruct.(contents_listbox1{value_listbox1(ii)});
                end
                varargout{2} = contents_listbox1(value_listbox1);
                
            case 'subsystem'
                varargout{1} = {'not yet implemented'};
                varargout{2} = contents_listbox2(value_listbox2);
        
            case 'varname'
                varargout{1} = {'not yet implemented'};
                varargout{2} = contents_listbox3(value_listbox3);
                
            case 'all'
                TempCell = cell(length(value_listbox1)*length(value_listbox2)*length(value_listbox3),3);
                n = 1;
                for ii=value_listbox1
                    for jj=value_listbox2
                        for kk=value_listbox3
                            TempCell(n,:) = {contents_listbox1{ii} contents_listbox2{jj} contents_listbox3{kk}};
                            n = n + 1;
                        end
                    end
                end
                varargout{1} = TempCell;           
            
            
        end
        
    case 'xaxis'
        
        varargout{1} = XAxisSubsysName;
        varargout{2} = XAxisVarName;
        

    case 'custom'
    
        switch lower(varargin{2})
            
            case 'value'
                
                for ii = 1:length(varargin)-2
                   varargout{ii} = DatasetsStruct.(varargin{ii+2}{1}).(varargin{ii+2}{2}).(varargin{ii+2}{3}).data;
                end
            
            case 'unit'
                
                for ii = 1:length(varargin)-2
                   varargout{ii} = DatasetsStruct.(varargin{ii+2}{1}).(varargin{ii+2}{2}).(varargin{ii+2}{3}).unit;
                end
            
            
        end
    
end


end


function kviewImport(kviewGUIHandle,varargin)


% get data
handles = guidata(kviewGUIHandle);
DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
contents_listbox1 = cellstr(get(handles.listbox1,'String'));
contents_listbox2 = cellstr(get(handles.listbox2,'String'));
contents_listbox3 = cellstr(get(handles.listbox3,'String'));
value_listbox1 = get(handles.listbox1,'Value');
value_listbox2 = get(handles.listbox2,'Value');
value_listbox3 = get(handles.listbox3,'Value');


if ~iscell(varargin{2})
    varargin{2} = {varargin{2}};
end

% Default settings for import
overwrite = 0;
NameStrings = {};

if nargin<2
    error('In the argument you must at least specify the kind of data imported and the data content.');
elseif nargin>2
    for ii=1:2:(nargin-2)
        
        switch lower(varargin{ii})
            
            case 'overwrite'
                overwrite = varargin{ii+1}; % DEV NOTE: not yet used
                
            case {'namestrings', 'names'}
                NameStrings = varargin{ii+1};
                
            otherwise
                error(['Parameter ' varargin{ii} ' not recognized']);
                
        end
        
    end
end

if length(NameStrings)~=length(varargin{2}) && ~isempty(NameStrings)
    warning('The number of elements in the NameString is different from the number of elements passed as second argument. Default naming will be used.');
    NameStrings = {};
end

if isempty(NameStrings)
    NameStrings = cell(1,length(varargin{2}));
    for ii = 1:length(varargin{2})  
        NameStrings{ii} = ['Dataset_' int2str(ii)] ; 
    end
end



switch lower(varargin{1})
    
    case 'dataset'
        for ii = 1:length(varargin{2})
            DatasetsStruct.(NameStrings{ii}) = varargin{2}{ii};
        end
    
end


setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);
kviewRefreshListbox(handles.listbox1);

end

