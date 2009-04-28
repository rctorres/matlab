function list = getDirFiles(path, filt)
%function list = getDirFiles(dirName, filt)
%Returns a file list from the directory specified by "dirName", and of all the subdirectories from it.
%A filter (like '*txt*', '*.doc', etc) can be, optionally, specified in 'filt'.
%


%If a filter was not specified, we return all files.
if (nargin == 1),
	filt = '';
end

list = [];

%Getting the desired files from the current dir.
d = dir(sprintf('%s/%s', path, filt));
N = length(d);
for i=1:N,
	if (d(i).isdir == 0),
		list = [list  {sprintf('%s/%s', path, d(i).name)}];
	end
end

%Searching in the subdirectories.
d = dir(path);
N = length(d);
for i=1:N,
	if ( (d(i).isdir == 1) & (~strcmp(d(i).name, '.')) & (~strcmp(d(i).name, '..'))),
		newPath = sprintf('%s/%s', path, d(i).name);
		list = [list  getDirFiles(newPath, filt)];
	end
end
