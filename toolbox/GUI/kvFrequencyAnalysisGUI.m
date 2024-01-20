function kvFrequencyAnalysisGUI(varargin)
% kvFrequencyAnalysisGUI creates a GUI for frequency analysis. 
%
% SYNTAX:
%   kvFrequencyAnalysisGUI(CustomPanelHandle,TabNum)
%
%
% INPUT FUNCTION (OPTIONAL):
%   CustomPanelHandle   - Handle to the panel that will contains all the
%                         new controls.
%
%
% INPUT GUI:
%   Sample freq         - Sample frequency. The "auto" button will
%                         automatically calculate the sampling frequency 
%                         from the X axis.
%   Buffer              - Length of the periodogram. Must be a number or
%                         "auto". If it is auto, the same logica as pwelch
%                         function will be applied (max length to have 8 
%                         segments).
%   Window              - Select the window
%   Overlap             - periodogram overlap in %.
%   Output              - Select the type of output. Some output may
%                         disable the non relevant inputs.
%
% SEE ALSO: pwelch
%
% -------------------------------------------------------------------------
%   Date:    15/05/2017
%   Author:  Michele Oro Nobili 


if isempty(varargin)
    
    FigHandle = figure(...
        'Name','kview - Frequency Analysis',...
        'Position',[5 5 550 130],...
        'MenuBar','none',...
        'ToolBar','none');
    
    % Set GUI position in the middle of the screen
    ScreenSize = get(0,'ScreenSize');
    FigHandle.Position(1:2) = (ScreenSize(3:4)-FigHandle.Position(3:4))/2;  

    CustomPanelHandle = uipanel(...
        'Parent',FigHandle,...
        'Units','pixels',...
        'FontSize',10,...
        'Clipping','on',...
        'Position',[5 5 540 120]);
    
else
    
    CustomPanelHandle = varargin{1};
    
end


h1 = uicontrol(...
'Parent',CustomPanelHandle,...
'FontSize',10,...
'Position',[5 92 110 20],...
'String','Sample freq [Hz]:',...
'Style','text',...
'Tag','text1');
localPanelHandles.(get(h1,'Tag'))= h1;

h2 = uicontrol(...
'Parent',CustomPanelHandle,...
'Callback',{@GetSampleFreq,CustomPanelHandle},...
'FontSize',10,...
'Position',[115 92 35 20],...
'String','Auto',...
'Style','pushbutton',...
'Tag','freq_sample_auto');
localPanelHandles.(get(h2,'Tag'))= h2;

h3 = uicontrol(...
'Parent',CustomPanelHandle,...
'BackgroundColor',[1 1 1],...
'FontSize',10,...
'Position',[155 92 55 20],...
'String','auto',...
'Style','edit',...
'Tag','freq_sample_val');
localPanelHandles.(get(h3,'Tag'))= h3;

h4 = uicontrol(...
'Parent',CustomPanelHandle,...
'FontSize',10,...
'Position',[223 92 100 20],...
'String','Buffer [points]:',...
'Style','text',...
'Tag','text5');
localPanelHandles.(get(h4,'Tag'))= h4;


h5 = uicontrol(...
'Parent',CustomPanelHandle,...
'BackgroundColor',[1 1 1],...
'FontSize',10,...
'Position',[327 92 60 20],...
'String','auto',...
'Style','edit',...
'Tag','buffer_val');
localPanelHandles.(get(h5,'Tag'))= h5;


h6 = uicontrol(...
'Parent',CustomPanelHandle,...
'FontSize',10,...
'Position',[5 60 60 20],...
'String','Window:',...
'Style','text',...
'Tag','window_text');
localPanelHandles.(get(h6,'Tag'))= h6;

h7 = uicontrol(...
'Parent',CustomPanelHandle,...
'FontSize',10,...
'Position',[70 65 140 20],...
'BackgroundColor',[1 1 1],...
'String',{'Hann' 'Blackman-Harris (4-term, minimum sidelobe)' 'None (rect.)'},...
'Style','popupmenu',...
'Tag','window_menu');
localPanelHandles.(get(h7,'Tag'))= h7;


