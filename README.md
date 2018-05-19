**Work in progress:** the kview is a work in progress, many functionalities can be uneasy to handle. I am also trying to write a documentation (access on the GUI from the menu->info->documentation) but it is in an embryo phase. 

If you find it interesting and want to contribute it will be **very appreciated**.

# KVIEW
kview is a matlab GUI used to easly plot multiple signals/arrays and make simple elaboration.
The main target is to plot physical signals, but it can be used to work with any kind of numerical array.

## Functionality
* Easily plot with a simple click (with labels automatically genereted)
* Signals organized in a three level hierarchy so that they can be divided into meaningful groups
* The unit a signal is expressed in can be changed with a simple click (uses [Unit Conversion Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/29621-units-conversion-toolbox?s_tid=prof_contriblnk))
* Provide basic funtions for import data from file or from workspace
  * It is possible to create maps to rearganize data during the import process (change names, units, apply gains...)
  * It is possible to create custom functions to import data into the GUI
* The kview import and export functions (plus few others) can be issued from the command line
* Buttons can be created on the GUI to call any function; your most used functions will be easy to reach (just one click)

### Command line functionality
It is possible to import and export data from the kview GUI from the command line. This can be used to create custom function that take data from the GUI, make some elaboration on the data and then display the output or import it back into the GUI. 

#### Example
If you often want to multiply two or more signals you can create a function that: 
 1. Takes all the selected signals from the GUI (use th export function)
 2. Multiply all the signals
 3. Plot or re-import the new signal in the GUI
 4. OPTIONAL: you can also add a button on the GUI that calls your custom function. 
 
Now you can select the signal on the GUI, call your function (or simply click the button) and see the result. Then select a new combination of signals and call your function again. A lot faster than re-typing all array names every time^^.

