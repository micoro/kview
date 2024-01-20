%% *KView Dataset Format*
% Internally KView handle the datasets as structures with nested fields.
%
% Dataset.Subsystem.Variable
%
% *Note:* all the KView functions expect datasets formatted this way.

%% Dataset
% Each dataset represent a different group of data. Normally this data have
% something in common, like different signal acquired during a single
% simulation or experiment. When two datasets are selected in the GUI, only
% subsystems that are present in both datasets are shown in the second
% listbox.
%
% *Note:* all the variables stored into the same dataset should have the
% same number of points.


%% Subsystem
% Subsystems can be useful to organize the signals/variables in ordered
% groups. When two subsystems are selected in the GUI, only variables that
% are present in both subsystems are shown in the third listbox.
%
% *X axis default subsystem:* This is a special subsystem that can be
% specified by the user in the <settings.html settings>. The variables
% placed into this subsystem can be easly set as X axis for plotting using
% the button "set" under the third listbox. Clicking it with the right
% button will open a menu with all the variables stored in the
% KViewStandardXAxis subsystem; clicking it with the left button will set
% the X axis to the default X axis variable specified in the settings file.


%% Variable
% This last structure holds informations about a single
% variable/array/signal. It has two mandatory fields: "data" and "unit".
% Other fields may be added to store additional information without
% problems.
%
% *data:* This field stores the values of the variable. The values are
% stored into the form of a column array.
%
% *unit:* This field stores a string that represent the unit of the
% variable. The string can also be empty to reprent the absence of a unit.
%
% *X axis default variable:* This is a special variable that can be
% specified in the <settings.html settings> file. 


%% See Also
% <conversiontables.html Conversion Tables> | <settings.html Settings>


