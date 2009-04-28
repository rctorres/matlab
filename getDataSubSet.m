function newData = getDataSubSet(data, nData)
%function newData = getDataSubSet(data, nData)
%Takes a subset of a data variable like the ones returned by load_rings.
%It receives the data variable, and the number of events to take. If nData is a number, then
%nData events, ramdomly choosen are returned. If nData is a row vector, then it is considered
%as a index vector, and only the events at the requested indexes are returned (no scrambling is
%done in this mode). The newData is the return structure, containing the exact same fields as data, 
%but with only nData (or length(nData) events. This function considers that each event is a 
%column vector.
  totalEvents = length(data.lvl1_id);
  
  if (length(nData) == 1), %Choose nData events ramdomly.
    I = scramble(totalEvents);
    I = I(1:nData);    
  else %Take the events at the requested indexes.
    I = nData;
  end
  
  if (totalEvents < length(I)),
    error('The data set is smaller than the requested number of events!');
  end
  
  strNames = fieldnames(data);
  newData = data;
  for i=1:length(strNames),
    aux = getfield(data, strNames{i});
    newData = setfield(newData, strNames{i}, aux(:,I));
  end
