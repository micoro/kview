function commonkvGroup = kvGroupComparison(kvGroupArrayA,kvGroupArrayB)
%KVGROUPCOMPARISON compare two kvGroup arrays and output the common items

% start by creating an empty kvgroup
% commonkvGroup = kview.newkvGroup({},{},{}); 
commonkvGroup = [];


if isempty(kvGroupArrayA) || isempty(kvGroupArrayB)
    return
end

for iGroup = kvGroupArrayA
    jGroup = kvGroupArrayB(strcmp([kvGroupArrayB.Name],iGroup.Name)); 
    if ~isempty(jGroup)
        if all(strcmp([iGroup.Name, iGroup.Type, iGroup.Content],[jGroup.Name, jGroup.Type, jGroup.Content]))
            if isempty(commonkvGroup)
                commonkvGroup = kview.newkvGroup(iGroup.Name, iGroup.Type, iGroup.Content);
            else
                commonkvGroup(end+1) = kview.newkvGroup(iGroup.Name, iGroup.Type, iGroup.Content);
            end
            if ~isempty(iGroup.Children)
                commonkvGroup(end).Children = kview.kvGroupComparison([iGroup.Children], [jGroup.Children]);
            end
        end
    end
end

% sort in alphabetical order
[~,sortedIndex] = sort([commonkvGroup.Name]);
commonkvGroup = commonkvGroup(sortedIndex);

end

