function Var = kviewConvUnit(Var,ToUnit)
% Convert the unit of a kview variable.
% This code uses the UnitConverter toolbox created by John McDermid.
%
% SYNTAX:
%   ModVar = kviewConvUnit(Var,ToUnit)
%
% INPUT:
%   Var     variable in kview format (struct with "data" and "unit" fields)
%   ToUnit  string that rapresent the target unit
%
% OUTPUT:
%   ModVar  output variable


% Determine the coversion factor 
convFac=convert(unit(Var.unit),ToUnit);

% Change Var with the new unit
Var.data=convFac.value*Var.data;
Var.unit=ToUnit;

end

