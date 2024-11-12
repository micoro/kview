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
settingsStruct.FavoriteXAxisList       = string(getpref('kview', 'FavoriteXAxisList', ""));
settingsStruct.CustomButtonTable        = getpref('kview', 'CustomButtonTable', table('Size',[0 4],'VariableTypes',["string","string","string","string"],'VariableNames',["Group","Text","Function","Tooltip"]));
settingsStruct.CustomImportTable        = getpref('kview', 'CustomImportTable', table('Size',[0 3],'VariableTypes',["string","string","string"],'VariableNames',["Extension","Text","Function"]));