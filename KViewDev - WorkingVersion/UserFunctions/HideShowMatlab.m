function HideShowMatlab(varargin)
% Code to Hide and Show Matlab Desktop (Window)
% 
% SYNTAX:
%   HideShowMatlab
%   HideShowMatlab('Show')
%
% INPUT:
%   HideShowMatlab          Toggle the status of Matlab visibility
%   HideShowMatlab('Show')  Set Matlab visibility to true
%
%
% DESCRIPTION:
% Get COM handle to matlab Desktop:
% h = com.mathworks.mlservices.MatlabDesktopServices.getDesktop.getMainFrame;
%
% Get current status:
%   h.isVisible
%
% Change status:
%   h.setVisible(status) where "status" is a boolean valie: true (1) or 
%   false (0).


h = com.mathworks.mlservices.MatlabDesktopServices.getDesktop.getMainFrame;

if nargin==0
    if h.isVisible
        h.setVisible(0);
    else
        h.setVisible(1)
    end
elseif ~h.isVisible
    if strcmpi(varargin{1},'Show')
        h.setVisible(1);
    end
end
