function jump = get_jump(SST)

    temp = squeeze(nanmean(SST,1));
    
    if size(temp,1) == 1
        jump = nanmean(temp([6:10])) - nanmean(temp([1:5 11:15]));
    else
        jump = nanmean(temp([6:10],:),1) - nanmean(temp([1:5 11:15],:),1);
    end

end