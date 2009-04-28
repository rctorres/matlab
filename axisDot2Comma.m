%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEDERAL UNIVERSITY OF RIO DE JANEIRO / COPPE
% Electric Engineering Program
% 
% M.Sc. THESIS
% Student: Daniel Soares Gerscovich
% Supervisor: Luiz Wagner Pereira Biscainho
%
% Date of the last actualization : 28.11.2008
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% Function Description:
%
% Convert dot as a decimal point to comma as a decimal point in a 3D
% figure
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   


function axisDot2Comma

%title(' ')
%xlabel('Freqüência Normalizada [\times \pi  rad/amostra]','fontsize',16)
%ylabel('Amplitude [dB]','fontsize',14)
%set(gca,'fontsize',14)


X = get(gca,'XTickLabel');
Y = get(gca,'YTickLabel');


for n = 1 : size(X,1)
    for m = 1 : size(X,2)
        if X(n,m) == '.'
            X(n,m) = ',';
        end
    end
end

for n = 1 : size(Y,1)
    for m = 1 : size(Y,2)
        if Y(n,m) == '.'
            Y(n,m) = ',';
        end
    end
end


set(gca,'XTickLabel',X);
set(gca,'YTickLabel',Y);


end
