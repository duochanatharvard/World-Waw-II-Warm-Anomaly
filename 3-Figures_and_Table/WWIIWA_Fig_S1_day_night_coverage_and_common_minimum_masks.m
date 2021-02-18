clear;

dir_data = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
HadSST4 = ncread([dir_data,'HadSST.4.0.0.0_median.nc'],'tos');
HadSST4(HadSST4>100) = nan;
HadSST4 = reshape(HadSST4([37:72 1:36],:,1:1320),72,36,12,110);
HadSST4 = HadSST4(:,:,:,[1930:1955]-1849);

Day_Night = load([dir_data,'Corr_idv_ship_en_0_Ship_vs_Ship_all_measurements_1850_2014_Full_SST_Merge_Season.mat'],'WM');
Day_Night = squeeze(Day_Night.WM(:,:,1,:,[1930:1955]-1849));

Day_only = load([dir_data,'Corr_idv_ship_en_0_Ship_vs_Ship_day_measurements_1850_2014_Full_SST_Merge_Season.mat'],'WM');
Day_only = squeeze(Day_only.WM(:,:,1,:,[1930:1955]-1849));

% =========================================================================
% Figure S2: Data coverage during WWII
% =========================================================================
N_HadSST4 = squeeze(nansum(~isnan(HadSST4),3));      N_HadSST4(N_HadSST4 == 0)     = nan;
N_Day_Night = squeeze(nansum(~isnan(Day_Night),3));  N_Day_Night(N_Day_Night == 0) = nan;
N_Day_only = squeeze(nansum(~isnan(Day_only),3));    N_Day_only(N_Day_only == 0)   = nan;

figure(121); clf; 
yr_list = 1941:1945;
% yr_list = 1931:1935;
for yr = yr_list

    subplot(5,3,(yr-yr_list(1))*3 + 1); 
    CDF_pcolor(2.5:5:360,-87.5:5:90,N_Day_Night(:,:,yr-1929)); 

    subplot(5,3,(yr-yr_list(1))*3 + 2); 
    CDF_pcolor(2.5:5:360,-87.5:5:90,N_Day_only(:,:,yr-1929)); 

    subplot(5,3,(yr-yr_list(1))*3 + 3); 
    CDF_pcolor(2.5:5:360,-87.5:5:90,N_HadSST4(:,:,yr-1929)); 
end

for ct = 1:15
    subplot(5,3,ct); 
    caxis([0.5 12.5]); 
    col = jetCD(8);  
    colormap(col(3:14,:));
    CDF_boundaries; 
    CDF_panel([0 360 -70 90],'','','','');
    set(gca,'xtick',[90:90:270],'xticklabel',{'90^oE','180','90^oW'})
    set(gca,'ytick',[-40:40:80],'yticklabel',{'40^oS','0','40^oN'})   
end

set(gcf,'position',[.1 14 10 16],'unit','inches')
set(gcf,'position',[.1 14 13 12],'unit','inches')

% dir_save  = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/';
% file_save = [dir_save,'Fig.S2_coverage.png'];
% CDF_save(121,'png',300,file_save);
% 
% a = imread(file_save);
% a = a([250:720  880:1340  1500:1960 2120:2580  2740:end-380],[490:1360 1600:2440 2680:end-350],:);
% imwrite(a,file_save);

% ========================================================================
% Generate a minimum mask for calculating global averages
% =========================================================================
% common_minimum_mask = ~isnan(HadSST4) & ~isnan(Day_Night) & ~isnan(Day_only);
% save([dir_data,'common_minimum_mask.mat'],'common_minimum_mask','-v7.3')

