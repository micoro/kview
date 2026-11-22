function settingsStruct = getSettings
% loads the settings data of the Kview and/or creates the settings file.
%
%
% SYNTAX:
%   settingsStruct = kview.getSettings()



settingsStruct = struct;
settingsStruct.FavoriteXAxisList            = string(getpref('kview', 'FavoriteXAxisList', ""));
settingsStruct.CustomButtonTable            = getpref('kview', 'CustomButtonTable', table('Size',[0 4],'VariableTypes',["string","string","string","string"],'VariableNames',["Group","Text","Function","Tooltip"]));
settingsStruct.CustomImportTable            = getpref('kview', 'CustomImportTable', table('Size',[0 3],'VariableTypes',["string","string","string"],'VariableNames',["Extension","Text","Function"]));
settingsStruct.CustomImportClassTable       = getpref('kview', 'CustomImportClassTable', table('Size',[0 3],'VariableTypes',["string","string","string"],'VariableNames',["Class","Text","Function"]));
