clear;

dir_data = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
load([dir_data,'WWIIWA_statistics_for_ICOADS_raw_and_group_adjusted.mat']);
load([dir_data,'WWIIWA_statistics_for_other_SST_estimates.mat']);
load([dir_data,'WWIIWA_statistics_for_CMIP5_piControl_runs.mat']);
load([dir_data,'WWIIWA_statistics_for_CMIP6_piControl_runs.mat']);
load([dir_data,'WWIIWA_statistics_for_CMIP5_historical_runs.mat']);
load([dir_data,'WWIIWA_statistics_for_CMIP6_historical_runs.mat']);
cowtan = load([dir_data,'hybrid_36m.temp']);
cowtan = reshape(cowtan(1:1980,2),12,165);

% =========================================================================
% Mean estimates in Table 1
% =========================================================================

yr_war   = 1941:1945;
yr_peace = [1936:1940 1946:1950];
yr_use   = 1936:1950;
yr0      = 1929;

% R1
ct = 1;
Tab(ct,1) = nanmean(nanmean(Full.SST_glb_raw(:,yr_war - yr0),2) - nanmean(Full.SST_glb_raw(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(Full.SST_glb_raw(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(Full.sst_var_raw);

% R2
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(Bucket.SST_glb_raw(:,yr_war - yr0),2) - nanmean(Bucket.SST_glb_raw(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(Bucket.SST_glb_raw(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(Bucket.sst_var_raw);

% R3
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(ERI.SST_glb_raw(:,yr_war - yr0),2) - nanmean(ERI.SST_glb_raw(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(ERI.SST_glb_raw(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(ERI.sst_var_raw);

% R4
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(Full.SST_glb_adj(:,yr_war - yr0),2) - nanmean(Full.SST_glb_adj(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(Full.SST_glb_adj(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(Full.sst_var_adj);

% R5
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(Full_day.SST_glb_adj(:,yr_war - yr0),2) - nanmean(Full_day.SST_glb_adj(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(Full_day.SST_glb_adj(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(Full_day.sst_var_adj);

% ERSST4
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(ERSST4.SST_glb(:,yr_war - yr0),2) - nanmean(ERSST4.SST_glb(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(ERSST4.SST_glb(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(ERSST4.SST_var);

% ERSST5
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(ERSST5.SST_glb(:,yr_war - yr0),2) - nanmean(ERSST5.SST_glb(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(ERSST5.SST_glb(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(ERSST5.sst_var);

% HadSST2
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(HadSST2.SST_glb(:,yr_war - yr0),2) - nanmean(HadSST2.SST_glb(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(HadSST2.SST_glb(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(HadSST2.sst_var);

% HadSST3
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(HadSST3.SST_glb(:,yr_war - yr0),2) - nanmean(HadSST3.SST_glb(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(HadSST3.SST_glb(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(HadSST3.sst_var);

% HadSST4
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(HadSST4.SST_glb(:,yr_war - yr0),2) - nanmean(HadSST4.SST_glb(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(HadSST4.SST_glb(:,yr_use - yr0),1));
Tab(ct,3) = sqrt(HadSST4.sst_var);

% Cowtan SST
ct = ct + 1;
cowtan = cowtan(:,[1930:1955]-1849);
Tab(ct,1) = nanmean(nanmean(cowtan(:,yr_war - yr0),2) - nanmean(cowtan(:,yr_peace - yr0),2));
Tab(ct,2) = CDC_std(nanmean(cowtan(:,yr_use - yr0),1));
Tab(ct,3) = nan;

% CMIP5 historical
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(nanmean(CMIP5_hist.SST_glb(:,yr_war - yr0,:),3),2) - nanmean(nanmean(CMIP5_hist.SST_glb(:,yr_peace - yr0,:),3),2));
Tab(ct,2) = sqrt(nanmean(CDC_var(nanmean(CMIP5_hist.SST_glb(:,yr_war - yr0,:),1))));
Tab(ct,3) = sqrt(nanmean(CMIP5_hist.sst_var));

% CMIP6 historical
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(nanmean(CMIP6_hist.SST_glb(:,yr_war - yr0,:),3),2) - nanmean(nanmean(CMIP6_hist.SST_glb(:,yr_peace - yr0,:),3),2));
Tab(ct,2) = sqrt(nanmean(CDC_var(nanmean(CMIP6_hist.SST_glb(:,yr_war - yr0,:),1))));
Tab(ct,3) = sqrt(nanmean(CMIP6_hist.sst_var));

% CMIP5 picontrol
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(nanmean(CMIP5_pi.SST_glb(:,yr_war - 1935,:),3),2) - nanmean(nanmean(CMIP5_pi.SST_glb(:,yr_peace - 1935,:),3),2));
Tab(ct,2) = sqrt(nanmean(CDC_var(nanmean(CMIP5_pi.SST_glb(:,yr_war - 1935,:),1))));
Tab(ct,3) = sqrt(nanmean(CMIP5_pi.sst_var));

% CMIP6 picontrol
ct = ct + 1;
Tab(ct,1) = nanmean(nanmean(nanmean(CMIP6_pi.SST_glb(:,yr_war - 1935,:),3),2) - nanmean(nanmean(CMIP6_pi.SST_glb(:,yr_peace - 1935,:),3),2));
Tab(ct,2) = sqrt(nanmean(CDC_var(nanmean(CMIP6_pi.SST_glb(:,yr_war - 1935,:),1))));
Tab(ct,3) = sqrt(nanmean(CMIP6_pi.sst_var));

% =========================================================================
% Uncertainty estimates in Table 1
% =========================================================================
% R4
clear('Tab_range')
ct = 4;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(RND.SST_glb_adj(:,yr_war - yr0,:),2) - nanmean(RND.SST_glb_adj(:,yr_peace - yr0,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(RND.SST_glb_adj(:,yr_use - yr0,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(RND.sst_var_adj),[0.025 0.975]);

% R5
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(RND_day.SST_glb_adj(:,yr_war - yr0,:),2) - nanmean(RND_day.SST_glb_adj(:,yr_peace - yr0,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(RND_day.SST_glb_adj(:,yr_use - yr0,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(RND_day.sst_var_adj),[0.025 0.975]);

% ERSST4
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(ERSST4_en.SST_glb(:,yr_war - yr0,:),2) - nanmean(ERSST4_en.SST_glb(:,yr_peace - yr0,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(ERSST4_en.SST_glb(:,yr_use - yr0,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(ERSST4_en.sst_var),[0.025 0.975]);

% ERSST5
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(ERSST5_en.SST_glb(:,yr_war - yr0,:),2) - nanmean(ERSST5_en.SST_glb(:,yr_peace - yr0,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(ERSST5_en.SST_glb(:,yr_use - yr0,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(ERSST5_en.sst_var),[0.025 0.975]);

% HadISST2
ct = ct + 1;

% HadISST3
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(HadSST3_en.SST_glb(:,yr_war - yr0,:),2) - nanmean(HadSST3_en.SST_glb(:,yr_peace - yr0,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(HadSST3_en.SST_glb(:,yr_use - yr0,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(HadSST3_en.sst_var),[0.025 0.975]);

% HadISST4
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(HadSST4_en.SST_glb(:,yr_war - yr0,:),2) - nanmean(HadSST4_en.SST_glb(:,yr_peace - yr0,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(HadSST4_en.SST_glb(:,yr_use - yr0,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(HadSST4_en.sst_var),[0.025 0.975]);

% Cowtan
ct = ct + 1;

% CMIP5 historical
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(CMIP5_hist.SST_glb(:,yr_war - yr0,:),2) - nanmean(CMIP5_hist.SST_glb(:,yr_peace - yr0,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(CMIP5_hist.SST_glb(:,yr_use - yr0,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(CMIP5_hist.sst_var),[0.025 0.975]);

% CMIP6 historical
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(CMIP6_hist.SST_glb(:,yr_war - yr0,:),2) - nanmean(CMIP6_hist.SST_glb(:,yr_peace - yr0,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(CMIP6_hist.SST_glb(:,yr_use - yr0,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(CMIP6_hist.sst_var),[0.025 0.975]);

% CMIP5 picontrol
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(CMIP5_pi.SST_glb(:,yr_war - 1935,:),2) - nanmean(CMIP5_pi.SST_glb(:,yr_peace - 1935,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(CMIP5_pi.SST_glb(:,yr_use - 1935,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(CMIP5_pi.sst_var),[0.025 0.975]);

% CMIP6 picontrol
ct = ct + 1;
Tab_range(ct,1:2) = quantile(nanmean(nanmean(CMIP6_pi.SST_glb(:,yr_war - 1935,:),2) - nanmean(CMIP6_pi.SST_glb(:,yr_peace - 1935,:),2),1),[0.025 0.975]);
Tab_range(ct,3:4) = quantile(CDC_std(nanmean(CMIP6_pi.SST_glb(:,yr_use - 1935,:),1),2),[0.025 0.975]);
Tab_range(ct,5:6) = quantile(sqrt(CMIP6_pi.sst_var),[0.025 0.975]);

% =========================================================================
% Assemble and Display Table 1
% =========================================================================
clear('Table_1','Table_2','Table_merge')
% Tab_range(Tab_range == 0) = nan;
% Tab(Tab == 0) = nan;
Table_merge = num2str([Tab(:,1) Tab_range(:,1:2) Tab(:,2)  Tab_range(:,3:4)  Tab(:,3)  Tab_range(:,5:6)],...
    '& %7.2f [%4.2f,  %4.2f] & %7.2f [%4.2f,  %4.2f]  & %7.2f [%4.2f,  %4.2f] \\\\');

Table_head = [...
'''''R1: All SSTs (raw)           ';
'''''R2: Bucket (raw)             ';
'''''R3: ERI (raw)                ';
'''''R4: Day \& night (adjusted)  ';
'''''R5: Daytime only (adjusted)  ';
'''''ERSST4                       ';
'''''ERSST5                       ';
'''''HadSST2                      ';
'''''HadSST3                      ';
'''''HadSST4                      ';
'''''Cowtan SST                   ';
'''''CMIP5 historical             ';
'''''CMIP6 historical             ';
'''''CMIP5 control                ';
'''''CMIP6 control                '];

clear('Table_title')
Table_title(1,:) = '''''     & WWII anomaly &  1936-1950 variance of           &  global mean of 1936-1950 var.                \\';
Table_title(2,:) = '''''     & ($^\circ$C)  &  global-mean SST ($^\circ$C$^2$) & on 5$^\circ$ grids ($^\circ$C$^2$)            \\';
[Table_title; Table_head Table_merge]
