function [ varargout ] = KView( varargin )
% KView simply supplies all the inputs and outputs to kview
%
% This function was created only for compatibility with future/past code.
%
% SEE ALSO: kview
%
% -------------------------------------------------------------------------

warning('obsolete call, change the function from KView to kview.')
[varargout{1:nargout}] = kview(varargin{1:nargin});

end

