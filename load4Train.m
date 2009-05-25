function [inTrn, inVal, inTst, ringsDist] = load4Train(globalInfo)
%function [inTrn, inVal, inTst, ringsDist] = load4Train(globalInfo)
%Loads the dataset files, and organize them already into train, val e test
%sets. This script is intelligent enough to read data in UBUNTU and also MAC OS,
%by reading the environment variable "OSTYPE". The path information is read from the variable
%DATAPATH or DATAPATH_MAC, depending on the operating system being used.
%

name = getenv('LOGNAME');
if strcmp(name, 'torres'), %If ubuntu, logname is torres, otherwise os rtorres
  load(globalInfo, 'DATAPATH');
  load(DATAPATH);
else %If MAC.
  load(globalInfo, 'DATAPATH_MAC');
  load(DATAPATH_MAC);
end

inTrn = {eTrn.rings jTrn.rings};
inVal = {eVal.rings jVal.rings};
inTst = {eTst.rings jTst.rings};
