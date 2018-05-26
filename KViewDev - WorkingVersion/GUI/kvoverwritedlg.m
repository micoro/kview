function Answer = kvoverwritedlg(DatasetName)
% Create a dialog asking action form the user
%
%
% SYNTAX:
%   kvoverwritedlg(DatasetName)
%
% INPUT:
%   DatasetName    String with the name of the dataset
%
% OUTPUT:
%   Answer         Answer selected on the dialog. Can be: Yes, No, YesAll
%                  or NoAll.
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    08/05/2015
%   Author:  Michele Oro Nobili 


% DEV NOTE: in the future an option RENAME and RENAME ALL may be an
% improvement.



%% ---------------------------------------------------- Initialize Data ---

% Default output in case the X in the dialog is used
Answer = '';


%% ------------------------------------------------------ Create Dialog ---


hFig = dialog('MenuBar','none',...
    'Name','Overwrite Question',...
    'NumberTitle','off',...
    'Position',[400 400 500 110],...
    'Resize','off',...
    'Tag','main_GUI',...
    'Visible','off');
handles.(get(hFig,'Tag')) = hFig;

ScreenSize = get(0,'ScreenSize');
hFig.Position(1:2) = (ScreenSize(3:4)-hFig.Position(3:4))/2;

h = uix.VBox('Parent',hFig,'Padding',15,'Tag','VBox');
handles.(get(h,'Tag')) = h;

% --- Content of VBox
h = uix.HBox('Parent',handles.VBox,'Tag','HBox1');
handles.(get(h,'Tag')) = h;

h = uix.HBox('Parent',handles.VBox,'Tag','HBox2');
handles.(get(h,'Tag')) = h;


% --- Content of HBox1
% --- Question Icon
IconWidth=54;
IconHeight=54;

IconAxes=axes(                                   ...
        'Parent'          ,handles.HBox1              , ...
        'Units'           ,'points'                , ...
        'Position'        ,[0 0 IconHeight IconWidth]                 , ...
        'Tag'             ,'IconAxes'                ...
        );

a = load('dialogicons.mat');
IconData=a.questIconData;
a.questIconMap(256,:)=get(hFig,'Color');
IconCMap=a.questIconMap;


try
    Img=image('CData',IconData,'Parent',IconAxes);
    set(hFig, 'Colormap', IconCMap);
catch ex
    delete(hFig);
    rethrow(ex);
end

if ~isempty(get(Img,'XData')) && ~isempty(get(Img,'YData'))
    set(IconAxes          , ...
        'XLim'            ,get(Img,'XData'), ...
        'YLim'            ,get(Img,'YData')  ...
        );
end

set(IconAxes          , ...
    'Visible'         ,'off'       , ...
    'YDir'            ,'reverse'     ...
    );

% --- END: Question Icon

h = uicontrol(...
    'Parent',handles.HBox1,...
    'FontSize',9,...
    'HorizontalAlignment','left',...
    'String',{[DatasetName ' already exist.'];'Do you want to overwrite it?'},...
    'Style','text',...
    'Tag','message');
handles.(get(h,'Tag')) = h;


% --- Content of HBox2
h = uix.Empty('Parent',handles.HBox2,'Tag','Empty3');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HBox2,...
    'Callback',@AnswerYes,...
    'FontSize',10,...
    'Position',[13 300 155 32],...
    'String','Yes',...
    'Tag','yes');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HBox2,...
    'Callback',@AnswerNo,...
    'FontSize',10,...
    'Position',[13 300 155 32],...
    'String','No',...
    'Tag','No');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HBox2,...
    'Callback',@AnswerYes4All,...
    'FontSize',10,...
    'Position',[13 300 155 32],...
    'String','Yes for all',...
    'Tag','yesforall');
handles.(get(h,'Tag')) = h;

h = uicontrol(...
    'Parent',handles.HBox2,...
    'Callback',@AnswerNo4All,...
    'FontSize',10,...
    'Position',[13 300 155 32],...
    'String','No for all',...
    'Tag','noforall');
handles.(get(h,'Tag')) = h;

h = uix.Empty('Parent',handles.HBox2,'Tag','Empty4');
handles.(get(h,'Tag')) = h;


set( handles.VBox, 'Heights', [IconHeight 30], 'Spacing', 5 );
set( handles.HBox1, 'Widths', [IconWidth -1], 'Spacing', 15 );
set( handles.HBox2, 'Widths', [-1 100 100 100 100 -1], 'Spacing', 15 );

% save tha handles
guidata(hFig,handles);



%% -------------------------------------------------------- Show Dialog ---

% Show the figure and block any other action
set(hFig,'Visible','on');
drawnow;
uiwait(hFig);


%% --------------------------------------------------- Nested Functions ---

    function AnswerYes(~,~)
        Answer = 'Yes';
        delete(hFig);
    end

    function AnswerNo(~,~)
        Answer = 'No';
        delete(hFig);
    end

    function AnswerYes4All(~,~)
        Answer = 'YesAll';
        delete(hFig);
    end

    function AnswerNo4All(~,~)
        Answer = 'NoAll';
        delete(hFig);
    end


end





