function autokvGroup()
%AUTOKVGROUP Summary of this function goes here
%   Detailed explanation goes here

kvo = kview;

for iIndex = kvo.selectedDatasetIndex'
    datasetTable = kvo.DatasetList(iIndex).Table;


    kvGroupList = struct('Name',{},'Type',{},'Content',{});
    
    for iVariable = datasetTable.Properties.VariableNames
        splittedName = split(string(iVariable),'.');
        for jCount = 1:length(splittedName)-1
            newGroutpName = join(splittedName(1:jCount),'.');
            if ~any(strcmp([kvGroupList.Name],newGroutpName))
                kvGroupList(end+1).Name = newGroutpName;
                kvGroupList(end).Type = 'prefix';
                kvGroupList(end).Content = newGroutpName + ".";
            end
        end
    end
    
    [~,uniqueIndex] = unique([kvGroupList.Name]);
    kvo.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup = [kvo.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup, kvGroupList(uniqueIndex)];
 
    [~,uniqueIndex] = unique([kvo.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup.Name]);
    kvo.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup = kvo.DatasetList(iIndex).Table.Properties.CustomProperties.kvGroup(uniqueIndex);

end

kvo.refresh;

end

