function valueIndex = listboxValueIndex(listboxHandle)
%LISTBOXVALUEINDEX outputs the ValueIndex as defined in the uilistbox 2023b
% This function generates the same value that has been added to the
% uilistbox in matlab 2023b: ValueIndex. 
% When the compatibility with version of matlab before 2023b is not needed
% anymore this function will become obsolete and can be substituted with a
% simple call to the new proptery: listboxHandle.ValueIndex.


valueIndex = [];

if isempty(listboxHandle.ItemsData)
    itemsList = listboxHandle.Items;
else
    itemsList = listboxHandle.ItemsData;
end
for iValue = listboxHandle.Value
    valueIndex = find(arrayfun(@(x)isequal(x,iValue),itemsList));
end

end

