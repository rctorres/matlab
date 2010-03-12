function t2caAns = eGammaHypo(data, sign) 
% t2caAns = eGammaHypo(data, sign)
% 
% Outputs t2caAns
%
%   t2caAns vector containing eGammaHypo hypotesis:
%   0 -> approved;
%   1 -> rCore cut;
%   2 -> eRatio cut;
%   3 -> EM Et cut;
%   4 -> HAD Et cut;
%
% Inputs (data, sign)
%
%   data: data loaded with load_rings
%   sign: string containing the signature from the T2Calo cut. It can be: 'e5', 'e10', 'e15'. 

%% CONSTANTS

lvl2_eta = data.lvl2_eta;
rCore = data.t2ca_rcore;
eRatio = data.t2ca_eratio;
emES1 = data.t2ca_em_es1;
em_e = data.t2ca_em_e;
et = data.et;
ehadES0 = data.t2ca_had_es0;

m_eTthr.e5   		=	[4.e3, 4.e3, 4.e3, 4.e3, 4.e3, 4.e3, 4.e3, 4.e3, 4.e3];
m_hadeTthr.e5       =	[0.058, 0.058, 0.058, 0.058, 0.058, 0.058, 0.058, 0.058, 0.058];
m_caeratiothr.e5	=	[0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10];
m_carcorethr.e5 	=	[0.65, 0.65, 0.65, 0.65, 0.65, 0.65, 0.65, 0.65, 0.65];
m_eT2thr.e5         =	[90e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3];
m_hadeT2thr.e5      =	[999, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0];
m_etabin.e5         =	[0, 0.6, 0.8, 1.15, 1.37, 1.52, 1.81, 2.01, 2.37, 2.47];
m_F1thr.e5		    =	0.005;    
m_etabin.e5         =   [0, 0.6, 0.8, 1.15, 1.37, 1.52, 1.81, 2.01, 2.37, 2.47];


m_eTthr.e10         =	[9.e3, 9.e3, 9.e3, 9.e3, 9.e3, 9.e3, 9.e3, 9.e3, 9.e3];
m_hadeTthr.e10      =	[0.043, 0.043, 0.043, 0.043, 0.043, 0.043, 0.043, 0.043, 0.043];
m_carcorethr.e10	=	[0.87, 0.87, 0.87, 0.87, 0.87, 0.87, 0.87, 0.87, 0.87];
m_caeratiothr.e10   =	[0.29, 0.29, 0.29, 0.29, 0.29, 0.29, 0.29, 0.29, 0.29];
m_eT2thr.e10        =	[90e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3];
m_hadeT2thr.e10     =	[999, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0];
m_etabin.e10        =	[0, 0.6, 0.8, 1.15, 1.37, 1.52, 1.81, 2.01, 2.37, 2.47];
m_F1thr.e10		    =	0.005;
m_etabin.e10        =   [0, 0.6, 0.8, 1.15, 1.37, 1.52, 1.81, 2.01, 2.37, 2.47];


m_eTthr.e15 		=	[14.e3, 14.e3, 14.e3, 14.e3, 14.e3, 14.e3, 14.e3, 14.e3, 14.e3];
m_hadeTthr.e15      =	[0.043, 0.043, 0.043, 0.043, 0.043, 0.043, 0.043, 0.043, 0.043];
m_carcorethr.e15	=	[0.87, 0.87, 0.87, 0.87, 0.87, 0.87, 0.87, 0.87, 0.87];
m_caeratiothr.e15	=	[0.60, 0.60, 0.60, 0.60, 0.60, 0.60, 0.60, 0.60, 0.60];
m_eT2thr.e15        =	[90e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3, 90.0e3];
m_hadeT2thr.e15     =	[999, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0, 999.0];
m_etabin.e15        =	[0, 0.6, 0.8, 1.15, 1.37, 1.52, 1.81, 2.01, 2.37, 2.47];
m_F1thr.e15		    =	0.005;
m_etabin.e15        =   [0, 0.6, 0.8, 1.15, 1.37, 1.52, 1.81, 2.01, 2.37, 2.47];


alpha = reshape( abs( kron( lvl2_eta,ones( 1,length( m_etabin.(sign) ) ) ) ), length( m_etabin.(sign)), [] );
beta = repmat(m_etabin.(sign)',1,length(lvl2_eta));
[lines, colums] = find( alpha > beta ); %#ok<NASGU>
counter = 1;
etaBin = zeros(1,length(lvl2_eta));
while (lines(counter+1) == 1)
    etaBin(counter) = 1 ;
    counter = counter + 1;
end
size(etaBin(counter:end))
size([lines(find(lines(counter+1:end) == 1) -1)' lines(end)])
etaBin(counter:end) = [lines(find(lines(counter+1:end) == 1) -1)' lines(end)];
etaBin(etaBin==10) = 9;
clear alpha beta lines colums;

inCrack = ( abs(lvl2_eta) > 2.37 | ( abs(lvl2_eta) > 1.37& abs(lvl2_eta)< 1.52 ) );

if (et >  m_eT2thr.(sign)(etaBin));
    hadET_cut = m_hadeT2thr.(sign)(etaBin);
else
    hadET_cut = m_hadeTthr.(sign)(etaBin);
end

F1 = emES1 ./ em_e;
hadEt = ehadES0./cosh(abs(lvl2_eta))./et;


%% eGammaHyppo

%Cuts
rCoreCut = find(rCore < m_carcorethr.(sign)(etaBin));
eRatioCut = setdiff(find((~inCrack | F1 < m_F1thr.(sign)) & ( eRatio < m_caeratiothr.(sign)(etaBin))), rCoreCut);
etCut = setdiff(setdiff(find((et < m_eTthr.(sign)(etaBin))),rCoreCut), eRatioCut);
hadEtCut = setdiff(setdiff(setdiff(find( ( hadEt > hadET_cut )) , rCoreCut),eRatioCut),etCut);

% rejected = [rCoreCut eRatioCut etCut, hadEtCut];
% 
% approved = setdiff(1:length(lvl2_eta),rejected);

t2caAns = zeros(1, length(lvl2_eta));
t2caAns(rCoreCut) = 1;
t2caAns(eRatioCut) = 2;
t2caAns(etCut) = 3;
t2caAns(hadEtCut) = 4;
