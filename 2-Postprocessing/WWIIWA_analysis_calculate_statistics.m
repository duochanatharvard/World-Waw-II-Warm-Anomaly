function [TS,SST_var,sst_war,sst_peace] = WWIIWA_analysis_calculate_statistics(SST,year)

    % trim data to only cover 1930--1955  ---------------------------------
    yr_target = [1930:1955];
    SST = SST(:,:,:,yr_target-year(1)+1);

    % Load masks ----------------------------------------------------------
    mask_glb  = LME_analysis_mask_trd;
    mask_mini = load('common_minimum_mask.mat');
    
    % Mask data using a minimum mask --------------------------------------
    SST(mask_mini.common_minimum_mask == 0) = nan;
    
    % Compute global mean time series ------------------------------------- 
    [TS,~,~] = CDC_mask_mean(SST,-87.5:5:90,mask_glb);

    if nargout >= 2
        
        % Compute annual mean data --------------------------------------------
        sst_ann = squeeze(nanmean(SST,3));
        num_ann = squeeze(nansum(~isnan(SST),3));
        sst_ann(num_ann < 6) = nan;

        % Compute variance on grid scale --------------------------------------
        sst_var  = squeeze(CDC_var(sst_ann(:,:,[1936:1950]-yr_target(1)+1),3)); 
        [SST_var,~,~] = CDC_mask_mean(sst_var,-87.5:5:90,mask_glb);
        
        if nargout >= 3

            % Compute WWIIWA at grid scale ---------------------------------------- 
            sst_war  = squeeze(nanmean(sst_ann(:,:,[1941:1945]-yr_target(1)+1),3));
            num_war  = squeeze(nansum(~isnan(sst_ann(:,:,[1941:1945]-yr_target(1)+1)),3));
            sst_war(num_war < 1) = nan;

            sst_peace = squeeze(nanmean(sst_ann(:,:,[1936:1940 1946:1950]-yr_target(1)+1),3));
            num_peace = squeeze(nansum(~isnan(sst_ann(:,:,[1936:1940 1946:1950]-yr_target(1)+1)),3));
            sst_peace(num_peace < 1) = nan;
        end
    end
end