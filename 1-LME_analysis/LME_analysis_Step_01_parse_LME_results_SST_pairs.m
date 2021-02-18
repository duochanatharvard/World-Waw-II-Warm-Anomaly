
dir_load  = [LME_OI('home'),'Step_04_LME_output/'];
dir_save  = [LME_OI('home'),'Step_XX_Download/'];
if ~exist('do_day','var')
    app       = 'Ship_vs_Ship_all_measurements_1850_2014_Full_SST_mon';
else
    if do_day == 1
        app       = 'Ship_vs_Ship_day_measurements_1850_2014_Full_SST_mon';
    else
        app       = 'Ship_vs_Ship_night_measurements_1850_2014_Full_SST_mon';
    end
end
mon_abb = 'JFMAMJJASOND';

clear('lme_sum')
for ct = 1:12

    li = [ct-1 ct ct+1];  li(li<1) = li(li<1) + 12;  li(li>12) = li(li>12) - 12;
    file_load = [dir_load,'LME_',app,'_',mon_abb(li),'.mat'];
    disp(file_load)
    clear('out','out_rnd')
    load(file_load,'out','out_rnd')

    % ************************************************************************
    % Set Parameters
    % ************************************************************************
    clear('test_mean','test_random')
    NY = size(out.bias_decade,1);
    for i =  1:5
        out.bias_decade_annual(i:5:NY*5,:)           = out.bias_decade;
        out_rnd.bias_decade_rnd_annual(i:5:NY*5,:,:) = out_rnd.bias_decade_rnd;
    end
    lme_sum.bias_decade{ct}     = out.bias_decade_annual;
    lme_sum.bias_decade_rnd{ct} = out_rnd.bias_decade_rnd_annual;
    lme_sum.bias_decade{ct}(end+1:165,:) = nan;
    lme_sum.bias_decade_rnd{ct}(end+1:165,:,:) = nan;

    N_group(ct) = size(out.unique_grp,1);
    N_rnd(ct)   = size(out_rnd.bias_fixed_random,1);

    lme_sum.fixed_mean{ct}         = repmat(out.bias_fixed,1,165)';
    lme_sum.test{ct}               = lme_sum.fixed_mean{ct} + lme_sum.bias_decade{ct};
    lme_sum.bias_fixed_random{ct}  = out_rnd.bias_fixed_random;
    lme_sum.bias_fixed{ct}         = out.bias_fixed;
    lme_sum.bias_fixed_std{ct}     = out.bias_fixed_std;
    lme_sum.bias_region{ct}        = out.bias_region;
    lme_sum.bias_region_rnd{ct}    = out_rnd.bias_region_rnd;  
    % lme_sum.bias_global{ct}        = out.bias_fixed_global;
    % lme_sum.bias_global_rnd{ct}    = out_rnd.bias_global_rnd;
    lme_sum.unique_grp{ct}         = out.unique_grp;

end

if ~exist('do_day','var')
    file_save = [dir_save,'LME_offsets_merged_from_12_seasonal_analyses_SST_pairs.mat'];
else
    if do_day == 1
        file_save = [dir_save,'LME_offsets_merged_from_12_seasonal_analyses_SST_pairs_day.mat'];
    else
        file_save = [dir_save,'LME_offsets_merged_from_12_seasonal_analyses_SST_pairs_night.mat'];
    end
end
save(file_save,'lme_sum','N_group','N_rnd','-v7.3')

% -------------------------------------------------------------------------
clear('lme_season')
ref_id = 8;
lme_season.unique_grp = lme_sum.unique_grp{ref_id};
N_grp = size(lme_sum.unique_grp{ref_id},1);
lme_season.bias_fixed = nan(N_grp,12);
lme_season.bias_fixed_random = nan(1000,N_grp,12);
lme_season.bias_region = nan(N_grp,12,5);
lme_season.bias_region_rnd = nan(1000,N_grp,12,5);
lme_season.bias_region_total = nan(N_grp,12,5);
lme_season.bias_region_rnd_total = nan(1000,N_grp,12,5);
for ct = 1:12

    l_grp = ismember(lme_sum.unique_grp{ref_id},lme_sum.unique_grp{ct},'rows');

    disp(num2str(ct))
    lme_season.bias_fixed(l_grp,ct)          = lme_sum.bias_fixed{ct};
    lme_season.bias_fixed_random(:,l_grp,ct) = lme_sum.bias_fixed_random{ct};

    % compute regional average cycles
    for ct_reg = 1:5
        switch ct_reg
            case 1
                l_reg = [1 2 3];
            case 2
                l_reg = [4 5];
            case 3
                l_reg = [7 8 9 10 11];
            case 4
                l_reg = [12 13];
            case 5
                l_reg = [14];
        end

        temp     = lme_sum.bias_region{ct}(l_reg,:);
        temp_std = CDC_std(lme_sum.bias_region_rnd{ct}(l_reg,:,:),3);

        w        = 1./(temp_std).^2;
        m        = nansum(temp.*w,1) ./ nansum(w,1);
        % m        = m - nanmean(m);

        temp     = lme_sum.bias_region_rnd{ct}(l_reg,:,:);

        w_rnd    = repmat(w,1,1,1000);
        m_rnd    = nansum(temp.*w_rnd,1) ./ nansum(w_rnd,1);        
        % m_rnd    = m_rnd - repmat(nanmean(m_rnd,2),1,513,1);   

        lme_season.bias_region(l_grp,ct,ct_reg) = m';
        lme_season.bias_region_rnd(:,l_grp,ct,ct_reg) = squeeze(m_rnd)';

        lme_season.bias_region_total(l_grp,ct,ct_reg) = lme_sum.bias_fixed{ct} + m';
        lme_season.bias_region_total_rnd(:,l_grp,ct,ct_reg) = lme_sum.bias_fixed_random{ct} + squeeze(m_rnd)';
    end
end

if ~exist('do_day','var')
    file_save = [dir_save,'LME_offsets_seasonality_over_regions_SST_pairs.mat'];
else
    if do_day == 1
        file_save = [dir_save,'LME_offsets_seasonality_over_regions_SST_pairs_day.mat'];
    else
        file_save = [dir_save,'LME_offsets_seasonality_over_regions_SST_pairs_night.mat'];
    end
end
save(file_save,'lme_season','-v7.3')
