function net2py( net , fileName )
%NET2PY Prints into Python syntax bias, weight and nodes of a neural
%network
%   ...

pyFile=fopen(fileName,'w');
fprintf(pyFile, '#Network Params imported from Matlab \n');

fprintf(pyFile, 'self.NodesVector=[');

%Getting nNodes params:
nNodes(1,1)=net.inputs{1}.size;
fprintf(pyFile, '%i',nNodes(1,1));
for i=1:net.numLayers,
    nNodes(i+1,1)=net.layers{i}.size;
    fprintf(pyFile, ',%i',nNodes(i+1,1));
end;
fprintf(pyFile, '] \n');

%Getting Weight params:
%Obs: Ordered by layer first, then by target node(next layer), then by all
%previous nodes(current layer) who connects to the target.

%Getting input weight params:
fprintf(pyFile, 'self.WeightVector=[');
weights = reshape (net.iw{1}',1,[]);

%Getting layers weight params:
for i=2:net.numLayers,
    weights = horzcat(weights,reshape(net.lw{i}',1,[]));
end

%Printing weight values:
w=size(weights);
fprintf(pyFile, '%f', weights(1,1));
for i=2:w(1,2),
    fprintf(pyFile, ',%f',weights(1,i));
end
fprintf(pyFile, ']\n');

%Getting bias param:
fprintf(pyFile, 'self.BiasVector=[');
bias=[];
for i=1:net.numLayers,
    bias=vertcat(bias,net.b{i});
end

%Printing bias values:
b=size(bias);
fprintf(pyFile, '%f',bias(1,1));
for i=2:b(1,1),
    fprintf(pyFile, ',%f',bias(i,1));
end
fprintf(pyFile, ']\n');

fclose(pyFile);
