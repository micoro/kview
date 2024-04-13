function  populateTree(parentHandle,kvGroupList)
%POPULATETREE populate the uitree in the kview with a list of groups
% parentHandle can be a tree or a node

for iGroup = kvGroupList
    newTreenodeHandle = uitreenode(parentHandle, Text = iGroup.Name, NodeData = rmfield(iGroup,"Children"));
    if ~isempty(iGroup.Children)
        kview.populateTree(newTreenodeHandle, iGroup.Children);
    end
end

end

