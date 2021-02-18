function [ct,y_tick] = plot_time_series(pic,pic_en,col,ct,y_tick,add_width)

    if ~exist('add_width','var') 
        add_width = 0; 
    end

    linewi = 2 + add_width;
    wi_add = 2;

    pic = nanmean(pic,1);  
    pic = pic - nanmean(pic([1936:1940 1946:1950]-1929));
    
    ct = ct + 1;
    jg     = 0.6;   
    jg2    = 0.15;
    y_tick = [y_tick  [-jg2 0 jg2]-ct*jg];
    offset = ct * jg;
    
    if ~isempty(pic_en)
        pic_en = squeeze(nanmean(pic_en,1));  
        pic_en_mean = quantile(pic_en,0.5,2);
        pic_en = pic_en - repmat(nanmean(pic_en_mean([1936:1940 1946:1950]-1929),1),26,size(pic_en,2));

        P.alpha = 0.6;
        CDF_patch(1930:1955,pic_en' - offset,1 - (1 - col) * .5,0.05,P);
    end
    
    plot(1930:1955, pic - offset,'-','linewi',linewi + wi_add,'color',[1 1 1])
    plot(1930:1955, pic - offset,'-','linewi',linewi,'color',col)
end