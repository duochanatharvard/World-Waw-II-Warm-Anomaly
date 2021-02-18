if ~strcmp(computer,'MACI64')
    addpath(genpath(pwd));
    addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Computation/')
    addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Figures/')
    addpath('/n/home10/dchan/script/Peter/Hvd_SST/Code_Homo_early_20cent_warming/Function/')
    addpath('/n/home10/dchan/script/Peter/Hvd_SST/DIURNAL_cycles/')
    addpath('/n/home10/dchan/Matlab_Tool_Box/m_map/')
end

dir_home  = '/n/home10/dchan/holy_kuang/LME_intercomparison/';
% Change this line to what where data are stored

% =========================================================================
% Day + Night time analysis: Generate for R1--4
% =========================================================================
dir_idv   = [dir_home,'Step_05_Idv_Corr_v17/'];
dir_rnd   = [dir_home,'Step_06_Rnd_Corr_v17/'];
app       = 'Ship_vs_Ship_all_measurements_1850_2014_Full_SST_Merge_Season';

% Compute for full corrections --------------------------------------------
disp('Compute full SST')
file = [dir_idv,'Corr_idv_ship_en_0_',app,'.mat'];
full = load(file,'WM');

[Full.SST_glb_raw,Full.sst_var_raw,Full.sst_war_raw,Full.sst_peace_raw] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(full.WM(:,:,1,:,:)),[1850:2014]);

[Full.SST_glb_adj,Full.sst_var_adj,Full.sst_war_adj,Full.sst_peace_adj] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(full.WM(:,:,2,:,:)),[1850:2014]);

% Compute for bucket only analysis ----------------------------------------
disp('Compute Bucket-only SSTs')
file = [dir_idv,'Corr_idv_method_0_en_0_',app,'.mat'];
bck  = load(file,'WM');

[Bucket.SST_glb_raw,Bucket.sst_var_raw,Bucket.sst_war_raw,Bucket.sst_peace_raw] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(bck.WM(:,:,1,:,:)),[1850:2014]);

[Bucket.SST_glb_adj,Bucket.sst_var_adj,Bucket.sst_war_adj,Bucket.sst_peace_adj] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(bck.WM(:,:,2,:,:)),[1850:2014]);

% Compute for ERI only analysis -------------------------------------------
disp('Compute ERI-only SSTs')
file = [dir_idv,'Corr_idv_method_1_en_0_',app,'_infer_US.mat'];
eri  = load(file,'WM');

[ERI.SST_glb_raw,ERI.sst_var_raw,ERI.sst_war_raw,ERI.sst_peace_raw] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(eri.WM(:,:,1,:,:)),[1850:2014]);

[ERI.SST_glb_adj,ERI.sst_var_adj,ERI.sst_war_adj,ERI.sst_peace_adj] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(eri.WM(:,:,2,:,:)),[1850:2014]);

% Compute for differences -------------------------------------------------
disp('Compute ERI-only SSTs')
Dif_Bucket_ERI.SST_glb_raw = WWIIWA_analysis_calculate_statistics...
                (squeeze(eri.WM(:,:,1,:,:)-bck.WM(:,:,1,:,:)),[1850:2014]);

Dif_Bucket_ERI.SST_glb_adj = WWIIWA_analysis_calculate_statistics...
                (squeeze(eri.WM(:,:,2,:,:)-bck.WM(:,:,2,:,:)),[1850:2014]);
            
clear('full','bck','eri')

% Compute for individual corrections --------------------------------------
disp('Compute Full SSTs individual groups')
file = [dir_home,'Step_XX_Download_v17/LME_offsets_seasonality_over_regions_SST_pairs.mat'];
load(file);
IDV.groups = lme_season.unique_grp;
for ct_en = 1:540

    try
        if rem(ct_en,50) == 0
            disp(['Starting the ',num2str(ct_en),' member']);
        end

        file = [dir_idv,'Corr_idv_ship_en_',num2str(ct_en),'_',app,'.mat'];
        clear('idv');        idv = load(file,'WM');
        IDV.SST_glb_adj(:,:,ct_en) = WWIIWA_analysis_calculate_statistics(idv.WM,[1850:2014]);
        
    catch
        disp(['Ensemble member ',num2str(ct_en),' is not working'])
    end
