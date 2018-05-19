%% *KView Command Interface*
% Arguments may be supplied to the KView function to manage the KView GUI from the command window.

%% First Argument 
% The first argument determines the operation to be performed. Since more arguments must be supplied and they differs depending on the first one,
% those are explained in the specific pages.
%
% * Query - return true if the KView GUI is open. Otherwise return false.
% * Handle - return the handle of the KView GUI.
% * <kvinterface_export.html Export> - to export data from the GUI to the workspace 
% * <kvinterface_import.html Import> - to import the supplied data into the GUI


%% Tips
% * The export and import functionalities can be used to automate some heavy elaboration: create a function that export the data from the GUI, processes it and then import the
% new data into the GUI so that it is available for visualization of further processing. It is also possibile to show a button on the GUI to call the function 
% (see <buttontables.html Button Tables>). This can be particularly useful when the same elaboration is performed often and on datasets with the same (or similar) naming convention.

%% See Also
% <kvinterface_export.html KView Command Interface: Export> | <kvinterface_import.html KView Command Interface: Import> 


