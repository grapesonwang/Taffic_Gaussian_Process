augment_index = [1  3  4  6  7  8  9  ...
                 10 11 13 14 15 17 18 ...
                 19 20 21 22 24 25 26]';
 mat = Cluster_cell{1,1};
 figure
 plot_mat = mat(3:4,augment_index);
%  plot_mat(1,:) =  plot_mat(1,:) - 434000;
%  plot_mat(2,:) =  plot_mat(2,:) - 4810000;
 plot_mat(1,:) =  plot_mat(1,:) ;
 plot_mat(2,:) =  plot_mat(2,:) ;
 plot(plot_mat(1,:),plot_mat(2,:),'b.','markersize',18);
 %axis([0 max(plot_mat(1,:)) 0 max(plot_mat(2,:))]);