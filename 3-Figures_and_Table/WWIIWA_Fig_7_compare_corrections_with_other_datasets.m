clear;

dir_data = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
load([dir_data,'WWIIWA_statistics_for_ICOADS_raw_and_group_adjusted.mat']);
load([dir_data,'WWIIWA_statistics_for_other_SST_estimates.mat']);
load([dir_data,'WWIIWA_statistics_for_CMIP5_piControl_runs.mat'])
load([dir_data,'WWIIWA_statistics_for_CMIP6_piControl_runs.mat'])
load([dir_data,'WWIIWA_statistics_for_CMIP5_historical_runs.mat'])
load([dir_data,'WWIIWA_statistics_for_CMIP6_historical_runs.mat'])
cowtan = load([dir_data,'hybrid_36m.temp']);
cowtan = reshape(cowtan(1:1980,2),12,165);
cowtan = cowtan - repmat(nanmean(cowtan(:,[1960:1990]-1849),2),1,165);

% =========================================================================
% Figure 7 - Panel a: comparing corrections for different datasets
% =========================================================================
figure(71); clf; hold on;

patch([1940.5 1945.5 1945.5 1940.5],[-100 -100 100 100]/100,[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')

pic = squeeze(nanmean(-Full.SST_glb_raw,1));
plot(1930:1955,pic,'-','color',[.7 .7 .7]-.7,'linewi',1)

pic = nanmean(cowtan(:,[1930:1955]-1849),1) - nanmean(HadSST3.SST_glb_raw,1);
plot(1930:1955,pic,'o-','color',[1 .6 0],'linewi',2)

pic = nanmean(HadSST3.SST_glb,1) - nanmean(HadSST3.SST_glb_raw,1);
plot(1930:1955,pic,'s-','color',[.1 .3 .9],'linewi',2)

pic = nanmean(HadSST4.SST_glb(:,:,1),1) - nanmean(HadSST4.SST_glb_raw,1);
plot(1930:1955,pic,'x-','color',[.4 .6 1],'linewi',2)

pic = nanmean(Full_day.SST_glb_adj,1) - nanmean(Full.SST_glb_raw,1);
plot(1930:1955,pic+0.22,'+-','color',[.7 0 0],'linewi',3)

CDF_panel([1935 1950 -.2 .6],'','','','','fontsize',17)
set(gca,'ytick',[-.1:.1:.5])

set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 7 5],'unit','inches')

%% =========================================================================
% Figure 7 - Panel b: WWIIWA in different SST estimates + CMIP5 internal variability
% =========================================================================
figure(72); clf; hold on;

% plot for CMIP5 pi-Control simulations
xx = [-0.3:0.001:0.5];
jump_cmip_pi5 = get_jump(CMIP5_pi.SST_glb);
hist_pi5      = smooth(hist(jump_cmip_pi5,xx),31)' / size(jump_cmip_pi5,2);

jump_cmip_pi6 = get_jump(CMIP6_pi.SST_glb);
hist_pi6      = smooth(hist(jump_cmip_pi6,xx),31)' / size(jump_cmip_pi6,2);

% h = CDF_pcolor([-0.3:0.001:0.5],1:12,repmat(hist_pi,1,12)./0.001);
% caxis([0 10]);
% hotCD(20,'gry');
temp = hist_pi5; temp(xx>0.1 | xx < -0.1) = 0;
h = patch([xx fliplr(xx)],12 - [temp/0.002 xx*0],[1 1 1]*.4,'linest','none'); alpha(h,0.5);
temp = hist_pi6; temp(xx>0.105 | xx < -0.105) = 0;
h = patch([xx fliplr(xx)],0+ [temp/0.002 xx*0],[1 1 1]*.4,'linest','none'); alpha(h,0.5);
h = patch([xx fliplr(xx)],12 - [hist_pi5/0.002 xx*0],[1 1 1]*.4,'linest','none'); alpha(h,0.2);
h = patch([xx fliplr(xx)],0+[hist_pi6/0.002 xx*0],[1 1 1]*.2,'linest','none'); alpha(h,0.2);
plot(xx,12-hist_pi5/0.002,'-','linewi',3,'color',[1 1 1]*.4)
plot(xx,0+hist_pi6/0.002,'-','linewi',3,'color',[1 1 1]*.2)


plot([1 1]*quantile(jump_cmip_pi5,0.025),[0 12],'--','linewi',2,'color',[0 0 0]+.5)
plot([1 1]*quantile(jump_cmip_pi5,0.975),[0 12],'--','linewi',2,'color',[0 0 0]+.5)
plot([1 1]*quantile(jump_cmip_pi6,0.025),[0 12],'--','linewi',2,'color',[0 0 0])
plot([1 1]*quantile(jump_cmip_pi6,0.975),[0 12],'--','linewi',2,'color',[0 0 0])

for ct = 1:11
    plot([-1 1],[1 1]*ct,':','color',[1 1 1]*.6);
end

% for ct = [-0.1:0.1:1]
%     plot([1 1]*ct,[1 12],'-','color',[1 1 1]*.8);
% end

grid on

yy = 11;
mk_siz_outer = 50;
mk_siz_inter = 15;
linewi = 3;

