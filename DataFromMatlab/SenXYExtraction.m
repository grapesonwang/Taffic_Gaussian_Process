function [Sen_XY] = SenXYExtraction(Detectors, sen_eid)
% This function is for extracting the GIS locations of the chosen sensors
X = extractfield(Detectors,'X');
Y = extractfield(Detectors,'Y');
XY = [X;Y];

all_sen_id  = extractfield(Detectors,'id');

tar_index = [];
for i = 1:1:length(sen_eid)
    pos = find(all_sen_id == sen_eid(1,i));
    tar_index = [tar_index pos];
end

Sen_XY = XY(:,tar_index);
end

