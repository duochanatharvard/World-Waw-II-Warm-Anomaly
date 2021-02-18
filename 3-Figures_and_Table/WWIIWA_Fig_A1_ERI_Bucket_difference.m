clear;

dir_data = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
% dir_lme = '/Users/duochan/Data/LME_intercomparison/Step_XX_Download_v17/';
% load([dir_lme,'LME_offsets_merged_from_12_seasonal_analyses_SST_pairs.mat']);
load([dir_data,'LME_groups_3-month_analysis.mat']);
load([dir_data,'LME_offsets_seasonality_over_regions_SST_pairs.mat']);

N_stats = load([dir_data,'Stats_All_ships_groupwise_global_analysis.mat']);

% =========================================================================
% Analysis starts - subset groups in the target period
% =========================================================================
clear('l')
group_name = [];
yr_list = [1850:2014];
% yr_list = [1935:1949];
% yr_list = [1950:2014];

N = squeeze(nansum(nansum(N_stats.Stats_glb(yr_list-1849,:,:),2),1));      % weight
% for ct = 1:12
%     l{ct} = any(~isnan((lme_sum.bias_decade{ct}(yr_list-1849,:))),1);
%     group_name = [group_name; lme_sum.unique_grp{ct}(l{ct},:)];
% end
for ct = 1:12
    l{ct} = any(lme_is_decade{ct}(yr_list-1849,:)==1,1);
    group_name = [group_name; lme_group{ct}(l{ct},:)];
end
group_war = unique(group_name,'rows');
group_war_eri = group_war(group_war(:,4) == 1 | (group_war(:,4) == -1 & ...
                                ismember(group_war(:,1:2),'US','rows')),:);
group_war_bck = group_war(group_war(:,4) == 0,:);

% ========================================================================
% Calculate their mean offsets for bucket and ERI groups
% Weighted by the total number of pairs in each group
% =========================================================================
clear('B_reg_bck','B_reg_eri')
l_bck     = ismember(lme_season.unique_grp,group_war_bck,'rows');
l_eri     = ismember(lme_season.unique_grp,group_war_eri,'rows'); 

for ct_mon = 1:12
    
    temp = squeeze(lme_season.bias_region_total(:,ct_mon,:));  
    
    % compute for bucket groups
    temp_bck = temp(l_bck,:);
    N_bck    = repmat(N(l_bck),1,5);
    l_rm     = any(isnan(temp_bck),2);
    temp_bck(l_rm,:) = [];
    N_bck(l_rm,:)    = [];  
    B_reg_bck(:,ct_mon) = nansum(temp_bck .* N_bck,1) ./ nansum(1 .* N_bck,1);
    

    % compute for ERI groups
    temp_eri = temp(l_eri,:);
    N_eri    = repmat(N(l_eri),1,5);
    l_rm     = any(isnan(temp_bck),2);
    temp_eri(l_rm,:) = [];
    N_eri(l_rm,:)    = [];  
    B_reg_eri(:,ct_mon) = nansum(temp_eri .* N_eri,1) ./ nansum(1 .* N_eri,1);
end

dif = B_reg_eri([2 1 3 4 5],:) - B_reg_bck([2 1 3 4 5],:);

% =========================================================================
% Fig S3: ERI - Bucket Difference
% =========================================================================
figure(131); clf; hold on
CDF_pcolor(dif(end:-1:1,:)');
caxis([-1 1]*.4);
b2rCD(12);

CDF_panel([0.5 12.5 0.5 5.5],'','','','',...
                        'bartit','ERI-Bucket (^oC)','barloc','eastoutside')

% =========================================================================
% dir_save  = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/';
% file_save = [dir_save,'Fig.S3_ERI-bucket.png'];
% CDF_save(1,'png',300,file_save);