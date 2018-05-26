function Out = kvunitseldlg(UnitList,varargin)
% creates a dialog to choose the units from a string cell array
%
% SYNTAX:
%   Choice = UnitSelectionDialog(UnitList)
%   Choice = UnitSelectionDialog(UnitList,OriginalUnit)
%
% DESCRIPTION:
% The function creates a dialog with one button for each element of
% UnitList and return the order number of the button pressed. If the cancel
% button is pressed the function returns 0.
%
%
% INPUT:
%   UnitList        string cell array with the names of the units.
%
% INPUT [OPTIONAL]:
%   OiginalUnit     string containing the original unit (will be displayed      
%                   as text on the GUI).
%
% OUTPUT:
%   Choice          number of the unit selected. If the cancel (X) button 
%                   is pressed the output value is 0.
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    15/05/2015
%   Author:  Michele Oro Nobili 


%% ---------------------------------------------------- Initialize data ---

% defualt output if cancel is selectd
Out = 0;


%% ------------------------------------------------------------- Dialog ---

hFig = dialog('MenuBar','none',...
    'Name','Unit Selection',...
    'NumberTitle','off',...
    'Position',[1 1 540 50],...
    'Resize','off',...
    'Visible','on');

    hVBox = uix.VBox('Parent',hFig,'Padding',10,'Tag','VBox','Spacing',5);

        hText = uicontrol('Parent',hVBox,...
            'FontSize',10,...
            'FontWeight','bold',...
            'Style','text',...
            'String','Unit selection Menu');

% Optional text with the original unit to be converted        
if nargin == 2
    
    if isempty(varargin{1})
        varargin{1} = 'no unit';
    end
        
        hHBox = uix.HBox('Parent',hVBox,'Tag','HBox');
            uicontrol('Parent',hHBox,...
                'FontSize',10,...
                'HorizontalAlignment','right',...
                'Style','text',...
                'String','Original unit: ');  
            uicontrol('Parent',hHBox,...
                'FontSize',10,...
                'FontWeight','bold',...
                'HorizontalAlignment','left',...
                'Style','text',...
                'String',varargin{1});  
            hHBox.Widths = [100 -1];
        hFig.Position(4) = hFig.Position(4) + 30;
        hVBox.Heights(2) = 30;
        
elseif nargin ~= 1
    disp(['ERROR: wrong number of input to the "' mfilename '" function.']);
    delete(hFig);
    return
end


ButtonCount = 5; % start at 5 to create the first HButtonBox in the loop.
RowCount = 0;
for ii = 1:length(UnitList)  

    if ButtonCount == 5
        ButtonCount = 0;
        RowCount = RowCount + 1;

         hHButtonBox = uix.HButtonBox('Parent',hVBox,...
            'Tag','HButtonBox',...
            'Spacing',5,...
            'HorizontalAlignment','center',...
            'ButtonSize',[100 40]);

    end

    ButtonCount =  ButtonCount + 1;
    uicontrol(...
        'Parent',hHButtonBox,...
        'Callback',{@UnitSelection,ii},...
        'FontSize',10,...
        'String',UnitList{ii});
end

% Change height of the GUI depending on the number of elements it contains
hVBox.Heights(end-RowCount+1:end) = 40;
hFig.Position(4) = hFig.Position(4) + RowCount * (5 + 40);

% Position the GUI
ScreenSize = get(0,'ScreenSize');
hFig.Position(1:2) = (ScreenSize(3:4)-hFig.Position(3:4))/2;

% Show the figure and block any other action
set(hFig,'Visible','on');
drawnow;
uiwait(hFig);


%% --------------------------------------------------- Nested funtcions --- 

function UnitSelection(~,~,ButtonNum)
    Out = ButtonNum;
    delete(hFig);
end


end