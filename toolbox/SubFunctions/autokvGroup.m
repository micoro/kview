function autokvGroup(app)
%AUTOKVGROUP automatically creates groups based on the variable name
%
% DESCRIPTION: automatically generates kvGroups that are stored in the
% table custom properties based on the variable names. The name of the
% variable is splitted based on the delimiter (currently the delimiter is
% fixed to '.') and a group is created to filter variable with that prefix.
% It works also with repeated delimiters.
% 
%
% SYNTAX:   
%   app.autokvGroup()
%
% INPUT:
%   app     the kview app object
%   


for iIndex = app.selectedDatasetIndex'
    datasetTable = app.DatasetList(iIndex).Table;


    kvGroupList = struct('Name',{},'Type',{},'Content',{});
    
    for iVariable = datasetTable.Properties.VariableNames
        splittedName = split(string(iVariable),'.');
        for jCount = 1:length(splittedName)-1
            newGroutpName = join(splittedName(1:jCount),'.');
            if ~any(strcmp([kvGroupList.Name],newGroutpName))
                kvGroupList(end+1).Name = newGroutpName;
                kvGroupList(end).Type = "prefix";
                kvGroupList(end).Content = newGroutpName;
            end
        end
    end
    
    [~,uniqueIndex] = unique([kvGroupList.Name]);
    app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup = [app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup, kvGroupList(uniqueIndex)];
 
    [~,uniqueIndex] = unique([app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup.Name]);
    app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup = app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup(uniqueIndex);

end

app.refresh;

end

