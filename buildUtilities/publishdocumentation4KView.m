% Get the folders
DocSourceFolder = fullfile(fileparts(which('KView.m')),'..','Documentation - source');
DocTargetFolder = fileparts(which('KView.m'));

% Add folders to path
addpath(DocSourceFolder);

FileList = dir(fullfile(DocSourceFolder,'*.m'));

for ii = FileList'
   publish(fullfile(DocSourceFolder,ii.name),'outputDir',fullfile(DocTargetFolder,'html'));
end

% Copy xml files
copyfile(fullfile(DocSourceFolder,'info.xml'),DocTargetFolder);
copyfile(fullfile(DocSourceFolder,'helptoc.xml'),fullfile(DocTargetFolder,'html'));

% Remove folders from path
rmpath(DocSourceFolder);

% Build a searchable database
builddocsearchdb(fullfile(DocTargetFolder,'html'));