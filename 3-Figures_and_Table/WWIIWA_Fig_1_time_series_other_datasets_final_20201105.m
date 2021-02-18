clear;

dir_data =  WWIIWA_IO('data');

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
% Figure 1 - Panel a: Other datasets
% =========================================================================
figure(11);  clf; 
subplot(1,5,2:5); hold on;
ct = 0;   
y_tick = [];
jg     = 0.6;      
patch([1940.5 1945.5 1945.5 1940.5],[-100 -100 100 100],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')
[ct,y_tick] = plot_time_series(ERSST4.SST_glb,ERSST4_en.SST_glb,[0 0.5 0],ct,y_tick);     
[ct,y_tick] = plot_time_series(ERSST5.SST_glb,ERSST5_en.SST_glb,[0 0.7 0],ct,y_tick);    
[ct,y_tick] = plot_time_series(HadSST2.SST_glb,[],[0 .2 .8],ct,y_tick);                  
[ct,y_tick] = plot_time_series(HadSST3.SST_glb,HadSST3_en.SST_glb,[.1 .3 .9],ct,y_tick); 
[ct,y_tick] = plot_time_series(HadSST4.SST_glb,HadSST4_en.SST_glb,[.4 .6 1],ct,y_tick);   
[~,y_tick]  = plot_time_series(cowtan(:,[1930:1955]-1849),[],[1 .6 0],ct,y_tick);                           
CDF_panel([1930 1955 -jg*7+1/5 -1/10],'','','','','fontsize',16);
set(gca,'ytick',sort(y_tick),'yticklabel',repmat([-0.15 0 0.15],1,8));
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 6 10],'unit','inches')

% =========================================================================
% Figure 1 - Panel b: R1 - R3
% =========================================================================
figure(12); clf; hold on;
patch([1940.5 1945.5 1945.5 1940.5],[-100 -100 100 100],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')
plot_time_series_three_way(Full.SST_glb_raw,Bucket.SST_glb_raw,ERI.SST_glb_raw);
plot_time_series(Full.SST_glb_raw,[],[0 0 0],-1,[],1); 

CDF_panel([1930 1955 -.6 .8],'','','','','fontsize',16)
set(gca,'ytick',[-.4:.2:.6])
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 5 3.8],'unit','inches')

% =========================================================================
% Figure 1 - Panel c: R4 - R5 and CMIP5 - CMIP6
% =========================================================================
figure(13);  clf; 
subplot(1,5,2:5); hold on;
ct = 0;   
y_tick = [];
jg     = 0.6; 
patch([1940.5 1945.5 1945.5 1940.5],[-100 -100 100 100],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')
[ct,y_tick] = plot_time_series(Full.SST_glb_adj,RND.SST_glb_adj,[.8 0 .6],ct,y_tick); 
[ct,y_tick] = plot_time_series(Full_day.SST_glb_adj,RND_day.SST_glb_adj,[.8 0 0],ct,y_tick); 
plot_cmip(CMIP5_hist.SST_glb,[1 1 1]*.7,ct+1);
[ct,y_tick] = plot_time_series(nanmean(CMIP5_hist.SST_glb,3),[],[0 0 0]+0.2,ct,y_tick); 
plot_cmip(CMIP6_hist.SST_glb,[1 1 1]*.6,ct+1);
[~,y_tick]  = plot_time_series(nanmean(CMIP6_hist.SST_glb,3),[],[0 0 0],ct,y_tick); 

CDF_panel([1930 1955 -jg*5+.3 -1/10],'','','','','fontsize',16)
set(gca,'ytick',sort(y_tick),'yticklabel',repmat([-.15 0 .15],1,8));
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 6 6.7],'unit','inches')

% =========================================================================
% dir_save = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/M/';
% file_save = [dir_save,'Fig1-a.png'];
% CDF_save(1,'png',300,file_save);
% 
% file_save = [dir_save,'Fig1-b.png'];
% CDF_save(2,'png',300,file_save);
% 
% file_save = [dir_save,'Fig1-c.png'];
% CDF_save(3,'png',300,file_save);