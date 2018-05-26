function [VarToImport,ImportMode] = kvimportdlg(Var,kviewGUIhandle)
% dialog for the kview import from Workspace function
%
%
%
% SYNTAX:
%   [VarToImport,ImportMode] = kvimportdlg(Var,kviewGUIhandle)
%
% INPUT:
%   Var             Variables passed from another function. It's a struct 
%                   created by the 'whos' command.
%   kviewGUIhandle  handle to the kview GUI where some informations are 
%                   stored.
%
%
% OUTPUT:
%   VarToImport     Only a selection of the elements of the input (Var).
%   ImportMode      Unused at the moment.
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    08/05/2015
%   Author:  Michele Oro Nobili 


%% ---------------------------------------------------- Initialize Data ---

% get data
LastImportFromWSVarNames = getappdata(kviewGUIhandle,'LastImportFromWSVarNames');

% Default value
VarToImport = [];
ImportMode = 'auto';
SelectedCells = [];

% Create Data CellArray
Data = cell(length(Var),3);
Data(:,1) = {false};
Data(:,2) = {Var.name};
Data(:,3) = {Var.class};

% Sort Data by Var names (default)
[~,perm] = sort(Data(:,2));
Data = Data(perm,:);

% Pre-check some variable based on last import data
if ~isempty(LastImportFromWSVarNames)
    for ii = LastImportFromWSVarNames'
        Data(strcmp(Data(:,2),ii{1}),1) = {true};
    end
end
    
    
%% ------------------------------------------------------ Create Dialog ---

hFig = dialog('MenuBar','none',...
    'Name','Import from Workspace',...
    'NumberTitle','off',...
    'Position',[1 1 600 600],...
    'Resize','on',...
    'Tag','main_GUI',...
    'Visible','off');
handles.(get(hFig,'Tag')) = hFig;
    
ScreenSize = get(0,'ScreenSize');
hFig.Position(1:2) = (ScreenSize(3:4)-hFig.Position(3:4))/2;
    
h = uix.VBox('Parent',hFig,'Padding',10,'Tag','VBox');
handles.(get(h,'Tag')) = h;

    h = uix.HBox('Parent',handles.VBox,'Tag','HBox1');
    handles.(get(h,'Tag')) = h;
    
        h = uix.VBox('Parent',handles.HBox1,'Tag','VBox2');
        handles.(get(h,'Tag')) = h;
        
            h = uix.HBox('Parent',handles.VBox2,'Tag','HBox3','Spacing',5);
            handles.(get(h,'Tag')) = h;
            
                h = uix.Panel('Parent',handles.HBox3,'Tag','Panel1','Title','Check/Uncheck','Padding',2);
                handles.(get(h,'Tag')) = h;
                
                    h = uix.HButtonBox('Parent',handles.Panel1,'Tag','HButtonBox1','Spacing',5,...
                        'HorizontalAlignment','left','ButtonSize',[60 40]);
                    handles.(get(h,'Tag')) = h;
                    
                        h = uicontrol(...
                            'Parent',handles.HButtonBox1,...
                            'Callback',@CheckAll,...
                            'FontSize',10,...
                            'String','all',...
                            'Tag','ok');
                        handles.(get(h,'Tag')) = h;

                        h = uicontrol(...
                            'Parent',handles.HButtonBox1,...
                            'Callback',@CheckSelected,...
                            'FontSize',10,...
                            'String','selected',...
                            'Tag','ok');
                        handles.(get(h,'Tag')) = h;

                h = uix.Panel('Parent',handles.HBox3,'Tag','Panel2','Title','Sort by','Padding',2);
                handles.(get(h,'Tag')) = h;
                
                    h = uix.HButtonBox('Parent',handles.Panel2,'Tag','HButtonBox2','Spacing',5,...
                        'HorizontalAlignment','left','ButtonSize',[60 40]);
                    handles.(get(h,'Tag')) = h;
                    
                        h = uicontrol(...
                            'Parent',handles.HButtonBox2,...
                            'Callback',@SortByName,...
                            'FontSize',10,...
                            'String','name',...
                            'Tag','ok');
                        handles.(get(h,'Tag')) = h;

                        h = uicontrol(...
                            'Parent',handles.HButtonBox2,...
                            'Callback',@SortByClass,...
                            'FontSize',10,...
                            'String','class',...
                            'Tag','ok');
                        handles.(get(h,'Tag')) = h;
                      
                h = uix.Empty('Parent',handles.HBox3,'Tag','Empty0');
                handles.(get(h,'Tag')) = h;
    

            % Create the uitable
            h = uitable('Parent',handles.VBox2,...
                'Data', Data,... 
                'CellSelectionCallback',@CellSelection,...
                'ColumnName', {'','Name','Class'},...
                'ColumnFormat', {'logical','char','char'},...
                'ColumnEditable', [true false false],...
                'ColumnWidth',{40 250 'auto'},...
                'FontSize',10,...
                'RowName',[],...
                'RowStriping','off',...
                'Tag','table');
            handles.(get(h,'Tag')) = h;
            ListWidth = handles.table.Extent(3)+15;

        % placeholder in future I can populate this zone
        h = uix.Empty('Parent',handles.HBox1,'Tag','Empty1');
        handles.(get(h,'Tag')) = h;
            
    h = uix.HButtonBox('Parent',handles.VBox,'Tag','HButtonBox2','Spacing',10,...
                        'HorizontalAlignment','right','ButtonSize',[100 30]);
    handles.(get(h,'Tag')) = h;
            

            h = uicontrol(...
                'Parent',handles.HButtonBox2,...
                'Callback',@Ok,...
                'FontSize',10,...
                'Position',[13 300 155 32],...
                'String','OK',...
                'Tag','ok');
            handles.(get(h,'Tag')) = h;

            h = uicontrol(...
                'Parent',handles.HButtonBox2,...
                'Callback',@Cancel,...
                'FontSize',10,...
                'Position',[13 300 155 32],...
                'String','Cancel',...
                'Tag','cancel');
            handles.(get(h,'Tag')) = h;


