classdef kview <handle
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

    properties
        Settings                    struct
        DatasetStruct               struct 
        XAxis                       string

        % atruct containing all the handles to the GUI. The main figure
        % handle is preallocated
        GUI                         struct = struct("FigureHandle",[])
    end
    
    methods

        % main function
        function app = kview(varargin)
        
            persistent kvSingleton
            
            % if app already exist simply return it
            if ~isempty(kvSingleton) && isvalid(kvSingleton)
                app = kvSingleton;
                return
            end
            
            % if the caller was only checking on existance just return the
            % app (evn if not constructed yet)
            if nargin && any(strcmpi(varargin{1},["isopen","query","check"]))
                return
            end

            % create the default DatasetStruct
            app.DatasetStruct = struct('Name',{},'Table',{});
            
            % TODO: import settings
            app.Settings = kview.getSettings();

            % create the GUI
            app.GUI.FigureHandle = kview.createFcn(app);

            % assign the kvSingleton
            kvSingleton = app;

        end

        function delete(app)
            %DELETE the figure (will automatically delete all the children)
            delete(app.GUI.FigureHandle)
        end



    end

    methods (Static)

        out = getSettings()
        out = createFcn(app)

        function out = isOpen()
            %DELETE the figure
            app = kview("isopen");
            if ~isempty(app) && isvalid(app) && ~isempty(app.GUI.FigureHandle)
                out = app;
            else
                out = false;
            end
        end
    end
end


% 
% function varargout = kviewExport(kviewGUIHandle,varargin)
% 
% 
% % get data
% handles = guidata(kviewGUIHandle);
% DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
% contents_listbox1 = cellstr(get(handles.listbox1,'String'));
% contents_listbox2 = cellstr(get(handles.listbox2,'String'));
% contents_listbox3 = cellstr(get(handles.listbox3,'String'));
% value_listbox1 = get(handles.listbox1,'Value');
% value_listbox2 = get(handles.listbox2,'Value');
% value_listbox3 = get(handles.listbox3,'Value');
% XAxisVarName = getappdata(handles.main_GUI,'XAxisVarName');
% XAxisSubsysName = getappdata(handles.main_GUI,'XAxisSubsysName');
% 
% 
% switch lower(varargin{1})
% 
%     case 'selected'
% 
%         switch lower(varargin{2})
% 
%             case 'dataset'
%                 varargout{1} = cell(1,length(value_listbox1));
%                 for ii = 1:length(value_listbox1)
%                     varargout{1}{ii} = DatasetsStruct.(contents_listbox1{value_listbox1(ii)});
%                 end
%                 varargout{2} = contents_listbox1(value_listbox1);
% 
%             case 'subsystem'
%                 varargout{1} = {'not yet implemented'};
%                 varargout{2} = contents_listbox2(value_listbox2);
% 
%             case 'varname'
%                 varargout{1} = {'not yet implemented'};
%                 varargout{2} = contents_listbox3(value_listbox3);
% 
%             case 'all'
%                 TempCell = cell(length(value_listbox1)*length(value_listbox2)*length(value_listbox3),3);
%                 n = 1;
%                 for ii=value_listbox1
%                     for jj=value_listbox2
%                         for kk=value_listbox3
%                             TempCell(n,:) = {contents_listbox1{ii} contents_listbox2{jj} contents_listbox3{kk}};
%                             n = n + 1;
%                         end
%                     end
%                 end
%                 varargout{1} = TempCell;           
% 
% 
%         end
% 
%     case 'xaxis'
% 
%         varargout{1} = XAxisSubsysName;
%         varargout{2} = XAxisVarName;
% 
% 
%     case 'custom'
% 
%         switch lower(varargin{2})
% 
%             case 'value'
% 
%                 for ii = 1:length(varargin)-2
%                    varargout{ii} = DatasetsStruct.(varargin{ii+2}{1}).(varargin{ii+2}{2}).(varargin{ii+2}{3}).data;
%                 end
% 
%             case 'unit'
% 
%                 for ii = 1:length(varargin)-2
%                    varargout{ii} = DatasetsStruct.(varargin{ii+2}{1}).(varargin{ii+2}{2}).(varargin{ii+2}{3}).unit;
%                 end
% 
% 
%         end
% 
% end
% 
% 
% end
% 
% 
% function kviewImport(kviewGUIHandle,varargin)
% 
% 
% % get data
% handles = guidata(kviewGUIHandle);
% DatasetsStruct = getappdata(handles.main_GUI,'DatasetsStruct');
% contents_listbox1 = cellstr(get(handles.listbox1,'String'));
% contents_listbox2 = cellstr(get(handles.listbox2,'String'));
% contents_listbox3 = cellstr(get(handles.listbox3,'String'));
% value_listbox1 = get(handles.listbox1,'Value');
% value_listbox2 = get(handles.listbox2,'Value');
% value_listbox3 = get(handles.listbox3,'Value');
% 
% 
% if ~iscell(varargin{2})
%     varargin{2} = {varargin{2}};
% end
% 
% % Default settings for import
% overwrite = 0;
% NameStrings = {};
% 
% if nargin<2
%     error('In the argument you must at least specify the kind of data imported and the data content.');
% elseif nargin>2
%     for ii=1:2:(nargin-2)
% 
%         switch lower(varargin{ii})
% 
%             case 'overwrite'
%                 overwrite = varargin{ii+1}; % DEV NOTE: not yet used
% 
%             case {'namestrings', 'names'}
%                 NameStrings = varargin{ii+1};
% 
%             otherwise
%                 error(['Parameter ' varargin{ii} ' not recognized']);
% 
%         end
% 
%     end
% end
% 
% if length(NameStrings)~=length(varargin{2}) && ~isempty(NameStrings)
%     warning('The number of elements in the NameString is different from the number of elements passed as second argument. Default naming will be used.');
%     NameStrings = {};
% end
% 
% if isempty(NameStrings)
%     NameStrings = cell(1,length(varargin{2}));
%     for ii = 1:length(varargin{2})  
%         NameStrings{ii} = ['Dataset_' int2str(ii)] ; 
%     end
% end
% 
% 
% 
% switch lower(varargin{1})
% 
%     case 'dataset'
%         for ii = 1:length(varargin{2})
%             DatasetsStruct.(NameStrings{ii}) = varargin{2}{ii};
%         end
% 
% end
% 
% 
% setappdata(handles.main_GUI,'DatasetsStruct',DatasetsStruct);
% kviewRefreshListbox(handles.listbox1);
% 
% end

