function [trn, val, tst, pp] = do_nothing(trn, val, tst, par)
%function [oTrn, oVal, oTst, pp] = do_nothing(trn, val, tst, par)
%Nao faz nada, so serve qdo nao queremos nenhuma normalizacao nos dados
%
disp('Nao fazendo NENHUMA normalizacao...');
pp.name = 'do_nothing';
