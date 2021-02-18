
dir_load      = '/Users/duochan/Data/LME_intercomparison/Miscellaneous/';
dir_save      = '/Users/duochan/Dropbox/Git_code/World-Waw-II-Warm-Anomaly/Data/';
file_load     = [dir_load,'All_earlier_SST_regridded_to_5x5_grids_20200405.mat'];
dir_ERSST4_en = '/Users/duochan/Data/Other_SSTs/ERSST4/ERSST4_EN_processed/';
dir_ERSST5_en = '/Users/duochan/Data/Other_SSTs/ERSST5/ERSST5_EN_processed/';
load(file_load,'HadSST4','HadSST4_en','HadSST3','HadSST2','HadSST3_en','ERSST5','ERSST4');
         

% =========================================================================
% HadSST4
% =========================================================================
[S.HadSST4.SST_glb,S.HadSST4.sst_var,S.HadSST4.sst_war,S.HadSST4.sst_peace] = ...
             WWIIWA_analysis_calculate_statistics(HadSST4.sst,HadSST4.time(:,1));

[S.HadSST4.SST_glb_raw,S.HadSST4.sst_var_raw,S.HadSST4.sst_war_raw,S.HadSST4.sst_peace_raw] = ...
             WWIIWA_analysis_calculate_statistics(HadSST4.sst_raw,HadSST4.time(:,1));

for en = 1:200
    if rem(en,10) == 0,   disp(['En: ',num2str(en)]);    end
    
    [S.HadSST4_en.SST_glb(:,:,en),S.HadSST4_en.sst_var(en)] = ...
             WWIIWA_analysis_calculate_statistics(HadSST4_en.sst_en(:,:,:,:,en),HadSST4.time(:,1));
end

% =========================================================================
% HadSST3
% =========================================================================
[S.HadSST3.SST_glb,S.HadSST3.sst_var,S.HadSST3.sst_war,S.HadSST3.sst_peace] = ...
             WWIIWA_analysis_calculate_statistics(HadSST3.sst,HadSST3.time(:,1));

[S.HadSST3.SST_glb_raw,S.HadSST3.sst_var_raw,S.HadSST3.sst_war_raw,S.HadSST3.sst_peace_raw] = ...
             WWIIWA_analysis_calculate_statistics(HadSST3.sst_raw,HadSST3.time(:,1));

for en = 1:100
    if rem(en,10) == 0,   disp(['En: ',num2str(en)]);    end
    
    [S.HadSST3_en.SST_glb(:,:,en),S.HadSST3_en.sst_var(en)] = ...
             WWIIWA_analysis_calculate_statistics(HadSST3_en.sst_en(:,:,:,:,en),HadSST3.time(:,1));
end

% =========================================================================
% HadSST2
% =========================================================================
[S.HadSST2.SST_glb,S.HadSST2.sst_var,S.HadSST2.sst_war,S.HadSST2.sst_peace] = ...
             WWIIWA_analysis_calculate_statistics(HadSST2.sst,HadSST2.time(:,1));

% =========================================================================
% ERSST5
% =========================================================================
ERSST5.sst     = ERSST5.sst - repmat(nanmean(ERSST5.sst(:,:,:,[1960:1990]-ERSST5.time(1)+1,:),4),1,1,1,size(ERSST5.time,1),1);
[S.ERSST5.SST_glb, S.ERSST5.sst_var, S.ERSST5.sst_war, S.ERSST5.sst_peace] = ...
         WWIIWA_analysis_calculate_statistics(ERSST5.sst,ERSST5.time(:,1));

for en = 1:1000
    
    if rem(en,100) == 0,   disp(['En: ',num2str(en)]);    end
    
    clear('ERSST_regrid')
    load([dir_ERSST5_en,'ERSST5_regrid_5X5_1854_2017_ensemble_',num2str(en),'.mat'])
    ERSST_regrid = reshape(ERSST_regrid,72,36,12,1968/12);
    
    [S.ERSST5_en.SST_glb(:,:,en),S.ERSST5_en.sst_var(en)] = ...
             WWIIWA_analysis_calculate_statistics(ERSST_regrid,1854:2017);
end

% =========================================================================
% ERSST4
% =========================================================================
ERSST4.sst     = ERSST4.sst - repmat(nanmean(ERSST4.sst(:,:,:,[1960:1990]-ERSST4.time(1)+1,:),4),1,1,1,size(ERSST4.time,1),1);
[S.ERSST4.SST_glb, S.ERSST4.SST_var, S.ERSST4.sst_war, S.ERSST4.sst_peace] = ...
         WWIIWA_analysis_calculate_statistics(ERSST4.sst,ERSST4.time(:,1));

for en = 1:1000
    
    if rem(en,100) == 0,   disp(['En: ',num2str(en)]);    end
    
    clear('ERSST_regrid')
    load([dir_ERSST4_en,'ERSST4_regrid_5X5_1854_2014_ensemble_',num2str(en),'.mat'])
    ERSST_regrid = reshape(ERSST_regrid,72,36,12,1932/12);
    
    [S.ERSST4_en.SST_glb(:,:,en),S.ERSST4_en.sst_var(en)] = ...
             WWIIWA_analysis_calculate_statistics(ERSST_regrid,1854:2014);
end

% *************************************************************************
% *************************************************************************
% *************************************************************************
clear('HadSST4','HadSST4_en','HadSST3','HadSST2','HadSST3_en',...
                                   'HadISST2','CobeSST2','ERSST5','ERSST4')
HadSST4        = S.HadSST4;
HadSST4_en     = S.HadSST4_en;
HadSST3        = S.HadSST3;
HadSST3_en     = S.HadSST3_en;
HadSST2        = S.HadSST2;
ERSST5         = S.ERSST5;
ERSST5_en      = S.ERSST5_en;
ERSST4         = S.ERSST4;
ERSST4_en      = S.ERSST4_en;

file_save      = [dir_save,'WWIIWA_statistics_for_other_SST_estimates.mat'];
save(file_save,'HadSST4','HadSST4_en','HadSST3','HadSST3_en',...
               'ERSST5','ERSST5_en','ERSST4','ERSST4_en','HadSST2','-v7.3');