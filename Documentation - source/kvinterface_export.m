%% *KView Command Interface: Export*
% Calling the KView function with the string 'export' as first argument it's possible to get data from the GUI.

%% Syntax
%   [output] = KView('Export','Selected','Dataset')
%   [XAxisSubsystem,XAxisVariable] = KView('Export','XAxis')
%   [output] = KView('Export',...)

%% Description
% |[XAxisSubsystem,XAxisVariable] = KView('Export','XAxis')| where XAxisSubsystem and XAxisVariable are strings with the name of the subsystem and the variable assigned for the X axis. [DEV NOTE: add an image of the XAxis on the KView]
%
% |[CellOfDatasets] = KView('Export','Selected','Dataset')| export the datasets selected in the KView GUI. CellOfDatasets if a cell array containing all the datasets
% selected in the first listbox of the GUI. 
%
% |[CellOfDatasets,CellOfDatasetsNames] = KView('Export','Selected','Dataset')| where CellOfDatasetsNames is a string cell array containing the names of the datasets exported.



%% See Also
% <kvinterface.html KView Command Interface> | <kvinterface_import.html KView Command Interface: Import> 