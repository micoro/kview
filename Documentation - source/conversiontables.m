%% *Conversion Tables*
% The Conversion Tables are text files filled with the informations needed to transform a dataset from one convention to another.  
% This can be useful when there is a need to often perform a particular convention tranformation. For example this may happen when importing variables from the workspace: the 
% imported variables will have an empty unit field that can be automatically filled with the use of a conversion table.
%
% A convention table represent a transformation between two different conventions. The transformation can be operated in both direction and in case more than one conversion tables
% can be applied in sequence.


%% What can be done
%
% * set the default unit for specific quantities (velocity, acceleration, angle, force, etc...)
% * change the naming convention (subsystems and variables names)
% * apply a gain to a variable
% * change/impose variables unit


%% Table format
% 
% *Kind ID:*
% The first thing to appear in a conversion table are the two Kind IDs that identify the two conventions. The IDs must be valid matlab 
% <matlab:open(fullfile(matlabroot,'help','matlab','matlab_prog','variable-names.html')) variable names>. 
%
%   KindID_A: DataRaw
%   KindID_B: DataModified
%
% *Section:*
% After the Kind ID there should be a _section_ header. The section header is simply 
%
%   Section: <SectionType>
%
% There are two type of sections: Units and Variables.
%
% *Comments:* 
% Comments can be entered placing a "#" at the beginnig (and only at the beginning) of the line.

%% Section: Units
% This section determines if a particular quantity has a default unit to be used. 
% KView automatically convert all the elegible variables to the designed unit.
%
% KView at the moment recognizes the following unit quantities:
% 
% * time
% * frequency
% * length
% * velocity
% * acceleration
% * angle
% * angular_velocity
% * angular_acceleration
% * force
% * torque
% * pressure
%
% *Note:* the Unit section is independent from the conversion direction (from A to B or B to A) and is always applied.
% *Note:* at the moment this functionality tend to be very slow.

%% Section: Variables
% UNDER CONSTRUCTION

%% See Also
% <kvdatasetformat.html KView Dataset Format> 