h8 = uicontrol(...
'Parent',CustomPanelHandle,...
'FontSize',10,...
'Position',[223 60 100 20],...
'String','Overlap [%]:',...
'Style','text',...
'Tag','text6');
localPanelHandles.(get(h8,'Tag'))= h8;

h9 = uicontrol(...
'Parent',CustomPanelHandle,...
'BackgroundColor',[1 1 1],...
'FontSize',10,...
'Position',[327 60 60 20],...
'String','50',...
'Style','edit',...
'Tag','overlap_val');
localPanelHandles.(get(h9,'Tag'))= h9;



h20 = uicontrol(...
'Parent',CustomPanelHandle,...
'FontSize',10,...
'Position',[5 20 60 20],...
'String','Output:',...
'Style','text',...
'Tag','output_text');
localPanelHandles.(get(h20,'Tag'))= h20;

h21 = uicontrol(...
'Parent',CustomPanelHandle,...
'FontSize',10,...
'Position',[70 25 140 20],...
'BackgroundColor',[1 1 1],...
'String',{'PSD' 'Amplitude Spectrum' 'FFT'},...
'Style','popupmenu',...
'Callback',{@OutputSelected,CustomPanelHandle},...
'Tag','output_type');
localPanelHandles.(get(h21,'Tag'))= h21;


h90 = uicontrol(...
'Parent',CustomPanelHandle,...
'Units','pixels',...
'Callback',{@FrequencyAnalysis_Action,CustomPanelHandle,1},...
'FontSize',10,...
'Position',[410 65 100 40],...
'String','Plot',...
'Tag','plotButton');
localPanelHandles.(get(h90,'Tag'))= h90;


h91 = uicontrol(...
'Parent',CustomPanelHandle,...
'Units','pixels',...
'Callback',{@FrequencyAnalysis_Action,CustomPanelHandle,3},...
'FontSize',10,...
'Position',[410 15 100 40],...
'String','Apply',...
'Tag','applyButton');
localPanelHandles.(get(h91,'Tag'))= h91;



% Create Context Menu (add to current plot)
h = uicontextmenu(...
    'Parent',getParentFigure(CustomPanelHandle),...
    'Tag','plotMenu');
localPanelHandles.(get(h,'Tag')) = h;
set(localPanelHandles.plotButton,'UIcontextMenu',h);

h = uimenu(...
    'Parent',localPanelHandles.('plotMenu'),...
    'Callback',{@FrequencyAnalysis_Action,CustomPanelHandle,2},...
    'Label','Add to Current Plot',...
    'Tag','addToCurrentPlot');
localPanelHandles.(get(h,'Tag')) = h;


% Create Context Menu (help and open code)
h = uicontextmenu(...
    'Parent',getParentFigure(CustomPanelHandle),...
    'Tag','helpMenu');
localPanelHandles.(get(h,'Tag')) = h;
set(CustomPanelHandle,'UIcontextMenu',h);


h = uimenu(...
    'Parent',localPanelHandles.('helpMenu'),...
    'Callback',@(~,~)help(mfilename('fullpath')),...
    'Label','Help',...
    'Tag','help');
localPanelHandles.(get(h,'Tag')) = h;

h = uimenu(...
    'Parent',localPanelHandles.('helpMenu'),...
    'Callback',@(~,~)open(mfilename('fullpath')),...
    'Label','Open File',...
    'Tag','open_file');
localPanelHandles.(get(h,'Tag')) = h;   


% Add a delete clause
localPanelHandles.pushbutton1.DeleteFcn = {@Panel_Delete,CustomPanelHandle};

% Save handles
setappdata(CustomPanelHandle,'localPanelHandles',localPanelHandles);

end


function fig = getParentFigure(fig)
% if the object is a figure or figure descendent, return the
% figure.  Otherwise return [].
while ~isempty(fig) && ~strcmp('figure', get(fig,'Type'))
  fig = get(fig,'Parent');
end
end


function Panel_Delete(~,~,CustomPanelHandle)
% Needed to delete the additional context menu from the main figure 
% (kview GUI)
handles = getappdata(CustomPanelHandle,'localPanelHandles');
rmappdata(CustomPanelHandle,'localPanelHandles');

if isfield(handles,'helpMenu')
    delete(handles.('helpMenu'));
