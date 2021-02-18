function [group_all,col] = WWIIWA_all_groups_have_colors

    group_all = [  ...
        68    69   151     0
        68    69   192    -1
        68    69   192     0
        68    69   215     0
        68    69   720     0
        71    66   184    -1
        71    66   184     0
        71    66   203     0
        71    66   204     0
        71    66   216    -1
        71    66   245    -1
        72    79   705     0
        72    79   705     1
        74    80   118    -1
        74    80   118     0
        74    80   187    -1
        78    76   150     0
        78    76   193    -1
        78    76   193     0
        80    77   705     1
        82    85   732    -1
        82    85   735     3
        85    83   110    -1
        85    83   116    -1
        85    83   195    -1
        85    83   281    -1
        85    83   703    -1
        85    83   705    -1
        85    83   705     0
        85    83   705     1
        85    83   710    -1
        85    83   780     0
        90    65   899    -1
       155   155   155     0
       156   156   156     0
       203   203   203     0];
   
    col = find_color(group_all);
   
   
end

function col = find_color(grp_pic)

    col = zeros(size(grp_pic,1),3);
    
    l   = ismember(grp_pic(:,1:2),'DE','rows');
    col(l,:) = colormap_CD([.67 .67],[.8 .4],[0],nnz(l));

    l   = ismember(grp_pic(:,1:2),'GB','rows');
    col(l,:) = colormap_CD([0.0 0.00],[.75 .4],[0],nnz(l));

    l   = ismember(grp_pic(:,1:2),'JP','rows');
    col(l,:) = colormap_CD([.16 .16],[.8 .2],[0],nnz(l));

    l   = ismember(grp_pic(:,1:2),'NL','rows');
    col(l,:) = colormap_CD([.07 .07],[.8 .4],[0],nnz(l));

    l   = ismember(grp_pic(:,1:2),'US','rows');
    col(l,:) = [colormap_CD([0.45 0.45],[.7 .3],[0],5); colormap_CD([0.55 0.55],[.7 .3],[0],nnz(l)-5)];
    
    l   = ismember(grp_pic(:,1:2),'RU','rows');
    col(l,:) = colormap_CD([0.8 0.8],[.7 .4],[0],nnz(l));

    l   = grp_pic(:,1) > 100;
    col(l,:) = colormap_CD([0 0.95],[.7 .35],[1],nnz(l));
    
    l   = nanmean(col,2) == 0;
    col(l,:) = colormap_CD([.3 .3],[.7 .35],[0],nnz(l));

end