function [selection, selectionName, selectionClass] = selectVariablesdlg(variableList)
%SELECTVARIABLESDLG dialog to select from a list of variables
%  
% DESCRIPTION: 
% this function open a dialog where a list of variables can be shown to the
% user and the user can select a subset of them. The list of variables to 
% be shown can be supplied as input or if the input is left empty, the 
% function 'whos' will be called in the base workspace.
% The function will return the names of the selected variables. 
%
% SYNTAX: 
%       SELECTVARIABLESDLG() 
%       SELECTVARIABLESDLG(variableList) 
%       selection = SELECTVARIABLESDLG(...) 
%       [selection, selectionClass] = SELECTVARIABLESDLG(...) 
% 
% INPUTS: 
%       - variableList: a structure array like the one returned from the
%       'whos'. If left empty the function 'whos' will be called in the
%       base workspace.
%
% OUTPUTS:
%       - selection: a structure array containing the selected variables. 
%       The structure has the same fields as the output of 'whos'. If the 
%       dialog is closed in any way other than the confirmation button an 
%       empty array is automatically returned.
%
%       - selectionName: string array that contains the names of the 
%       selected variables.
%
%       - selectionClass: a string array that contains the classes of the
%       selected variables.
%
% See also: whos.

%% Inputs
arguments
    variableList = []
end

persistent classFilterSelected nameFilterSelected


% Set the default output if the windows is closed in a different way than
% with the confirmation button
selection = [];
selectionName = [];
selectionClass = [];



%% Create dialog
dialogContainer = struct;

% Create UIFigure and hide until all components are created
dialogContainer.UIFigure = uifigure('Visible', 'off');
dialogContainer.UIFigure.Position = [100 100 483 608];
dialogContainer.UIFigure.Name = 'MATLAB dialogContainer';
dialogContainer.UIFigure.Resize = 'on';
dialogContainer.UIFigure.WindowStyle = 'modal';

% Create GridLayout
dialogContainer.GridLayout = uigridlayout(dialogContainer.UIFigure);
dialogContainer.GridLayout.ColumnWidth = {50, '1x', 80, 80};
dialogContainer.GridLayout.RowHeight = {30, '1x', 30};

% Create ToggleAll
dialogContainer.ToggleAll = uibutton(dialogContainer.GridLayout, 'push');
dialogContainer.ToggleAll.ButtonPushedFcn = @ToggleAllPushed;
dialogContainer.ToggleAll.WordWrap = 'on';
dialogContainer.ToggleAll.FontSize = 10;
dialogContainer.ToggleAll.Layout.Row = 1;
dialogContainer.ToggleAll.Layout.Column = 1;
dialogContainer.ToggleAll.Text = 'Toggle All';


% Create NameFilterDropDown
dialogContainer.NameFilterDropDown = uieditfield(dialogContainer.GridLayout);
dialogContainer.NameFilterDropDown.Value = nameFilterSelected;
dialogContainer.NameFilterDropDown.ValueChangingFcn = @filterChanged;
dialogContainer.NameFilterDropDown.FontSize = 10;
dialogContainer.NameFilterDropDown.Layout.Row = 1;
dialogContainer.NameFilterDropDown.Layout.Column = 2;

% Create ClassFilterDropDown
dialogContainer.ClassFilterDropDown = uidropdown(dialogContainer.GridLayout, "Editable","on");
dialogContainer.ClassFilterDropDown.Items = ["" "timetable" "table" "struct" "<numeric>"];
dialogContainer.ClassFilterDropDown.Value = classFilterSelected;
dialogContainer.ClassFilterDropDown.ValueChangedFcn = @filterChanged;
dialogContainer.ClassFilterDropDown.FontSize = 10;
dialogContainer.ClassFilterDropDown.Layout.Row = 1;
dialogContainer.ClassFilterDropDown.Layout.Column = [3 4];

