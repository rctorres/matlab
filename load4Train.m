function [inTrn, inVal, inTst, ringsDist] = load4Train(normType, tstOnly, globalInfo)
%function [inTrn, inVal, inTst, ringsDist] = load4Train(normType, tstOnly, globalInfo)
%Loads the dataset files, and organize them already into train, val e test
%sets. This script is intelligent enough to read data in UBUNTU and also MAC OS,
%by reading the environment variable "OSTYPE". The path information is read from the variable
%DATAPATH or DATAPATH_MAC, depending on the operating system being used. If globalInfo is
%ommited, it will try access the file stored in ../globals.mat. normType is
%the name of the normalization initially used for the data (set,s ection,
%sequential, etc), and tstOnly, if true, will return ONLY the test set, for
%validation purposes. Otherwise, all 3 sets will be returned.
%

if nargin == 1,
  globalInfo = '../../globals.mat';
  tstOnly = false;
elseif nargin == 2,
  globalInfo = '../../globals.mat';
end

name = getenv('LOGNAME');
if strcmp(name, 'torres'), %If ubuntu, logname is torres, otherwise os rtorres
  load(globalInfo, 'DATAPATH');
  pathVal = DATAPATH;
else %If MAC.
  load(globalInfo, 'DATAPATH_MAC');
  pathVal = DATAPATH_MAC;
end

fileName = sprintf('%snn-data-%s.mat', pathVal, normType);
fprintf('Loading data from "%s"\n', fileName);

if tstOnly,
  disp('Loading only the test data set.');
  load(fileName, 'eTst', 'jTst');
  inTrn = {eTst.rings jTst.rings};
else
  load(fileName);
  inTrn = {eTrn.rings jTrn.rings};
  inVal = {eVal.rings jVal.rings};
  inTst = {eTst.rings jTst.rings};
end