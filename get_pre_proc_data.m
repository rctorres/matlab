function [inTrn_W, inVal_W, inTst_W] = get_pre_proc_data(inTrn, inVal, inTst, W)
%function [inTrn_W, inVal_W, inTst_W] = get_pre_proc_data(inTrn, inVal,inTst, W)
%Projects the data sets onto the base specified in W. W must be organized so
%that each direction is a row.
%
nSets = length(inTrn);

W = single(W);
inTrn_W = cell(1,nSets);
inVal_W = cell(1,nSets);
inTst_W = cell(1,nSets);

for i=1:nSets,
  inTrn_W{i} = W * inTrn{i};
  inVal_W{i} = W * inVal{i};
  inTst_W{i} = W * inTst{i};
end

