function customButtons(app)
%CUSTOMPANEL 

buttonDataList = struct('text',{},'function',{},'tooltip',{});
buttonDataList(end+1) = struct('text','ver test','function',@ver,'tooltip','just testing ver');
buttonDataList(end+1) = struct('text','kk test','function','kview','tooltip','just testing ver');



app.GUI.VBox1.Heights(4) = 50;
customPanelHandle = app.GUI.CustomPanel1;
ButtonNum = 0;
ButtonYPos = 10;
ButtonXPos = 15;
     
for iButtonData = buttonDataList
    
    if isa(iButtonData.function,"function_handle")
        iButtonData.function = func2str(iButtonData.function);
    end

    ButtonNum = ButtonNum + 1;
    ButtonHandleTemp = uibutton(...
        'Parent',customPanelHandle,...
        'FontSize',app.UtilityData.FontSize,...
        'Position',[ButtonXPos ButtonYPos 120 30],...
        'Text',['Button ' num2str(ButtonNum)],...
        'Tag',['button' ButtonNum],...
        'enable','off');


    set(ButtonHandleTemp,'enable','on',...
        'Text',iButtonData.text,...
        'ButtonPushedFcn',iButtonData.function);

    set(ButtonHandleTemp,'Tooltip',iButtonData.tooltip);
   

    % Create Context Menu
    h = uicontextmenu(...
        'Parent',ancestor(customPanelHandle, 'figure'),...
        'Tag',['helpCustButtMenu' num2str(ButtonNum)]);
    handles.(get(h,'Tag')) = h;
    set(ButtonHandleTemp,'UIcontextMenu',h);
    ButtonHandleTemp.DeleteFcn = @(~,~)delete(h); % if the button is deleted then this context menu is deleted from the parent figure

    h = uimenu(...
        'Parent',handles.(['helpCustButtMenu' num2str(ButtonNum)]),...
        'Callback',@(~,~)help(iButtonData.function),...
        'Label','Help',...
        'Tag','help');
    handles.(get(h,'Tag')) = h;

    h = uimenu(...
        'Parent',handles.(['helpCustButtMenu' num2str(ButtonNum)]),...
        'Callback',@(~,~)open(iButtonData.function),...
        'Label','Open File',...
        'Tag','open_file');
    handles.(get(h,'Tag')) = h;

    ButtonXPos = ButtonXPos + 135;
end
%ButtonYPos = ButtonYPos - 55;

end

