function rfd2mat(fileName)
%Converts a rfd file specified in "fileName" to a mat file with 
%the same name and at the same directory. The events in the file are
%represented by a structure.
%
%The structure is organized as follows:
%   str.RoI_Id = ROI number.
%   str.LVL1_Eta = Eta position highlighted by LVL1.
%   str.LVL1_Phi = Phi position highlighted by LVL1.
%   str.LVL1_Id = LVL1 run event id.
%   str.DetCells = Layer id of each cell.
%   str.EtaCells = eta of each cell
%   str.PhiCells = phi of each cell
%   str.ECells = energy of each cell.
%
%The 8 columns in vector data are the parameters of each cell from a given
%detector. These parameters are (in order).
%   1) 
%   2) Eta
%   3) Phi
%   4) Distance from the detector center.
%   5) Cell's size in eta.
%   6) Cell's size in phi.
%   7) Cell's size in radius direction.
%   8) Cell's energy
%

%Event Token.
token = 'RoI';
Ntoken = length(token);
id_roi = 4;
id_eta = 9;
id_phi = 14;
id_lvl1 = 22;

events = [];
init = 1;

%Opening the file.
arq = fopen(fileName, 'r');
if (arq == -1), 
    error(sprintf('Impossible to open file %s!\n', fileName));
end

while (feof(arq) ~= 1),
    %Getting the next line
    line = fgetl(arq);

    %If true, its a new event.
    if (strcmp(line(1:Ntoken), token) == 1),

        %If it is the first event of all, it is not saved, since the
        %struct is still empty.
        if (init ~= 1),
            events = [events; aux_str];
            clear aux_str;
        end

        %Allowing now the structs to be saved.
        init = 0;

        %Geting the header information
        aux = sscanf(line, '%s %d %s %f %s %f %s %s %d', inf);
        aux_str.RoI_Id = aux(id_roi);
        aux_str.LVL1_Eta = aux(id_eta);
        aux_str.LVL1_Phi = aux(id_phi);
        aux_str.LVL1_ID = aux(id_lvl1);
        aux_str.DetCells = [];
        aux_str.EtaCells = [];
        aux_str.PhiCells = [];
        aux_str.ECells = [];
    else
        %Geting the data
        aux = sscanf(line, '%f,', inf);            
        aux_str.DetCells = [aux_str.DetCells aux(1)];
        aux_str.EtaCells = [aux_str.EtaCells aux(2)];
        aux_str.PhiCells = [aux_str.PhiCells aux(3)];
        aux_str.ECells = [aux_str.ECells aux(8)];
    end
end

fclose(arq);

%Saving the last event of all. This if is still necessary, since all the
%files can be empty, by some unknown reason.
if (init ~= 1),
    events = [events; aux_str];
    clear aux_str;
end

%Saving the new mat file.
outFileName = sprintf('%s.mat', fileName(1:(end-4)));
save(outFileName, 'events');
