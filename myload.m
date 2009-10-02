function val = myload(name, globalInfo)
%function val = myload(name, globalInfo)
%Loads the value 'name' from the dataset file.
%This script is intelligent enough to read data in UBUNTU and also MAC OS,
%by reading the environment variable "OSTYPE". The path information is read from the variable
%DATAPATH or DATAPATH_MAC, depending on the operating system being used. If globalInfo is
%ommited, it will try access the file stored in ../globals.mat.
%

if nargin < 2, globalInfo = '../globals.mat'; end

name = getenv('CLUSTER_NAME');
if strcmp(name, 'CERN'),
  load(globalInfo, 'DATAPATH');
  pathVal = DATAPATH;
elseif strcmp(name, 'MAC'),
  load(globalInfo, 'DATAPATH_MAC');
  pathVal = DATAPATH_MAC;
elseif strcmp(name, 'LPS'),
  load(globalInfo, 'DATAPATH_LPS');
  pathVal = DATAPATH_LPS;
end

fileName = sprintf('%snn-data.mat', pathVal);
fprintf('Loading data from "%s"\n', fileName);

str = load(fileName, name);
val = str.(name);
