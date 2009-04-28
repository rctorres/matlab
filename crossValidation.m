function retValues = crossValidation(net, dataFile, setSize, numJobs)
%function retValues = crossValidation(net, dataFile, setSize, numJobs)
%Performs cross validation of a dataset using the non trained network net. 
%The dataset must contain a electron and jet dataset (as returned by 
%load_rings), the rings distribution vector and the section distribution 
%over all layers. This function will take a dataset, and ramdomly choose 
%setSize elements from the electrons and setSize elements from the jet 
%group at each job. A total of numJobs will be performed. At the end, a 
%ROC graph with all plots will be shown and the function will return a 
%vecto of structures containing the following fields for each job:
% -epochs the epochs index from the network training.
% -trnError the network training MSE error evolution.
% -tstError the network testing MSE error evolution.
% -net the trained network obtained after the training.
% -eOutHist: the bim values for the electrons output histograms.
% -jOutHist: the bim values for the jets output histograms.
% -pd: the detection probabilities vector for each threshold.
% -pd: the false alarm probabilities vector for each threshold.
% -bestCut: the threshold that gives the best SP value.
% -maxSP: the maximum SP achieved.
%

  normType = 'sequential';
  load(dataFile, 'ringsDist', 'secDist');
  ptype = ['b' 'r' 'k' 'm' 'c' 'g' 'y'];
  retValues = [];
  rocFig = figure;

  
  for i=1:numJobs,
    fprintf('Training network %d/%d\n', i, numJobs);
    load(dataFile, 'jets');
    jets = getDataSubSet(jets, setSize);
    jets = ringer_norm(jets.rings, ringsDist, secDist, normType);
    load(dataFile, 'electrons');
    electrons = getDataSubSet(electrons, setSize);
    electrons = ringer_norm(electrons.rings, ringsDist, secDist, normType);
    
  
    %Dividindo os conjuntos de treino, teste e validacao.
    inTrn = {electrons(:,1:3:end) jets(:,1:3:end)};
    inTst = {electrons(:,2:3:end) jets(:,2:3:end)};
    val = {electrons(:,3:3:end) jets(:,3:3:end)};
 
    %Treinando a rede.
    norm.epochs = [];
    norm.trnError = [];
    norm.tstError = [];
    [netOut, norm.epochs, norm.trnError, norm.tstError] = ntrain(net, inTrn, [], inTst, []);
    norm.net = netOut;
    eOut = nsim(norm.net, val{1});
    jOut = nsim(norm.net, val{2});
    norm.eOutHist = hist(eOut, 1000);
    norm.jOutHist = hist(jOut, 1000);

    clear inTrn inTst val;

    [spVec, cutVec, detVec, faVec] = genROC(eOut, jOut, 5000);
    clear eOut jOut;
    norm.pd = detVec;
    norm.pfa = faVec;
    [sp, cutIDX] = max(spVec);
    norm.bestCut = cutVec(cutIDX);
    norm.maxSP = sp;

    retValues = [retValues norm];
    
    figure(rocFig);
    plot(norm.pfa, norm.pd, ptype(1+mod(i,length(ptype))));
    hold on;    
    
  end

  figure(rocFig);
  title('Cross Validation ROCs');
  xlabel('False Alarm (%)');
  ylabel('Detection Efficiency (%) ');
  disp('End of analysis!');
