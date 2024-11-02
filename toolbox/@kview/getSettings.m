function settingsStruct = getSettings
% loads the settings data of the Kview and/or creates the settings file.
%
%
% SYNTAX:
%   settingsStruct = kview.getSettings()



settingsStruct = struct;
settingsStruct.ImpFileConvSett          = getpref('kview', 'ImpFileConvSett', {cell(3) cell(3) cell(3)});
settingsStruct.ImpWSConvSett            = getpref('kview', 'ImpWSConvSett', {cell(3) cell(3) cell(3)});
settingsStruct.CustButtSett             = getpref('kview', 'CustButtSett', cell(3,2));
settingsStruct.UserDefExt               = getpref('kview', 'UserDefExt', cell(0,3));
settingsStruct.CustomPanels             = getpref('kview', 'CustomPanels', cell(0,2));
settingsStruct.favouriteXAxisList       = string(getpref('kview', 'favouriteXAxisList', ""));


