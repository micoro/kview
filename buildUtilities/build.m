% Get the path
toolboxPackagingConfDir = fullfile(fileparts(mfilename('fullpath')),'..');
toolboxPackagingConfFullPath = fullfile(toolboxPackagingConfDir,'ToolboxPackagingConfiguration.prj');

% Major.Minor.Patch/Bugfix.Build

% Get current version 
currentVersion = matlab.addons.toolbox.toolboxVersion(toolboxPackagingConfFullPath);
currentVersionNumber = str2double(extract(currentVersion,digitsPattern));  
disp("Previous version: " + currentVersion);

% Create new version number
newVersionNumber = currentVersionNumber;
newVersionNumber(4) = newVersionNumber(4) + 1; 
newVersionString = join(string(newVersionNumber),".");
disp("New version: " + newVersionString);

% insert new version in the toolbox configuration
matlab.addons.toolbox.toolboxVersion(toolboxPackagingConfFullPath,newVersionString);


% package toolbox  
newfileName = fullfile(toolboxPackagingConfDir,"releases","kview_v" + newVersionString);
matlab.addons.toolbox.packageToolbox(toolboxPackagingConfFullPath,newfileName);

disp("-- Build completed --");