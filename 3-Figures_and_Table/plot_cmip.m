function plot_cmip(pic,col,ct)
    jg  = 0.6;   
    pic = squeeze(nanmean(pic,1));
    pic = pic - repmat(nanmean(pic([1935:1940 1945:1950]-1929,:),1),26,1);
    plot(1930:1955,pic - jg * ct,'-','color',col);
end