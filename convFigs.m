function convFigs(figDir, fmt)
%function convFigs(figDir, fmt)
%Converts the .fig files in a directory to a given picture format (png,
%jpeg, etc). figDir must be a directory (wildcards are accepted), and fmt
%the desired output format. The converted figures are saved in the same
%directory as the original ones.
%

figsList = dir(figDir);

for i = 1:length(figsList),
  open(figsList(i).name);
  [path, fileName, ext] = fileparts(figsList(i).name);
  if length(path) == 0, path = '.'; end
  formatFig(gcf);
  set(gcf,'PaperPositionMode','auto')
  saveas(gcf, sprintf('%s/%s', path, fileName), fmt);
  close gcf;
end


function formatFig(figHandler)
%This function was created by Leonardo Nunes (lonnes@lps.ufrj.br).
% This script configures the current figure.
% The folowing figure properties are connfigured:
% 
% text (ticks and labels) size
% text (ticks and labels) font
% line width
% figure size
%
% if the variable 'figName' exists, a .fig and an .eps, files with the name
% contained in 'figName', are saved.

% Congigurarion:
size = 16;
font = 'Times New Roman';
lineWidth = 2;
figDim = [1 1 1400 900];


%--------------------------------------------------------------------------
% Configuring figure

if(~isempty(get(0,'CurrentFigure')))
    
    fc = get(figHandler,'children'); % children of the current figure.

    % Cycling through children:
    
    for ii9183=1:length(fc)
        
        if(strcmp(get(fc(ii9183),'Type'),'axes'))

            % Configuring axes text:
            set(fc(ii9183),'FontSize',size);
            set(fc(ii9183),'FontName',font);
            
            % Configuring label text:
            ax = get(fc(ii9183),'xlabel');
            set(ax,'FontSize',size);
            set(ax,'FontName',font);
            
            ay = get(fc(ii9183),'ylabel');
            set(ay,'FontSize',size);
            set(ay,'FontName',font);       
            
            % Configuring title text:
            
            at = get(fc(ii9183),'title');
            set(at,'FontSize',size);
            set(at,'FontName',font);
            
            ac = get(fc(ii9183),'children'); % axes children.
            
            for jj98719=1:length(ac)
               
                if(strcmp(get(ac(jj98719),'Type'),'line'))
                   
                    set(ac(jj98719),'LineWidth',lineWidth);
                    
                end
                
                if(strcmp(get(ac(jj98719),'Type'),'text'))
                   
                    set(ac(jj98719),'FontSize',size);
                    set(ac(jj98719),'FontName',font);
                    
                end
            end
            
        end
    end
    
    set(figHandler,'Position',figDim);    
end