% set heights and widths only after assigning the childrens. Also set other
% parameters.
set( handles.VBox, 'Heights',[-1 30], 'Spacing', 10 );
set( handles.HBox1, 'Widths',[ListWidth -1],'Spacing', 10 );
set( handles.VBox2, 'Heights',[45 -1], 'Spacing', 5 );
set( handles.HBox3, 'Widths',[130 130 -1]);

% DEV NOTE: this line is used only until the zone on the right side of the
% dialog is not populated.
hFig.Position(3) = ListWidth + 20;

% save tha handles
guidata(hFig,handles);

% Show the figure and block any other action
set(hFig,'Visible','on');
drawnow;

% --- BEGIN: Undocumented code
jscroll = findjobj(handles.table);
jtable = jscroll.getViewport.getComponent(0);
jtable.setRowSelectionAllowed(1);
jtable.setColumnSelectionAllowed(0);
jtable.setNonContiguousCellSelection(false);
jtablecallbacks = handle(jtable, 'CallbackProperties');
set(jtablecallbacks, 'MouseReleasedCallback', @CellSelection);
% --- END: Undocumented code

uiwait(hFig);


%% --------------------------------------------------- Nested functions ---

    
    function CheckAll(~,~)
        if all([handles.table.Data{:,1}])
            handles.table.Data(:,1) = {false};
        else
            handles.table.Data(:,1) = {true};
        end
    end
    
    function CheckSelected(~,~)
        if isempty(SelectedCells)
            return
        end
        if all([handles.table.Data{unique(SelectedCells(:,1)),1}])
            handles.table.Data(unique(SelectedCells(:,1)),1) = {false};
        else
            handles.table.Data(unique(SelectedCells(:,1)),1) = {true};
        end   
    end

    function SortByName(~,~)
        % Sort Data by Var names
        [~,perm] = sort(handles.table.Data(:,2));
        handles.table.Data = handles.table.Data(perm,:);
    end

    function SortByClass(~,~)
        % Sort Data by class names
        [~,perm] = sort(handles.table.Data(:,3));
        handles.table.Data = handles.table.Data(perm,:);     
    end


    function CellSelection(~,eventdata)
        
% %       DEV NOTE: Documented code at the moment commented.
%         SelectedCells = eventdata.Indices;
%         if all([handles.table.Data{unique(SelectedCells(:,1)),1}])
%             handles.table.Data(unique(SelectedCells(:,1)),1) = {false};
%         else
%             handles.table.Data(unique(SelectedCells(:,1)),1) = {true};
%         end 


        % --- BEGIN: Undocumented code
        rows = jtable.getSelectedRows + 1;
        if all([handles.table.Data{rows,1}]) 
            value = false;
        else
            value = true;
        end  
        for jj = (rows')
             jtable.setValueAt(value,jj-1,0);
        end
        SelectedCells = [rows ones(length(rows),1)];
        % --- END: Undocumented code
        
    end

    function Ok(~,~)
        VarToImport = Var([handles.table.Data{:,1}]);      
        setappdata(kviewGUIhandle,'LastImportFromWSVarNames',handles.table.Data([handles.table.Data{:,1}],2));
        delete(hFig);
    end

    function Cancel(~,~)
        delete(hFig);
    end


end


