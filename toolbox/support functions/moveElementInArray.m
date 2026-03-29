function [outputArray, listOfIndexToMoveNewPosition] = moveElementInArray(inputArray,listOfIndexToMove,direction)
%MOVEELEMENTINARRAY move a list of elements in an array up and down by one
%
% DESCRIPTION
% This function can be use to move one (or more, even non contiguous)
% elements of an array up and down the array by one unit.
% If an element is at the end of the array it cannot move.
%
% OUTPUT:
%   outputArray                     the inputArray but reordered by the function
%   listOfIndexToMoveNewPosition    the new position that the listOfIndexToMove have reached 


arguments
    inputArray
    listOfIndexToMove (1,:)
    direction (1,1) string {mustBeMember(direction,["up","down"])}
end

indexList = 1:numel(inputArray); 
listOfIndexToMove = indexList(listOfIndexToMove); % in case listOfIndexToMove is a logical array it will be transformed into the actual index number
listOfIndexToMoveNewPosition = [];
    
if direction == "up"
    for indexToMove = listOfIndexToMove
        if indexToMove == 1 || any(listOfIndexToMove == indexList(indexToMove-1))
            listOfIndexToMoveNewPosition(end+1) = indexToMove;
            continue; 
        end
        indexList = [indexList(1:indexToMove-2) indexList(indexToMove) indexList(indexToMove-1) indexList(indexToMove+1:end)];
        listOfIndexToMoveNewPosition(end+1) = indexToMove-1;
    end
end

if direction == "down"
    for indexToMove = flip(listOfIndexToMove)
        if indexToMove == numel(indexList) || any(listOfIndexToMove == indexList(indexToMove+1))
            listOfIndexToMoveNewPosition(end+1) = indexToMove;
            continue; 
        end
        indexList = [indexList(1:indexToMove-1) indexList(indexToMove+1) indexList(indexToMove) indexList(indexToMove+2:end)];
        listOfIndexToMoveNewPosition(end+1) = indexToMove+1;
    end
end

% generate the reordered output list
outputArray = inputArray(indexList);

end

