classdef kvDataset<handle
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here 
    
    properties
        Name    string = string.empty
        Table   {mustBeA(Table,["table","timetable"])} = table.empty
    end
    
    methods 
        function objDataset = kvDataset(t,name)
            objDataset.Name = name;
            objDataset.Table = t;
        end
    end

end