end

if isfield(handles,'plotMenu')
    delete(handles.('plotMenu'));
end

end


function OutputSelected(~,~,CustomPanelHandle)
% Enable\Disable some interface objects as the output changes.

localPanelHandles = getappdata(CustomPanelHandle,'localPanelHandles');
OutputTypeContents = cellstr(get(localPanelHandles.output_type,'string'));
OutputType = OutputTypeContents{get(localPanelHandles.output_type,'value')};


if strcmp(OutputType,'FFT')
    localPanelHandles.overlap_val.Enable = 'off';
    localPanelHandles.window_menu.Enable = 'off';
    localPanelHandles.buffer_val.Enable = 'off';
else
    localPanelHandles.overlap_val.Enable = 'on';
    localPanelHandles.window_menu.Enable = 'on';
    localPanelHandles.buffer_val.Enable = 'on';
end

end


function GetSampleFreq(~,~,CustomPanelHandle)
% Set sample freq. and buffer lenght to "auto"

localPanelHandles = getappdata(CustomPanelHandle,'localPanelHandles');

localPanelHandles.freq_sample_val.String = 'auto'; 
localPanelHandles.buffer_val.String = 'auto'; 

end



function FrequencyAnalysis_Action(hObject,~,CustomPanelHandle,num)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ----------------------------------------------------- Initialization ---

% Get data from the OffsetAndGain_export GUI:
hkviewGUI = kview('handle');
kviewGUI_handles = guidata(hkviewGUI);
localPanelHandles = getappdata(CustomPanelHandle,'localPanelHandles');
BufferField = get(localPanelHandles.buffer_val,'String');
FSampleField = get(localPanelHandles.freq_sample_val,'String');
OverlapPercentVal = str2double(get(localPanelHandles.overlap_val,'String'));
WindowMenuContents = cellstr(get(localPanelHandles.window_menu,'string'));
WindowSelected = WindowMenuContents{get(localPanelHandles.window_menu,'value')};
OutputTypeContents = cellstr(get(localPanelHandles.output_type,'string'));
OutputType = OutputTypeContents{get(localPanelHandles.output_type,'value')};



% Get data from the main kview GUI:
contents_listbox1 = cellstr(get(kviewGUI_handles.listbox1,'String'));
contents_listbox2 = cellstr(get(kviewGUI_handles.listbox2,'String'));
contents_listbox3 = cellstr(get(kviewGUI_handles.listbox3,'String'));
value_listbox1 = get(kviewGUI_handles.listbox1,'Value');
value_listbox2 = get(kviewGUI_handles.listbox2,'Value');
value_listbox3 = get(kviewGUI_handles.listbox3,'Value');
DatasetsStruct = getappdata(kviewGUI_handles.main_GUI,'DatasetsStruct');
XAxisVarName = getappdata(kviewGUI_handles.main_GUI,'XAxisVarName');
XAxisSubsysName = getappdata(kviewGUI_handles.main_GUI,'XAxisSubsysName');

% Set Sample Val if not Auto
if ~strcmp(FSampleField,'auto')
    FSampleVal = str2double(FSampleField);
end

% Prepare window and overlapping points
if ~strcmp(BufferField,'auto')
    BufferVal = str2double(BufferField);
    [Window, NENBW] = kviewSignalWindow(BufferVal,WindowSelected);
    OverlapPointsVal=fix(OverlapPercentVal/100*BufferVal);
end


%% ------------------------------------------------------------- PWELCH ---