end

% Compute for random corrections ------------------------------------------
disp('Compute Full SSTs randomized corrections')
for ct_en = 1:1000

    if rem(ct_en,50) == 0
        disp(['Starting the ',num2str(ct_en),' member']);
    end

    file = [dir_rnd,'Corr_rnd_ship_en_',num2str(ct_en),'_',app,'.mat'];
    clear('rnd');    rnd = load(file,'WM');
    [RND.SST_glb_adj(:,:,ct_en),RND.sst_var_adj(ct_en)] = WWIIWA_analysis_calculate_statistics(rnd.WM,[1850:2014]);

    file = [dir_rnd,'Corr_rnd_method_0_en_',num2str(ct_en),'_',app,'.mat'];
    clear('rnd');    rnd = load(file,'WM');
    [RND_bck.SST_glb_adj(:,:,ct_en),RND_bck.sst_var_adj(ct_en)] = WWIIWA_analysis_calculate_statistics(rnd.WM,[1850:2014]);

    file = [dir_rnd,'Corr_rnd_method_1_en_',num2str(ct_en),'_',app,'_infer_US.mat'];
    clear('rnd');    rnd = load(file,'WM');
    [RND_eri.SST_glb_adj(:,:,ct_en),RND_eri.sst_var_adj(ct_en)] = WWIIWA_analysis_calculate_statistics(rnd.WM,[1850:2014]);    
end


% =========================================================================
% Daytime only analysis: Generate for R5
% =========================================================================
dir_idv   = [dir_home,'Step_05_Idv_Corr/'];
dir_rnd   = [dir_home,'Step_06_Rnd_Corr/'];
app       = 'Ship_vs_Ship_day_measurements_1850_2014_Full_SST_Merge_Season';

% Compute for full corrections --------------------------------------------
disp('Compute full SST day only')
file = [dir_idv,'Corr_idv_ship_en_0_',app,'.mat'];
full = load(file,'WM');

[Full_day.SST_glb_raw,Full_day.sst_var_raw,Full_day.sst_war_raw,Full_day.sst_peace_raw] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(full.WM(:,:,1,:,:)),[1850:2014]);

[Full_day.SST_glb_adj,Full_day.sst_var_adj,Full_day.sst_war_adj,Full_day.sst_peace_adj] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(full.WM(:,:,2,:,:)),[1850:2014]);

% Compute for bucket only analysis ----------------------------------------
disp('Compute Bucket-only SSTs day only')
file = [dir_idv,'Corr_idv_method_0_en_0_',app,'_bucket_no_infer.mat'];
bck  = load(file,'WM');

[Bucket_day.SST_glb_raw,Bucket_day.sst_var_raw,Bucket_day.sst_war_raw,Bucket_day.sst_peace_raw] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(bck.WM(:,:,1,:,:)),[1850:2014]);

[Bucket_day.SST_glb_adj,Bucket_day.sst_var_adj,Bucket_day.sst_war_adj,Bucket_day.sst_peace_adj] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(bck.WM(:,:,2,:,:)),[1850:2014]);

% Compute for ERI only analysis -------------------------------------------
disp('Compute ERI-only SSTs day only')
file = [dir_idv,'Corr_idv_method_1_en_0_',app,'_ERI_infer_US.mat'];
eri  = load(file,'WM');

[ERI_day.SST_glb_raw,ERI_day.sst_var_raw,ERI_day.sst_war_raw,ERI_day.sst_peace_raw] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(eri.WM(:,:,1,:,:)),[1850:2014]);

[ERI_day.SST_glb_adj,ERI_day.sst_var_adj,ERI_day.sst_war_adj,ERI_day.sst_peace_adj] = ...
    WWIIWA_analysis_calculate_statistics(squeeze(eri.WM(:,:,2,:,:)),[1850:2014]);

% Compute for differences -------------------------------------------------
disp('Compute ERI-only SSTs day only')
Dif_Bucket_ERI_day.SST_glb_raw = WWIIWA_analysis_calculate_statistics...
                (squeeze(eri.WM(:,:,1,:,:)-bck.WM(:,:,1,:,:)),[1850:2014]);

