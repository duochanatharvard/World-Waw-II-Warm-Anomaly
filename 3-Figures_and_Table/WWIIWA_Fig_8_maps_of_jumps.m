clear;

dir_data = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
load([dir_data,'WWIIWA_statistics_for_ICOADS_raw_and_group_adjusted.mat']);
load([dir_data,'WWIIWA_statistics_for_other_SST_estimates.mat']);

st = {'region',[30 390 -50 87],'bckgrd','w','daspect',[1 .6 1],'fontsize',20,'xtick',[90:90:360]};

pic_ref_day = Full_day.sst_war_adj - Full_day.sst_peace_adj - (Full_day.sst_war_raw - Full_day.sst_peace_raw);

% =========================================================================
% Figure 9 - Panel a - j: Maps of WWIIWA in different estimates
% =========================================================================
clear('Tab')
for ct = 1:9
    figure(90+ct);
    
    switch ct
        case 1
            pic = Full_day.sst_war_raw - Full_day.sst_peace_raw;
        case 2
            pic = Full_day.sst_war_adj - Full_day.sst_peace_adj - (Full_day.sst_war_raw - Full_day.sst_peace_raw);
        case 3
            pic = Full_day.sst_war_adj - Full_day.sst_peace_adj;
        case 4
            pic = ERSST4.sst_war - ERSST4.sst_peace;
        case 5
            pic = HadSST3.sst_war - HadSST3.sst_peace;
        case 6
            pic = HadSST4.sst_war - HadSST4.sst_peace;
        case 7
            pic = ERSST4.sst_war - ERSST4.sst_peace - (Full_day.sst_war_adj - Full_day.sst_peace_adj);
        case 8
            pic = HadSST3.sst_war - HadSST3.sst_peace - (Full_day.sst_war_adj - Full_day.sst_peace_adj);
        case 9
            pic = HadSST4.sst_war - HadSST4.sst_peace - (Full_day.sst_war_adj - Full_day.sst_peace_adj);
    end
    CDF_plot_map('pcolor',pic,st); b2rCD(8,0); caxis([-1 1]*.8);
    
    Tab(1,ct) = CDC_corr(pic_ref_day(:),pic(:));
end

% =========================================================================
% dir_save = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/M/';
% for ct = 1:9
%     
%     figure(ct);
%     set(gcf,'position',[.1 13 10 5],'unit','inches')
%     set(gcf,'position',[.1 13 10 5]*.8,'unit','inches')
%     
%     file_save = [dir_save,'Fig.8_',num2str(ct),'.png'];
%     CDF_save(ct,'png',300,file_save);
% end
% 
% %%
% clear('a')
% for ct = 1:9
%     file_load = [dir_save,'Fig.8_',num2str(ct),'.png'];
%     a{ct} = imread(file_load);
% end
% 
% pic = [a{1}(50:end-115,140:end-495,:)  a{4}(50:end-115,390:end-495,:)   a{7}(50:end-115,390:end-495,:);
%        a{2}(50:end-115,140:end-495,:)  a{5}(50:end-115,390:end-495,:)   a{8}(50:end-115,390:end-495,:);
%        a{3}(50:end-10,140:end-495,:)  a{6}(50:end-10,390:end-495,:)   a{9}(50:end-10,390:end-495,:)];
% figure(1000); imshow(pic)
% imwrite(pic,[dir_save,'Fig.8.png'])