% Create UITable
dialogContainer.UITable = uitable(dialogContainer.GridLayout);
dialogContainer.UITable.ColumnName = {'Name'; 'Class'};
dialogContainer.UITable.ColumnFormat = {'char', 'char'};
dialogContainer.UITable.ColumnWidth = {'1x', 150};
dialogContainer.UITable.RowName = {};
dialogContainer.UITable.ColumnSortable = true;
dialogContainer.UITable.SelectionType = 'row';
dialogContainer.UITable.ColumnEditable = [false false];
dialogContainer.UITable.Layout.Row = 2;
dialogContainer.UITable.Layout.Column = [1 4];
dialogContainer.UITable.RowStriping = 0;
dialogContainer.UITable.DoubleClickedFcn = @OKButtonPushed;

% Create OKButton
dialogContainer.OKButton = uibutton(dialogContainer.GridLayout, 'push');
dialogContainer.OKButton.ButtonPushedFcn = @OKButtonPushed;
dialogContainer.OKButton.Layout.Row = 3;
dialogContainer.OKButton.Layout.Column = 3;
dialogContainer.OKButton.Text = 'OK';

% Create CancelButton
dialogContainer.CancelButton = uibutton(dialogContainer.GridLayout, 'push');
dialogContainer.CancelButton.ButtonPushedFcn = @CancelButtonPushed;
dialogContainer.CancelButton.Layout.Row = 3;
dialogContainer.CancelButton.Layout.Column = 4;
dialogContainer.CancelButton.Text = 'Cancel';


% Position the GUI a the center of the screen
movegui(dialogContainer.UIFigure,"center");

% Show the figure after all components are created
dialogContainer.UIFigure.Visible = 'on';

%% Main

% if the list of variables is empty, read the variables in the
% base workspace
if isempty(variableList)
    variableList = evalin("base","whos");
end

% Create Data CellArray
Data = cell(length(variableList),2);
Data(:,1) = {variableList.name};
Data(:,2) = {variableList.class};

% Sort Data by Var names (default)
[~,perm] = sort(Data(:,1));
Data = Data(perm,:);

% Insert data into the table
dialogContainer.UITable.Data = Data;

% run the class filter function (the persistent value of filter will be
% applied)
filterChanged(dialogContainer.UIFigure);


% Wait until the window is closed and then return the output
uiwait(dialogContainer.UIFigure);


%% Callback functions (NESTED)

% Dropdown menu changed: ClassFilterDropDownChanged
    function filterChanged(hObject,eventData)

        % class
        if isempty(dialogContainer.ClassFilterDropDown.Value)
            classFilterIndex = true(size(Data(:,2)));
        elseif any(dialogContainer.ClassFilterDropDown.Value == "<numeric>")
            classFilterIndex = matches(Data(:,2),["single" "double" "int8" "int16" "int64" "int32" "uint8" "uint16" "uint64" "uint32"]);
        else
            classFilterIndex = contains(Data(:,2),dialogContainer.ClassFilterDropDown.Value);
        end
        classFilterSelected = dialogContainer.ClassFilterDropDown.Value;

        % name 
        if hObject.Type == "uieditfield"
            nameFilterValue = eventData.Value;
        else
            nameFilterValue = dialogContainer.NameFilterDropDown.Value;
        end
        nameFilterIndex = matches(Data(:,1),wildcardPattern+nameFilterValue+wildcardPattern);
        nameFilterSelected = nameFilterValue;

        % filter Data
        dialogContainer.UITable.Data = Data(classFilterIndex & nameFilterIndex,:); 

    end


% Button pushed function: ToggleAll
    function ToggleAllPushed(~, ~)
        dialogContainer.UITable.Selection = 1:numel(dialogContainer.UITable.Data(:,1));
    end

% Button pushed function: CancelButton
    function CancelButtonPushed(~, ~)
        delete(dialogContainer.UIFigure)
    end

% Button pushed function: OKButton
    function OKButtonPushed(~, ~)

        % Populate the output variables 
        indexSelected = dialogContainer.UITable.Selection;
        selectionName = string(dialogContainer.UITable.Data(indexSelected,1));
        [~,matchingIndex] = intersect({variableList.name},selectionName,"stable");
        selection = variableList(matchingIndex);
        selectionClass = string(dialogContainer.UITable.Data(indexSelected,2));

        % Close the dialog
        delete(dialogContainer.UIFigure)
    end



end

