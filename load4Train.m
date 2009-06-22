function [inTrn, inVal, inTst, ringsDist] = load4Train(globalInfo)
%function [inTrn, inVal, inTst, ringsDist] = load4Train(globalInfo)
%Loads the dataset files, and organize them already into train, val e test
%sets. This script is intelligent enough to read data in UBUNTU and also MAC OS,
%by reading the environment variable "OSTYPE". The path information is read from the variable
%DATAPATH or DATAPATH_MAC, depending on the operating system being used. If globalInfo is
%ommited, it will try access the file stored in ../globals.mat
%

if nargin == 0,
  globalInfo = '../globals.mat';
end

name = getenv('LOGNAME');
if strcmp(name, 'torres'), %If ubuntu, logname is torres, otherwise os rtorres
  load(globalInfo, 'DATAPATH');
  pathVal = DATAPATH;
else %If MAC.
  load(globalInfo, 'DATAPATH_MAC');
  pathVal = DATAPATH_MAC;
end

fprintf('Loading data from "%s"\n', pathVal);
load(pathVal);
inTrn = {eTrn.rings jTrn.rings};
inVal = {eVal.rings jVal.rings};
inTst = {eTst.rings jTst.rings};