yy = yy -1;
plot(get_jump(Full.SST_glb_raw(:,[1:15]+6)),yy,'.','markersize',mk_siz_outer,'color',[0 0 0]);
plot(get_jump(Full.SST_glb_raw(:,[1:15]+6)),yy,'.','markersize',mk_siz_inter,'color','w');

yy = yy -1;
temp = get_jump(RND.SST_glb_adj(:,[1:15]+6,:));
plot(quantile(temp,[0.025 0.975]),[1 1]*yy,'-','linewi',linewi,'color',[.9 0 .7]);
plot(get_jump(Full.SST_glb_adj(:,[1:15]+6)),yy,'.','markersize',mk_siz_outer,'color',[.9 0 .7]);
plot(get_jump(Full.SST_glb_adj(:,[1:15]+6)),yy,'.','markersize',mk_siz_inter,'color',[1 1 1]);

yy = yy -1;
temp = get_jump(RND_day.SST_glb_adj(:,[1:15]+6,:));
plot(quantile(temp,[0.025 0.975]),[1 1]*yy,'-','linewi',linewi+1,'color',[0.8 0 0]);
plot(get_jump(Full_day.SST_glb_adj(:,[1:15]+6)),yy,'.','markersize',mk_siz_outer+20,'color',[0.8 0 0]);
plot(get_jump(Full_day.SST_glb_adj(:,[1:15]+6)),yy,'.','markersize',mk_siz_inter+10,'color',[1 1 1]);

