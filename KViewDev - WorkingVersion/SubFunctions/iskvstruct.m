function [Out, varargout] = iskvstruct(varargin)
% checks if the supplied arguments are kview structures.
%
% SYNTAX:
%   Out = iskvstruct(CellArrayOfObjects)
%   Out = iskvstruct(object1,object2,...)
%   [Out, message] = iskvstruct(__)
%
%
% DESCRIPTION:
% The function checks all the arguments to see if they are compliant with
% the kview dataset format (see documentation).
%
%
% INPUT:
%   CellArrayOfObjects  a cell array containing the objects that will be
%                       checked
%   object<n>           the object(s) that will be checked.
%
% OUTPUT:
%   Out         logical array of length n where n is the number of inputs; 
%               true = 1 and false = 0.
%   message     cell array of strings containing an exaplanation of the 
%               problem. If there were no prolems the message is an empty 
%               string.
%
% -------------------------------------------------------------------------
%   Copyright (C) 2016, All Rights Reserved.
%
%   Date:    15/05/2015
%   Author:  Michele Oro Nobili 


% Check numeber of inputs
if nargin == 0
    error('Not enough input arguments');
elseif nargin == 1 && iscell(varargin{1})
    ObjectsToCheck = varargin{1};
else
    ObjectsToCheck = varargin;
end

% preallocate output matrix
Out = true(length(ObjectsToCheck),1);
varargout = {cell(length(ObjectsToCheck),1)};

% Iterate trought the elements to check them
for ii = 1:length(ObjectsToCheck)
    if length(ObjectsToCheck{ii}) ~= 1
        varargout{1}{ii} = 'the structure supplied is not scalar (1-by-1).';
        Out(ii) = false;
        continue
    end
    if isstruct(ObjectsToCheck{ii}) && Out(ii)
        for jj = fieldnames(ObjectsToCheck{ii}).'
            if isstruct(ObjectsToCheck{ii}.(jj{1})) && Out(ii)
                for kk = fieldnames(ObjectsToCheck{ii}.(jj{1})).'
                    if isstruct(ObjectsToCheck{ii}.(jj{1}).(kk{1})) && Out(ii)
                        if ~all(isfield(ObjectsToCheck{ii}.(jj{1}).(kk{1}),{'data','unit'}))
                            varargout{1}{ii} = 'missing fields "data" and/or "unit" inside one or more variables.';
                            Out(ii) = false;
                            break
                        end
                    else
                        varargout{1}{ii} = 'at least one variable is not a structure.';
                        Out(ii) = false;
                        break
                    end
                end
            else
                if isempty(varargout{1}{ii})
                    varargout{1}{ii} = 'at least one subsystem is not a structure.';
                end
                Out(ii) = false;
                break
            end
        end
    else
        if isempty(varargout{1}{ii})
            varargout{1}{ii} = 'the object is not a structure.';
        end
        Out(ii) = false;
    end
end


end