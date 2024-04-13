function out = newkvGroup(name, type, content)
%NEWKVGROUP create a kvgroup

out = struct("Name",name,...
    "Type",type, ...
    "Content",content, ...
    "Children",[]);

end