yy = yy -1;
temp = get_jump(ERSST4_en.SST_glb(:,[1:15]+6,:));
plot(quantile(temp,[0.025 0.975]),[1 1]*yy,'-','linewi',linewi,'color',[0 0.5 0]);
plot(get_jump(ERSST4.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_outer,'color',[0 0.5 0]);
plot(get_jump(ERSST4.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_inter,'color','w');

yy = yy -1;
temp = get_jump(ERSST5_en.SST_glb(:,[1:15]+6,:));
plot(quantile(temp,[0.025 0.975]),[1 1]*yy,'-','linewi',linewi,'color',[0 0.7 0]);
plot(get_jump(ERSST5.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_outer,'color',[0 0.7 0]);
plot(get_jump(ERSST5.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_inter,'color','w');

yy = yy -1;
plot(get_jump(HadSST2.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_outer,'color',[0 .2 .8]);
plot(get_jump(HadSST2.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_inter,'color','w');

yy = yy -1;
temp = get_jump(HadSST3_en.SST_glb(:,[1:15]+6,:));
plot(quantile(temp,[0.025 0.975]),[1 1]*yy,'-','linewi',linewi,'color',[.1 .3 .9]);
plot(get_jump(HadSST3.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_outer,'color',[.1 .3 .9]);
plot(get_jump(HadSST3.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_inter,'color','w');

yy = yy -1;
temp = get_jump(HadSST4_en.SST_glb(:,[1:15]+6,:));
plot(quantile(temp,[0.025 0.975]),[1 1]*yy,'-','linewi',linewi,'color',[.4 .6 1]);
plot(get_jump(HadSST4.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_outer,'color',[.4 .6 1]);
plot(get_jump(HadSST4.SST_glb(:,[1:15]+6)),yy,'.','markersize',mk_siz_inter,'color','w');

yy = yy -1;
plot(get_jump(cowtan(:,[1936:1950]-1849)),yy,'.','markersize',mk_siz_outer,'color',[1 .6 0]);
plot(get_jump(cowtan(:,[1936:1950]-1849)),yy,'.','markersize',mk_siz_inter,'color','w');

CDF_panel([-.2 .45 0 12],'','','WWII temperature anomaly [^oC]','','fontsize',16);
%    'fontsize',16,'bartit','pdf of internal variability','barloc','southoutside');

set(gca,'ytick',[])

set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 7 5.5],'unit','inches')

% =========================================================================
% Figure 7 -- Panel b: another version, not used
% =========================================================================
% figure(3); clf; hold on;
% 
% % plot for CMIP5 pi-Control simulations
% jump_cmip_pi = get_jump(CMIP5_pi.SST_glb);
% hist_pi      = smooth(hist(jump_cmip_pi,[-0.3:0.001:0.3]),41) / size(jump_cmip_pi,2);
% patch([[-0.3:0.001:0.3] fliplr([-0.3:0.001:0.3])],[hist_pi' hist_pi'*0]/0.001,...
%     [1 1 1]*.6,'linest','none','facealpha',.3);
% plot([-0.3:0.001:0.3],hist_pi/0.001,'linewi',3,'color',[1 1 1]*.4)
% x = [-0.3:0.001:0.3];
% hist_pi(x>quantile(jump_cmip_pi,0.975)) = [];
% hist_pi(x<quantile(jump_cmip_pi,0.025)) = [];
% x(x>quantile(jump_cmip_pi,0.975)) = [];
% x(x<quantile(jump_cmip_pi,0.025)) = [];
% patch([x fliplr(x)],[hist_pi' hist_pi'*0]/0.001,...
%     [1 1 1]*.3,'linest','none','facealpha',.3);
% 
% wi = 3;
% 
% plot([1 1]*get_jump(ERSST4.SST_glb(:,[1:15]+6)),[0 12],'-','linewi',wi,'color',[0 0.5 0]);
% plot(get_jump(ERSST4.SST_glb(:,[1:15]+6)),11.6666,'.','markersize',20,'color',[0 0.5 0]);
% temp = get_jump(ERSST4_en.SST_glb(:,[1:15]+6,:));
% plot(quantile(temp,[0.025 0.975]),[1 1]*11.6666,'-','linewi',2,'color',[0 0.5 0]);
% plot(get_jump(ERSST4.SST_glb(:,[1:15]+6)),11.6666,'.','markersize',10,'color','w');
% 
% plot([1 1]*get_jump(ERSST5.SST_glb(:,[1:15]+6)),[0 12],'-','linewi',wi,'color',[0 0.7 0]);
% plot(get_jump(ERSST5.SST_glb(:,[1:15]+6)),11.3333,'.','markersize',20,'color',[0 0.7 0]);
% temp = get_jump(ERSST5_en.SST_glb(:,[1:15]+6,:));
% plot(quantile(temp,[0.025 0.975]),[1 1]*11.3333,'-','linewi',2,'color',[0 0.7 0]);
% plot(get_jump(ERSST5.SST_glb(:,[1:15]+6)),11.3333,'.','markersize',10,'color','w');
% 
% plot([1 1]*get_jump(HadSST2.SST_glb(:,[1:15]+6)),[0 12],'-','linewi',wi,'color',[0 .2 .8]);
% 
% plot([1 1]*get_jump(HadSST3.SST_glb(:,[1:15]+6)),[0 12],'-','linewi',wi,'color',[.1 .3 .9]);
% plot(get_jump(HadSST3.SST_glb(:,[1:15]+6)),11,'.','markersize',20,'color',[.1 .3 .9]);
% temp = get_jump(HadSST3_en.SST_glb(:,[1:15]+6,:));
% plot(quantile(temp,[0.025 0.975]),[1 1]*11,'-','linewi',2,'color',[.1 .3 .9]);
% plot(get_jump(HadSST3.SST_glb(:,[1:15]+6)),11,'.','markersize',10,'color','w');
% 
% plot([1 1]*get_jump(HadSST4.SST_glb(:,[1:15]+6)),[0 12],'-','linewi',wi,'color',[.4 .6 1]);
% plot(get_jump(HadSST4.SST_glb(:,[1:15]+6)),10.6666,'.','markersize',20,'color',[.4 .6 1]);
% temp = get_jump(HadSST4_en.SST_glb(:,[1:15]+6,:));
% plot(quantile(temp,[0.025 0.975]),[1 1]*10.6666,'-','linewi',2,'color',[.4 .6 1]);
% plot(get_jump(HadSST4.SST_glb(:,[1:15]+6)),10.6666,'.','markersize',10,'color','w');
% 
% plot([1 1]*get_jump(cowtan(:,[1936:1950]-1849)),[0 12],'-','linewi',wi,'color',[1 .6 0]);
% 
% plot([1 1]*get_jump(Full.SST_glb_adj(:,[1:15]+6)),[0 12],'-','linewi',wi+1,'color',[.9 0 .7]);
% plot(get_jump(Full.SST_glb_adj(:,[1:15]+6)),10,'.','markersize',30,'color',[.9 0 .7]);
% temp = get_jump(RND.SST_glb_adj(:,[1:15]+6,:));
% plot(quantile(temp,[0.025 0.975]),[1 1]*10,'-','linewi',2,'color',[.9 0 .7]);
% plot(get_jump(Full.SST_glb_adj(:,[1:15]+6)),10,'.','markersize',12,'color',[1 1 1]);
% 
% plot([1 1]*get_jump(Full_day.SST_glb_adj(:,[1:15]+6)),[0 12],'-','linewi',wi+3,'color',[0.8 0 0]);
% plot(get_jump(Full_day.SST_glb_adj(:,[1:15]+6)),9.6666,'.','markersize',40,'color',[0.8 0 0]);
% temp = get_jump(RND_day.SST_glb_adj(:,[1:15]+6,:));
% plot(quantile(temp,[0.025 0.975]),[1 1]*9.6666,'-','linewi',3,'color',[0.8 0 0]);
% plot(get_jump(Full_day.SST_glb_adj(:,[1:15]+6)),9.6666,'.','markersize',15,'color',[1 1 1]);
% 
% plot([1 1]*get_jump(Full.SST_glb_raw(:,[1:15]+6)),[0 12],'-','linewi',wi+1,'color',[0 0 0]);
% 
% CDF_panel([-.2 .45 0 12],'','','WWII temperature anomaly [^oC]','pdf','fontsize',17)
% 
% set(gcf,'position',[.1 13 7 5],'unit','inches')
% set(gcf,'position',[.1 13 7 7],'unit','inches')

% dir_save = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/M/';
% for ct = 1:2
%     file_save = [dir_save,'Fig7_',num2str(ct),'.png'];
%     CDF_save(ct,'png',300,file_save);
% end