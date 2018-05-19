%% *Button Tables*
% KView allows user to easly place buttons on the GUI to call user defined
% funtions. This may come in handy when a particular function is called
% often in conjuction with the KView.

%% Custom buttons panel
% The panels holding the user defined buttons can be opened choosing one of the
% _Custom Panel_ options from the popup menus present in the
% lower part of the GUI.
%
% A single panel can hold a maximum of six buttons; the buttons are defined
% in a _buttontable_ file (explained below). To link the panel to the desired file there
% is a dedicated window tha can be open from *File* > *Custom Button
% Sett.*.

%% Buttontable file
% This is a normal text file that can be opened with any text editor.
%
% *Button files content example:*
%
%  Button 1
%  Button_text: Import Excel
%  Button_func: Excel2KView
%  Button_tooltip: Function to import excel files.
%  Button 2
%  Button_text: Save Dataset
%  Button_func: SaveDataset
%
% The file needs three information for each button that the user wants to
% add: button number, text and function. Tooltip is optional.
%
% *Button number:* the number can go from 1 to 6 and represent the position
% hold by that particular button on the panel.
%
% *Button text:* the text that will be displayed on the button. 
%
% *Button function:* the name of the function that will be called when
% pressing the function. Sine no input is passed the function must be able
% to work without them. In case the <kvinterface_export.html KView Export> command can be used inside the function to
% retrive data from the GUI.
%
% *Button tooltip:* this field is optional; if present the button will show
% a tooltip when hovered. It is possible to use the newline symbol "\n" to
% make the string span multiple lines.

%% Accessing function help file
% It is possible to view the function help or even open the function file
% using the right-click menu. Pressing the right mouse button on a custom
% button will open a menu with two options: *Help* and *Open File*. The
% help option will show the function help on the message window, while the
% open file option will open the function code.

%% See Also
% <kvinterface_export.html KView Command Interface: Export> | <kvinterface_import.html KView Command Interface: Import> 


