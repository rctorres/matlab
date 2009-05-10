function [inTrn, inVal, inTst, ringsDist] = load4Train(dataFile)
%function [inTrn, inVal, inTst, ringsDist] = load4Train(dataFile)
%Loads the dataset files, and organize them already into train, val e test
%sets.
%

load(dataFile);
inTrn = {eTrn.rings jTrn.rings};
inVal = {eVal.rings jVal.rings};
inTst = {eTst.rings jTst.rings};
