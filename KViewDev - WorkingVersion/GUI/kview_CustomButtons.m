function kview_CustomButtons(CustomPanelHandle,TabNum)
% SYNTAX:
%   kview_CustomButtons(CustomPanelHandle,TabNum)
%
%
% INPUT (OPTIONAL):
%   CustomPanelHandle   - Handle to the panel that will contains all the
%                         new controls.
%   TabNum              - A number from 1 to 3 that represent the Custom 
%                         Button number.
                         


% get custom buttons settings
handles = guidata(CustomPanelHandle);
CustButtSett = getappdata(handles.main_GUI,'CustButtSett');
if isempty(CustButtSett{TabNum,1}) || isempty(CustButtSett{TabNum,2})
    display('ERROR: the selected Custom Buttons Panel does not have a *.buttontable file associated.');
    FileName = [];
else
    FileDir = CustButtSett{TabNum,1};
    FileName = CustButtSett{TabNum,2};
end

% preallocate struct
ButtonList = struct;



%% ---------------------------------------------------------- Read File ---
% Before creating the buttons read the text setting file.
if ~isempty(FileName)

    FileID = fopen([FileDir FileName]);

    while ~feof(FileID)
        PosInLine = 0;  

        % read line and first word
        ScannedLineTemp = textscan(FileID,'%s',1,'delimiter','\n','commentStyle','#','MultipleDelimsAsOne', 1);
        [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n'},'MultipleDelimsAsOne', 1);

        switch lower(ScannedWordTemp{1}{1})
            case {'button_text' 'text'}
                [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{'\n'},'MultipleDelimsAsOne', 1);
                ButtonList.(CurrentButton).text = ScannedWordTemp{1}{1};

            case {'button_func' 'func'}
                [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n'},'MultipleDelimsAsOne', 1);
                ButtonList.(CurrentButton).func = ScannedWordTemp{1}{1};

            case 'button'
                [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{' ','\t',':',';','\n'},'MultipleDelimsAsOne', 1);
                if ~isnumeric(str2num(ScannedWordTemp{1}{1}))
                    display(['Button ' ScannedWordTemp{1}{1} ' in the file ' FileName ' is not a valid keyword.']);
                elseif str2num(ScannedWordTemp{1}{1})<1 || str2num(ScannedWordTemp{1}{1})>6
                    display(['Button ' ScannedWordTemp{1}{1} ' in the file ' FileName ' is not a valid keyword. Button numbers can go from 1 to 6.']);
                end
                CurrentButton = ['button' ScannedWordTemp{1}{1}];
                
            case {'button_tooltip' 'tooltip'}
                [ScannedWordTemp,PosInLine] = textscan(ScannedLineTemp{1}{1}(PosInLine+1:end),'%s',1,'delimiter',{'\n'},'MultipleDelimsAsOne', 1);
                ButtonList.(CurrentButton).tooltip = ScannedWordTemp{1}{1};                
                

            otherwise 
                display(['The word ' ScannedWordTemp{1}{1} ' in the file ' FileName ' was not recognized.']);

        end

    end

    fclose(FileID);

end


%% ----------------------------------------------------- Create Buttons ---
ButtonNum = 0;
ButtonYPos = 65;

for ii = 1:2
    ButtonXPos = 15;
    for jj = 1:3
        ButtonNum = ButtonNum + 1;
        ButtonHandleTemp = uicontrol(...
            'Parent',CustomPanelHandle,... 
            'FontSize',10,...
            'Position',[ButtonXPos ButtonYPos 160 45],...
            'String',['Button ' num2str(ButtonNum)],...
            'Tag',['button' ButtonNum],...
            'enable','off');

        if isfield(ButtonList,['button' num2str(ButtonNum)])
            set(ButtonHandleTemp,'enable','on',...
                'String',ButtonList.(['button' num2str(ButtonNum)]).text,...
                'Callback',ButtonList.(['button' num2str(ButtonNum)]).func);
            if isfield(ButtonList.(['button' num2str(ButtonNum)]),'tooltip')
               set(ButtonHandleTemp,'TooltipString',sprintf(ButtonList.(['button' num2str(ButtonNum)]).tooltip));
            end
            
            % Create Context Menu
            h = uicontextmenu(...
                'Parent',getParentFigure(CustomPanelHandle),...
                'Tag',['helpCustButtMenu' num2str(ButtonNum)]);
            handles.(get(h,'Tag')) = h;
            set(ButtonHandleTemp,'UIcontextMenu',h);


            h = uimenu(...
                'Parent',handles.(['helpCustButtMenu' num2str(ButtonNum)]),...
                'Callback',@(~,~)help(ButtonList.(['button' num2str(ButtonNum)]).func),...
                'Label','Help',...
                'Tag','help');
            handles.(get(h,'Tag')) = h;

            h = uimenu(...
                'Parent',handles.(['helpCustButtMenu' num2str(ButtonNum)]),...
                'Callback',@(~,~)open(ButtonList.(['button' num2str(ButtonNum)]).func),...
                'Label','Open File',...
                'Tag','open_file');
            handles.(get(h,'Tag')) = h;   
            
               
        end
        ButtonXPos = ButtonXPos + 175;
    end
    ButtonYPos = ButtonYPos - 55;
end


% Add a delete clause
ButtonHandleTemp.DeleteFcn = {@CustomButtonPanel_Delete,CustomPanelHandle};

% Save handles
setappdata(CustomPanelHandle,'handles',handles);

end


function fig = getParentFigure(fig)
% if the object is a figure or figure descendent, return the
% figure.  Otherwise return [].
while ~isempty(fig) && ~strcmp('figure', get(fig,'Type'))
  fig = get(fig,'Parent');
end
end


function CustomButtonPanel_Delete(~,~,CustomPanelHandle)
% Needed to delete the additional context menu from the main figure 
% (kview GUI)
handles = getappdata(CustomPanelHandle,'handles');
rmappdata(CustomPanelHandle,'handles');

for ii=1:6
    if isfield(handles,['helpCustButtMenu' num2str(ii)])
        delete(handles.(['helpCustButtMenu' num2str(ii)]));
    end
end

end



