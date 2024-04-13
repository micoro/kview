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


    kvGroupList = kview.newkvGroup({},{},{});
    
    for iVariable = datasetTable.Properties.VariableNames
        splittedName = split(string(iVariable),'.');
        if length(splittedName)>1
            kvGroupList = recursiveGroupCreator(kvGroupList, splittedName, 1);
        end
    end
    
    [~,uniqueIndex] = unique([kvGroupList.Name]);
    app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup = [app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup, kvGroupList(uniqueIndex)];
 
    [~,uniqueIndex] = unique([app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup.Name]);
    app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup = app.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup(uniqueIndex);

end

app.refresh;

end

%% Nested function for recursive generation
function kvGroupList = recursiveGroupCreator(kvGroupList, splittedName, currentIteration)

    if isempty(kvGroupList) 
        currentGroup = kview.newkvGroup(splittedName(currentIteration), "prefix", join(splittedName(1:currentIteration),'.'));
        kvGroupList = currentGroup;
        currentGroupIndex = length(kvGroupList);
    elseif ~any(strcmp([kvGroupList.Name],splittedName(currentIteration)))
        currentGroup = kview.newkvGroup(splittedName(currentIteration), "prefix", join(splittedName(1:currentIteration),'.'));
        kvGroupList(end+1) = currentGroup;
        currentGroupIndex = length(kvGroupList);
    else
        currentGroupIndex = find(strcmp([kvGroupList.Name],splittedName(currentIteration)),1);
    end
    
    if currentIteration < length(splittedName)-1
        kvGroupList(currentGroupIndex).Children = recursiveGroupCreator(kvGroupList(currentGroupIndex).Children, splittedName, currentIteration+1);
    end


end
