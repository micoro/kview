function kvSettings = getSettings
% loads the settings data of the Kview and/or creates the settings file.
%
%
% SYNTAX:
%   kvSettings = kview.getSettings
%
%
% DESCRIPTION:
% 
%
%
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    08/05/2015
%   Author:  Michele Oro Nobili 


kvSettings = struct;
kvSettings.ImpFileConvSett  = getpref('kview', 'ImpFileConvSett', {cell(3) cell(3) cell(3)});
kvSettings.ImpWSConvSett    = getpref('kview', 'ImpWSConvSett', {cell(3) cell(3) cell(3)});
kvSettings.CustButtSett     = getpref('kview', 'CustButtSett', cell(3,2));
kvSettings.UserDefExt       = getpref('kview', 'UserDefExt', cell(0,3));
kvSettings.CustomPanels     = getpref('kview', 'CustomPanels', cell(0,2));
kvSettings.defaultXAxis     = getpref('kview', 'defaultXAxis', "");


