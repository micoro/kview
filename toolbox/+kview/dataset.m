classdef dataset<handle
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name    string = string.empty
        Table   {mustBeA(Table,["table","timetable"])} = table.empty
    end
    
    methods 
        function objDataset = dataset(t,name)
            objDataset.Name = name;
            objDataset.Table = t;
        end
    end

end

