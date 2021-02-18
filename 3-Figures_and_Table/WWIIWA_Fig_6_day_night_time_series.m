clear;

dir_data   = WWIIWA_IO('data');

% =========================================================================
% Figure 6 - Panel a - b: day & night only for bucket and ERI SSTs
% =========================================================================
load([dir_data,'WWIIWA_statistics_for_ICOADS_raw_and_group_adjusted.mat']);

figure(61); clf; hold on;
patch([1940.5 1945.5 1945.5 1940.5],[-100 -100 100 100],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')

pic_all   = nanmean(Bucket.SST_glb_raw,1);
pic_day   = nanmean(Bucket_day.SST_glb_raw,1);
pic_night = nanmean(Bucket_night.SST_glb_raw,1);
plot(1930:1955,pic_day - nanmean(pic_all([1936:1940 1946:1950]-1929)),'color',[.8 .6 0],'linewi',3); 
plot(1930:1955,pic_night  - nanmean(pic_all([1936:1940 1946:1950]-1929)),'color',[0 .6 .8],'linewi',3); 

CDF_panel([1930 1955 -.5 .5],'','','','','fontsize',16,'fontweight','normal')
set(gca,'ytick',[-0.4:.2:.4])
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 5 3],'unit','inches')

figure(62); clf; hold on;
patch([1940.5 1945.5 1945.5 1940.5],[-100 -100 100 100],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')

pic_all   = nanmean(ERI.SST_glb_raw,1);
pic_day   = nanmean(ERI_day.SST_glb_raw,1);
pic_night = nanmean(ERI_night.SST_glb_raw,1);
plot(1930:1955,pic_day - nanmean(pic_all([1936:1940 1946:1950]-1929)),'color',[.8 .6 0],'linewi',3); 
plot(1930:1955,pic_night  - nanmean(pic_all([1936:1940 1946:1950]-1929)),'color',[0 .6 .8],'linewi',3); 

CDF_panel([1930 1955 -.5 .5],'','','','','fontsize',16,'fontweight','normal')
set(gca,'ytick',[-0.4:.2:.4])
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 5 3],'unit','inches')

% =========================================================================
% Figure 6 - Panel c: maps of bucket night - daytime SSTs
% =========================================================================
day   = load([dir_data,'Corr_idv_method_0_en_0_Ship_vs_Ship_day_measurements_1850_2014_Full_SST_Merge_Season_bucket_no_infer.mat']);
night = load([dir_data,'Corr_idv_method_0_en_0_Ship_vs_Ship_night_measurements_1850_2014_Full_SST_Merge_Season_bucket_no_infer.mat']);
dif   = squeeze(night.WM(:,:,1,:,:) - day.WM(:,:,1,:,:));  

yr    = [1942:1945]-1849;
dif   = dif(:,:,:,yr);
dif   = reshape(dif,72,36,48);

map_ann_war = nanmean(dif,3); 
map_ann_war(nansum(~isnan(dif),3) < 3) = nan;

figure(63); hold on;
CDF_plot_map('pcolor',CDC_smooth2(map_ann_war),'region',[30 390 -50 80],...
    'bckgrd',[1 1 1]*.85,'daspect',[1 .6 1],'fontsize',20,'xtick',[90:90:360],'barloc','southoutside')
b2rCD(9,0);
caxis([-1 1]*.3)

set(gcf,'position',[.1 13 5 2.5]*1.3,'unit','inches')
set(gcf,'position',[.1 13 5 4]*1.44,'unit','inches')
 
% =========================================================================
% dir_save = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/M/';
% for ct = 1:3
%     file_save = [dir_save,'Fig.6_',num2str(ct),'.png'];
%     CDF_save(ct,'png',300,file_save);
% end