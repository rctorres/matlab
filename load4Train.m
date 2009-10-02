function [inTrn, inVal, inTst, ringsDist] = load4Train(ringsOnly, globalInfo)
%function [inTrn, inVal, inTst, ringsDist] = load4Train(ringsOnly, globalInfo)
%Loads the dataset files, and organize them already into train, val e test
%sets. This script is intelligent enough to read data in UBUNTU and also MAC OS,
%by reading the environment variable "OSTYPE". The path information is read from the variable
%DATAPATH or DATAPATH_MAC, depending on the operating system being used. If globalInfo is
%ommited, it will try access the file stored in ../globals.mat. ringsOnly
%specifies whether the function should return the data structure (Et, eta,
%phi, rings, etc, or only the rings. Default is TRUE.
%

if nargin < 1, ringsOnly = true; end
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

load(fileName);
if ringsOnly,
  inTrn = {eTrn.rings, jTrn.rings};
  inVal = {eVal.rings, jVal.rings};
  inTst = {eTst.rings, jTst.rings};
else
  inTrn = {eTrn, jTrn};
  inVal = {eVal, jVal};
  inTst = {eTst, jTst};  
end