for ii = value_listbox1
    
    if strcmp(FSampleField,'auto')
        FSampleVal = 1/(DatasetsStruct.(contents_listbox1{ii}).(XAxisSubsysName).(XAxisVarName).data(2)-DatasetsStruct.(contents_listbox1{ii}).(XAxisSubsysName).(XAxisVarName).data(1));
    end
    
    if strcmp(BufferField,'auto')
        % use the same logic as the pwelch function: BufferVal is the
        % highest possible to have 8 segments.
        BufferVal = fix(length(DatasetsStruct.(contents_listbox1{ii}).(XAxisSubsysName).(XAxisVarName).data)/(8-7*(OverlapPercentVal/100)));
        [Window, NENBW] = kviewSignalWindow(BufferVal,WindowSelected);
        OverlapPointsVal=fix(OverlapPercentVal/100*BufferVal);
    end
        
    for jj = value_listbox2
        for kk = value_listbox3

            if any(strcmp(OutputType,{'PSD','Amplitude Spectrum'}))
                
                [TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data, Freq] =...
                    pwelch(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data,...
                    Window,OverlapPointsVal,[],FSampleVal);
                TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit = DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit;

                if strcmp(OutputType,'PSD')
                    TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit =...
                        ['(' TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit ')^2/Hz'];
                elseif strcmp(OutputType,'Amplitude Spectrum')
                    TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data=...
                        sqrt(TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data*NENBW*FSampleVal/BufferVal);                    
                end
                
            elseif strcmp(OutputType,'FFT')
                
                N=length(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data);
                Nfft=max(256,2^nextpow2(N)); % same logic applied by default to the pwelch function
                TempFFTVal = fft(DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data,Nfft)/N;
                TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data = abs(TempFFTVal);
                TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data = TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).data(1:1+Nfft/2);
                TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit = DatasetsStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).(contents_listbox3{kk}).unit;
                TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).([contents_listbox3{kk} '_phase']).data = angle(TempFFTVal);
                TempStruct.(contents_listbox1{ii}).(contents_listbox2{jj}).([contents_listbox3{kk} '_phase']).unit = 'rad';
                Freq = FSampleVal/2*linspace(0,1,1+Nfft/2);
                
            end
  
        end
    end
    
    TempStruct.(contents_listbox1{ii}).kviewXStandard.Freq.data = Freq;
    TempStruct.(contents_listbox1{ii}).kviewXStandard.Freq.unit = 'Hz';
    
end




%% ------------------------------------------------------ Show and Save ---

% Show or store modified values

if num < 3
    
    setappdata(kviewGUI_handles.main_GUI,'XAxisVarName','Freq');
    setappdata(kviewGUI_handles.main_GUI,'XAxisSubsysName','kviewXStandard');
    
    if num == 1
        kviewPlot(kviewGUI_handles.main_GUI,[],'NewFigure',TempStruct);
    elseif num == 2
        kviewPlot(kviewGUI_handles.main_GUI,[],'CurrentFigure',TempStruct);
    end
    
    setappdata(kviewGUI_handles.main_GUI,'XAxisVarName',XAxisVarName);
    setappdata(kviewGUI_handles.main_GUI,'XAxisSubsysName',XAxisSubsysName);
    
else
    
    for ii = fieldnames(TempStruct)'
        for jj = fieldnames(TempStruct.(ii{1}))'
            for kk = fieldnames(TempStruct.(ii{1}).(jj{1}))'
                DatasetsStruct.([ii{1} '_FREQ']).(jj{1}).(kk{1}) = TempStruct.(ii{1}).(jj{1}).(kk{1});               
            end
        end
    end
    
    setappdata(kviewGUI_handles.main_GUI,'DatasetsStruct',DatasetsStruct);
    kviewRefreshListbox(kviewGUI_handles.listbox1);
    
end





%% --------------------------------------------------- Nested Functions ---

    function [Window, NENBW] = kviewSignalWindow(N,WindowName)
        % Create a window for the signal
        % N             Number of samples of the signal
        % WindowName    Name of the window to apply
        
        n = (0:N-1)';
        
        switch WindowName
            
            case 'Hamming'
                Window = 0.54 - 0.46*cos(2*pi*n/N);
                
            case 'Hann'
                Window = 0.5 * (1 - cos(2*pi*n/N));
                
            case 'Blackman-Harris (4-term, minimum sidelobe)'
                Window = 0.35875 - 0.48829*cos(2*pi*n/N) + 0.14128*cos(4*pi*n/N) - 0.01168*cos(6*pi*n/N);
                
            case 'None (rect.)'
                Window = ones(size(n)); 
                
            otherwise                    
                error('Selected window could not be found.')
                
        end
        
        % calculate the corresponding NENBW
        S1 = sum(Window);
        S2 = sum(Window.^2);
        NENBW = N*S2/S1^2;
        
    end
end
