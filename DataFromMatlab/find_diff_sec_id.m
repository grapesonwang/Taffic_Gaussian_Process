sec_id_from_obsrv = xlsread('C:/Users/uos/Documents/Gaussian_Process/DataFromMatlab/section_id_vs_ID/sec_id_from_obsrv.xlsx','A1:KG1');
sen_id_from_obsrv = xlsread('C:/Users/uos/Documents/Gaussian_Process/DataFromMatlab/section_id_vs_ID/sen_id_from_obsrv.xlsx','A1:KG1');


obsrv_index_id = [];
pos_obsrv_index_id = [];
for i=1:1:length(sec_id_from_obsrv)
    pos = find(sec_id == sec_id_from_obsrv(1,i));
    if isempty(pos)
        obsrv_index_id = [obsrv_index_id,sec_id_from_obsrv(1,i)];
        pos_obsrv_index_id = [pos_obsrv_index_id, i];
    end
end
obsrv_index_id

obsrv_sen_id = [];
for i=1:1:length(sen_id_from_obsrv)
    pos = find(SenIDs == sen_id_from_obsrv(1,i));
    if isempty(pos)
        obsrv_sen_id = [obsrv_sen_id,sen_id_from_obsrv(1,i)];
    end
end
obsrv_sen_id

index_sen_id = [];
pos_index_sec_id = [];
for i=1:1:length(sen_id)
    pos = find(SenIDs == sen_id(1,i));
    if isempty(pos)
        index_sen_id = [index_sen_id,sen_id(1,i)];
        pos_index_sec_id = [pos_index_sec_id,i];
    end
end
index_sen_id

pos_index_sec_id
pos_obsrv_index_id