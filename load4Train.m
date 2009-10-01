function [inTrn, inVal, inTst, ringsDist] = load4Train(tstOnly, ringsOnly, globalInfo)
%function [inTrn, inVal, inTst, ringsDist] = load4Train(tstOnly, ringsOnly, globalInfo)
%Loads the dataset files, and organize them already into train, val e test
%sets. This script is intelligent enough to read data in UBUNTU and also MAC OS,
%by reading the environment variable "OSTYPE". The path information is read from the variable
%DATAPATH or DATAPATH_MAC, depending on the operating system being used. If globalInfo is
%ommited, it will try access the file stored in ../globals.mat. tstOnly, 
%if true, will return ONLY the test set, for
%validation purposes. Otherwise, all 3 sets will be returned. ringsOnly
%specifies whether the function should return the data structure (Et, eta,
%phi, rings, etc, or only the rings. Default is TRUE.
%

if nargin < 1, tstOnly = false; end
if nargin < 2, ringsOnly = true; end
if nargin < 3, globalInfo = '../../globals.mat'; end

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

if tstOnly,
  disp('Loading only the test data set.');
  load(fileName, 'eTst', 'jTst');
  if ringsOnly,
    inTrn = {eTst.rings, jTst.rings};
  else
    inTrn = {eTst, jTst};
  end
else
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
end