Dif_Bucket_ERI_day.SST_glb_adj = WWIIWA_analysis_calculate_statistics...
                (squeeze(eri.WM(:,:,2,:,:)-bck.WM(:,:,2,:,:)),[1850:2014]);


% Compute for individual corrections --------------------------------------
disp('Compute Full SSTs individual groups day only')
file = [dir_home,'Step_XX_Download/LME_offsets_seasonality_over_regions_SST_pairs_day.mat'];
load(file);
IDV_day.groups = lme_season.unique_grp;
for ct_en = 1:505

    try
        if rem(ct_en,50) == 0
            disp(['Starting the ',num2str(ct_en),' member']);
        end

        file = [dir_idv,'Corr_idv_ship_en_',num2str(ct_en),'_',app,'.mat'];
        clear('idv');        idv = load(file,'WM');
        IDV_day.SST_glb_adj(:,:,ct_en) = WWIIWA_analysis_calculate_statistics(idv.WM,[1850:2014]);
        
    catch
        disp(['Ensemble member ',num2str(ct_en),' is not working'])
    end
end

% Compute for random corrections ------------------------------------------
disp('Compute Full SSTs randomized corrections day only')
for ct_en = 1:1000

    if rem(ct_en,50) == 0
        disp(['Starting the ',num2str(ct_en),' member']);
    end

    file = [dir_rnd,'Corr_rnd_ship_en_',num2str(ct_en),'_',app,'.mat'];
    clear('rnd');    rnd = load(file,'WM');
    [RND_day.SST_glb_adj(:,:,ct_en),RND_day.sst_var_adj(ct_en)] = WWIIWA_analysis_calculate_statistics(rnd.WM,[1850:2014]);

    file = [dir_rnd,'Corr_rnd_method_0_en_',num2str(ct_en),'_',app,'_bucket_no_infer.mat'];
    clear('rnd');    rnd = load(file,'WM');
    [RND_bck_day.SST_glb_adj(:,:,ct_en),RND_bck_day.sst_var_adj(ct_en)] = WWIIWA_analysis_calculate_statistics(rnd.WM,[1850:2014]);

    file = [dir_rnd,'Corr_rnd_method_1_en_',num2str(ct_en),'_',app,'_ERI_infer_US.mat'];
    clear('rnd');    rnd = load(file,'WM');
    [RND_eri_day.SST_glb_adj(:,:,ct_en),RND_eri_day.sst_var_adj(ct_en)] = WWIIWA_analysis_calculate_statistics(rnd.WM,[1850:2014]);    
end


% =========================================================================
% Nighttime only analysis
% =========================================================================
dir_idv   = [dir_home,'Step_05_Idv_Corr/'];
dir_rnd   = [dir_home,'Step_06_Rnd_Corr/'];
app       = 'Ship_vs_Ship_night_measurements_1850_2014_Full_SST_Merge_Season';

% Compute for bucket only analysis ----------------------------------------
disp('Compute Bucket-only SSTs')
file = [dir_idv,'Corr_idv_method_0_en_0_',app,'_bucket_no_infer.mat'];
bck  = load(file,'WM');

Bucket_night.SST_glb_raw = WWIIWA_analysis_calculate_statistics(squeeze(bck.WM(:,:,1,:,:)),[1850:2014]);

% Compute for ERI only analysis -------------------------------------------
disp('Compute ERI-only SSTs')
file = [dir_idv,'Corr_idv_method_1_en_0_',app,'_ERI_infer_US.mat'];
eri  = load(file,'WM');

ERI_night.SST_glb_raw = WWIIWA_analysis_calculate_statistics(squeeze(eri.WM(:,:,1,:,:)),[1850:2014]);

% =========================================================================
% Save data
% =========================================================================
file = [dir_home,'WWIIWA_statistics_for_ICOADS_raw_and_group_adjusted.mat'];
save(file,'Full','Bucket','ERI','Dif_Bucket_ERI','IDV','RND','RND_bck','RND_eri',...
    'Full_day','Bucket_day','ERI_day','Dif_Bucket_ERI_day','IDV_day','RND_day',...
    'RND_bck_day','RND_eri_day','Bucket_night','ERI_night','-v7.3');