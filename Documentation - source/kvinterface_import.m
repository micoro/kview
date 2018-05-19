%% *KView Command Interface: Import*
% Calling the KView function with the string 'import' as first argument it's possible to place data into the GUI.

%% Syntax
%   KView('Import','Dataset',DatasetsCell)
%   KView('Import','Dataset',DatasetsCell,'DatasetsNames',NamesCell)


%% Description
% |KView('Import','Dataset',DatasetsCell)| import the datasets in the cell array giving them a default naming convention (XXX).
%
% |KView('Import','Dataset',DatasetsCell,'NamesStrings',NamesCell)| where NamesCell is a string cell array. Each dataset in the DatasetsCell cell array will be 
% imported with the corresponding name in NamesCell.

%% Examples
% UNDER CONSTRUCTION
%

%% Tips
% * When using the <kvinterface_export.html datasets export functionality> it's possible to export the names of the datasets too. Doing this can be useful to make some changes/update
% and then reimport them with the same name using the 'NamesStrings' parameter. 

%% See Also
% <kvinterface.html KView Command Interface> | <kvinterface_export.html KView Command Interface: Export> 