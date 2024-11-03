function customButtons(app)
%CUSTOMPANEL 

buttonDataTable = app.Settings.CustomButtonTable;


app.GUI.VBox1.Heights(3) = 50;
customPanelHandle = uix.HButtonBox('Parent',app.GUI.CustomPanel1,'Spacing',10,'ButtonSize',[120 30]);
ButtonNum = 0;
ButtonYPos = 10;
ButtonXPos = 10;
     
for iButtonDataIndex = 1:height(buttonDataTable)
    
    if isa(buttonDataTable(iButtonDataIndex,:).Function,"function_handle")
        buttonDataTable(iButtonDataIndex,:).Function = func2str(buttonDataTable(iButtonDataIndex,:).Function);
    end

    ButtonNum = ButtonNum + 1;
    ButtonHandleTemp = uibutton(...
        'Parent',customPanelHandle,...
        'FontSize',app.UtilityData.FontSize,...        'Position',[ButtonXPos ButtonYPos 120 30],...
        'Text',['Button ' num2str(ButtonNum)],...
        'Tag',['button' ButtonNum],...
        'enable','off');


    set(ButtonHandleTemp,'enable','on',...
        'Text',buttonDataTable(iButtonDataIndex,:).Text,...
        'ButtonPushedFcn',buttonDataTable(iButtonDataIndex,:).Function);

    set(ButtonHandleTemp,'Tooltip',buttonDataTable(iButtonDataIndex,:).Tooltip);
   

    % Create Context Menu
    h = uicontextmenu(...
        'Parent',ancestor(customPanelHandle, 'figure'),...
        'Tag',['helpCustButtMenu' num2str(ButtonNum)]);
    handles.(get(h,'Tag')) = h;
    set(ButtonHandleTemp,'UIcontextMenu',h);
    ButtonHandleTemp.DeleteFcn = @(~,~)delete(h); % if the button is deleted then this context menu is deleted from the parent figure

    h = uimenu(...
        'Parent',handles.(['helpCustButtMenu' num2str(ButtonNum)]),...
        'Callback',@(~,~)help(buttonDataTable(iButtonDataIndex,:).Function),...
        'Label','Help',...
        'Tag','help');
    handles.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',handles.(['helpCustButtMenu' num2str(ButtonNum)]),...
        'Callback',@(~,~)open(buttonDataTable(iButtonDataIndex,:).Function),...
        'Label','Open File',...
        'Tag','open_file');
    handles.(get(h,'Tag')) = h;

    ButtonXPos = ButtonXPos + 130;
end
%ButtonYPos = ButtonYPos - 55;

end

