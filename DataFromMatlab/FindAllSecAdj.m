function [adj_Sec] = FindAllSecAdj(Sec_id,Node_id,f_node,t_node)
%--------------------------------------------------------------------------
% Function to compute the adjacency matrix
%--------------------------------------------------------------------------
% Inputs  - all inputs are row vectors
%         - Sec_id       = ID of road sections
%         - Node_id      = ID of nodes
%         - f_node       = From node of road sections
%         - t_node       = To node of road sections
%--------------------------------------------------------------------------        
% Outputs - adj_Sec      = Adjacency Matrix
%--------------------------------------------------------------------------

[Sec_row, Sec_col] = size(Sec_id);
[Node_row, Node_col] = size(Node_id);

adj_Sec = eye(Sec_col,Sec_col);

for i = 1:1:Sec_col
    current_to = t_node(1,i);
    current_from = f_node(1,i);
%    if current_from ~= NaN & current_to ~= NaN & current_from ~= current_to
    if ((current_to ~= NaN) & (current_from ~= current_to))
        sim_from = find(current_to == f_node);
        for j = 1:1:length(sim_from)
            finer_from = f_node(1,sim_from(1,j));
            finer_to = t_node(1,sim_from(1,j));
            if ((finer_to == current_from)&(finer_from == current_to)) | ...
               ((finer_from == finer_to))    
                sim_from(1,j) = i;
            end
        end
        adj_Sec(i,sim_from) = 1;
    elseif ((current_from ~= NaN) & (current_to == NaN))
        adj_Sec(i,i) = 1;
%        sim_to = find(current_from == t_node);
%        adj_Sec(sim_to,i) = 1;
%     elseif current_from == NaN & current_to ~= NaN
%         sim_from = find(current_to == f_node);
%         adj_Sec(i,sim_from) = 1;
    end
end


% G = digraph(f_node, t_node);
% A = adjacency(G);
end


