% This mask is based on where 1908-1941 SST has value in trend
function mask = LME_analysis_mask_trd

    if 0

        a = squeeze(WM(:,:,1,:,:));
        b = squeeze(nansum(~isnan(a),3) >= 6);
        mask = nansum(b(:,:,[1850:1940]-1849),3) > 20;
        
        mask_land = CDF_land_mask(5,1,5,0)';
        mask(mask_land) = 0;

    else
        
        mask_1 = [
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     0
         0     0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     0     0
         0     0     0     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0
         0     0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     0     0
         0     0     0     0     0     0     0     0     0     0     1     1     1     0     0     0     0     0
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     0     0     0
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     0     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     0     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     0     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     0     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     0     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     0     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     0     1     1
         0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     0
         0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     0     1     1
         0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     0     1     0
         0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     0     1     1
         0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     0     1     1
         0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     1     1     0
         0     0     0     0     0     0     0     0     0     0     1     0     0     0     0     1     0     0
         0     0     0     0     0     0     0     0     0     1     0     0     0     0     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     0     0
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     0     0     0
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     0     0     0     0
         0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     0     0     0
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     0     0
         0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1     0
         0     0     0     0     0     0     0     0     1     1     1     1     0     1     0     1     1     1
         0     0     0     0     0     0     0     0     1     1     1     1     1     0     0     1     1     1
         0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     1     1     1     1     0     0     1     0     1     1     0
         0     0     0     0     0     0     0     1     1     1     0     1     1     0     1     0     0     0
         0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     1     0     0
         0     0     0     0     0     0     0     1     0     0     0     1     1     0     0     0     0     0
         0     0     0     0     0     0     0     1     0     0     1     1     1     1     0     0     0     0
         0     0     0     0     0     0     0     0     0     0     0     1     1     1     1     0     0     0
         0     0     0     0     0     0     0     1     0     0     0     1     1     1     1     0     1     0
         0     0     0     0     0     0     0     1     0     0     0     1     1     1     1     0     0     0
         0     0     0     0     0     0     0     1     0     0     0     0     1     1     1     0     0     0
         0     0     0     0     0     0     0     1     0     0     0     0     0     1     1     1     0     0
         0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1
         0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1
         0     0     0     0     0     0     0     1     0     0     0     0     0     0     0     0     1     1
         0     0     0     0     0     0     1     1     0     0     0     0     0     0     0     0     1     1
         0     0     0     0     0     0     1     1     1     1     1     0     1     1     1     1     0     0
         0     0     0     0     0     0     1     1     0     0     1     1     1     1     1     0     0     0
         0     0     0     0     0     0     1     1     0     0     0     0     0     0     0     0     0     0
         0     0     0     0     0     0     1     1     1     1     0     0     0     0     0     0     0     0
         0     0     0     0     0     0     0     1     1     1     1     0     0     0     0     0     0     0
         0     0     0     0     0     0     0     1     1     1     1     1     0     0     0     0     0     0
         0     0     0     0     0     0     0     0     0     1     1     1     1     0     0     0     0     0
         0     0     0     0     0     0     0     0     0     1     1     1     1     1     0     0     0     1
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     0     1
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     1     1     1     0     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     1     1     0     0     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     1     1     0     1     1     1     1     1
         0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1];

        mask_2 = [
         1     1     0     0     0     0     0     1     1     0     1     1     1     0     0     0     0     0
         1     0     0     0     0     0     0     1     1     0     0     0     0     1     0     0     0     0
         0     0     0     0     0     0     0     1     1     0     0     0     0     1     0     0     0     0
         0     0     0     0     0     0     1     1     0     0     0     1     0     0     0     0     0     0
         0     0     0     0     0     0     1     1     0     0     0     1     0     0     0     0     0     0
         0     0     0     0     0     0     1     1     1     0     0     0     0     0     0     0     0     0
         0     0     0     0     0     0     1     0     1     0     0     0     0     0     0     0     0     0
         0     0     0     0     1     0     0     0     1     0     0     0     0     0     0     0     0     0
         0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     0     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         0     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         0     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0     0     0
         0     1     1     0     1     1     1     1     1     0     0     0     0     0     0     0     0     0
         0     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0     0
         0     1     0     0     1     1     1     1     1     1     0     0     0     0     0     0     0     0
         1     1     0     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0
         0     1     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     1     0     0     0     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     1     0     0     0     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     0     0     0     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     0     0     0     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     0     0     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         1     0     0     0     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         1     1     1     0     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         1     1     1     1     1     0     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     0     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     1     0     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         0     0     0     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0
         0     0     0     1     0     1     1     1     0     0     0     0     0     0     0     0     0     0
         0     0     0     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0
         0     0     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     0     1     1     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     0     1     1     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0
         1     1     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0
         0     1     1     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0
         0     0     1     1     1     1     1     1     0     0     0     0     0     0     0     0     0     0
         0     0     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0     0
         0     0     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0
         0     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0     0
         0     1     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     1     1     1     1     0     0     0     0     0     0
         1     1     1     1     1     1     1     1     1     1     1     1     1     1     0     0     0     0
         1     1     1     1     1     1     1     1     1     1     1     1     1     1     0     0     0     0
         1     1     0     0     0     1     1     1     1     1     1     1     1     1     0     0     0     0
         1     0     0     0     0     0     0     1     1     1     1     1     1     0     0     0     0     0
         1     0     0     0     0     0     0     1     0     1     0     0     1     0     0     0     0     0];
        mask = [mask_1 mask_2];
        
    end
end