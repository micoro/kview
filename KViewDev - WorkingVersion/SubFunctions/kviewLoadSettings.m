function kviewLoadSettings(kviewGUIhandle)
% loads the settings data of the Kview and/or creates the settings file.
%
%
% SYNTAX:
%   kviewLoadSettings
%   kviewLoadSettings(kviewGUIhandle)
%
%
% DESCRIPTION:
% If the function is called with no inputs it checks if a file named
% kviewSettings.mat is on the path and if not creates it in the same fodler
% as the kview.m file.
% If the function is called with the kview GUI handle as input it loads the
% settings. NOTE: this option is intended for internal use only.
%
%
% INPUT [OPTIONAL]:
%   kviewGUIhandle      handle of the kview GUI.
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    08/05/2015
%   Author:  Michele Oro Nobili 


if ~exist('kviewSettings.mat','file')
	CreatekviewSettings;
end

if nargin == 0
    return
end

load('kviewSettings.mat');

% Conversion Settings
if ~isappdata(kviewGUIhandle,'ImpFileConvSett')
    setappdata(kviewGUIhandle,'ImpFileConvSett',ImpFileConvSett);
end
if ~isappdata(kviewGUIhandle,'ImpWSConvSett')
    setappdata(kviewGUIhandle,'ImpWSConvSett',ImpWSConvSett);
end

% Custom Buttons Settings
if ~isappdata(kviewGUIhandle,'CustButtSett')
    setappdata(kviewGUIhandle,'CustButtSett',CustButtSett);
end

% User defined extension
if ~isappdata(kviewGUIhandle,'UserDefExt')
    setappdata(kviewGUIhandle,'UserDefExt',UserDefExt);
end

% CustomPanels to be loaded
if ~isappdata(kviewGUIhandle,'CustomPanels')
    setappdata(kviewGUIhandle,'CustomPanels',cell(0,2));
end
for ii = 1:size(CustomPanels,1)
    kviewAddCustomPanel(kviewGUIhandle,CustomPanels{ii,1},CustomPanels{ii,2});
end

% default X axis
if ~isappdata(kviewGUIhandle,'defaultXAxis')
    setappdata(kviewGUIhandle,'defaultXAxis',defaultXAxis);
    setappdata(kviewGUIhandle,'XAxisVarName',defaultXAxis{1});
    setappdata(kviewGUIhandle,'XAxisSubsysName',defaultXAxis{2});
end


function CreatekviewSettings
% This function creates the kviewSettings.mat if it does not exist.
    
% DEV NOTE: remember to add new variables to the SAVE command at the end of
% the function!!

% Check if the kview.m function is on the paths
kvPath = which('kview.m');
if isempty(kvPath)
    error('''kview.m'' not found.');
end

ImpFileConvSett = {cell(3) cell(3) cell(3)};
ImpWSConvSett = {cell(3) cell(3) cell(3)};
CustButtSett = cell(3,2);

UserDefExt = cell(0,3);
CustomPanels = cell(0,2);

defaultXAxis = {'',''};

save(strrep(kvPath,'kview.m','kviewSettings.mat'),'ImpFileConvSett','ImpWSConvSett','CustButtSett','CustomPanels','UserDefExt','defaultXAxis')

