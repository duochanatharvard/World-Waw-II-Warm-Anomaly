function plot_time_series_three_way(pic,pic_bck,pic_eri)

    linewi = 2;
    wi_add = 2;

    pic = nanmean(pic,1);  
    pic_offset = nanmean(pic([1936:1940 1946:1950]-1929));

    pic_bck = nanmean(pic_bck,1);  
    pic_bck = pic_bck - pic_offset;

    pic_eri = nanmean(pic_eri,1);  
    pic_eri = pic_eri - pic_offset;
    
    plot(1930:1955, pic_bck,'-','linewi',linewi + wi_add,'color',[1 1 1])
    plot(1930:1955, pic_bck,'-','linewi',linewi,'color',[0 .2 .8])

    plot(1930:1955, pic_eri,'--','linewi',linewi + wi_add,'color',[1 1 1])
    plot(1930:1955, pic_eri,'--','linewi',linewi,'color',[.8 0 0])
    pic_eri([1942:1955]-1929) = nan;
    plot(1930:1955, pic_eri,'-','linewi',linewi,'color',[.8 0 0])
end