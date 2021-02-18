clear;

dir = WWIIWA_IO('data');

% =========================================================================
% Load Data
% =========================================================================
All_SST = load([dir,'Corr_idv_ship_en_0_Ship_vs_Ship_all_measurements_1850_2014_Full_SST_Merge_Season.mat']);
Bck_SST = load([dir,'Corr_idv_method_0_en_0_Ship_vs_Ship_all_measurements_1850_2014_Full_SST_Merge_Season.mat']);
ERI_SST = load([dir,'Corr_idv_method_1_en_0_Ship_vs_Ship_all_measurements_1850_2014_Full_SST_Merge_Season_infer_US.mat']);
Day_SST = load([dir,'Corr_idv_ship_en_0_Ship_vs_Ship_day_measurements_1850_2014_Full_SST_Merge_Season.mat']);

% =========================================================================
% Put things into R1--R5
% ========================================================================= 
R1 = squeeze(All_SST.WM(:,:,1,:,:));
R2 = squeeze(Bck_SST.WM(:,:,1,:,:));
R3 = squeeze(ERI_SST.WM(:,:,1,:,:));
R4 = squeeze(All_SST.WM(:,:,2,:,:));
R5 = squeeze(Day_SST.WM(:,:,2,:,:));

% =========================================================================
% Save NC files
% ========================================================================= 
disp('Saving data...')

file_save = [WWIIWA_IO('home'),'WWIIWA_monthly_SST_5x5_R1-R5_Chan_and_Huyber_2021_JC.nc'];
delete(file_save);

lon_dim   = 72;
lat_dim   = 36;
month_dim = 12;
year_dim  = 165;

nccreate(file_save,'lon','Dimensions', {'lon',lon_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'lon',[2.5:5:357.5]);

nccreate(file_save,'lat','Dimensions', {'lat',lat_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'lat',[-87.5:5:87.5]);

nccreate(file_save,'month','Dimensions', {'month',month_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'month',[1:12]);

nccreate(file_save,'year','Dimensions', {'year',year_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'year',[1850:2014]);

nccreate(file_save,'R1','Dimensions', {'lon',lon_dim,'lat',lat_dim,'month',month_dim,'year',year_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'R1',R1);
ncwriteatt(file_save,'R1','units','K relative to 1982-2014 climatology');
ncwriteatt(file_save,'R1','long_name','Raw SSTs based on all measurements in ICOADS3.0.');

nccreate(file_save,'R2','Dimensions', {'lon',lon_dim,'lat',lat_dim,'month',month_dim,'year',year_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'R2',R2);
ncwriteatt(file_save,'R2','units','K relative to 1982-2014 climatology');
ncwriteatt(file_save,'R2','long_name','Raw SSTs based on bucket measurements in ICOADS3.0.');

nccreate(file_save,'R3','Dimensions', {'lon',lon_dim,'lat',lat_dim,'month',month_dim,'year',year_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'R3',R3);
ncwriteatt(file_save,'R3','units','K relative to 1982-2014 climatology');
ncwriteatt(file_save,'R3','long_name','Raw SSTs based on ERI and inferred U.S. measurements in ICOADS3.0.');

nccreate(file_save,'R4','Dimensions', {'lon',lon_dim,'lat',lat_dim,'month',month_dim,'year',year_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'R4',R4);
ncwriteatt(file_save,'R4','units','K relative to 1982-2014 climatology');
ncwriteatt(file_save,'R4','long_name','Groupwise adjusted SSTs based on all measurements in ICOADS3.0.');

nccreate(file_save,'R5','Dimensions', {'lon',lon_dim,'lat',lat_dim,'month',month_dim,'year',year_dim},...
    'Datatype','double','FillValue','disable','Format','netcdf4');  
ncwrite(file_save,'R5',R5);
ncwriteatt(file_save,'R5','units','K relative to 1982-2014 climatology');
ncwriteatt(file_save,'R5','long_name','Groupwise adjusted SSTs based on daytime-only measurements in ICOADS3.0.');

disp('Run completes!')

% % =========================================================================
% % Checking
% % ========================================================================= 
% clear;
% 
% Ref = load([WWIIWA_IO('data'),'WWIIWA_statistics_for_ICOADS_raw_and_group_adjusted.mat']);
% 
% file_save = [WWIIWA_IO('home'),'WWIIWA_monthly_SST_5x5_R1-R5_Chan_and_Huyber_2021_JC.nc'];
% R1 = ncread(file_save,'R1');
% R2 = ncread(file_save,'R2');
% R3 = ncread(file_save,'R3');
% R4 = ncread(file_save,'R4');
% R5 = ncread(file_save,'R5');
% 
% [Full.SST_glb_raw,Full.sst_var_raw,Full.sst_war_raw,Full.sst_peace_raw] = ...
%     WWIIWA_analysis_calculate_statistics(R1,[1850:2014]);
% 
% [Bucket.SST_glb_raw,Bucket.sst_var_raw,Bucket.sst_war_raw,Bucket.sst_peace_raw] = ...
%     WWIIWA_analysis_calculate_statistics(R2,[1850:2014]);
% 
% [ERI.SST_glb_raw,ERI.sst_var_raw,ERI.sst_war_raw,ERI.sst_peace_raw] = ...
%     WWIIWA_analysis_calculate_statistics(R3,[1850:2014]);
% 
% [Full.SST_glb_adj,Full.sst_var_adj,Full.sst_war_adj,Full.sst_peace_adj] = ...
%     WWIIWA_analysis_calculate_statistics(R4,[1850:2014]);
% 
% [Full_day.SST_glb_adj,Full_day.sst_var_adj,Full_day.sst_war_adj,Full_day.sst_peace_adj] = ...
%     WWIIWA_analysis_calculate_statistics(R5,[1850:2014]);