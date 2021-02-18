clear;

dir_data = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
load([dir_data,'WWIIWA_statistics_for_ICOADS_raw_and_group_adjusted.mat']);

% =========================================================================
% Figure 5 - Panel a: R4
% =========================================================================
figure(51); clf; hold on;
patch([1940.5 1945.5 1945.5 1940.5],[-100 -100 100 100],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')
plot_time_series(Full.SST_glb_adj,RND.SST_glb_adj,[0 0 0],-1,[],1); 
plot_time_series_three_way(Full.SST_glb_adj,Bucket.SST_glb_adj,ERI.SST_glb_adj);
plot_time_series(Full.SST_glb_adj,[],[0 0 0],-1,[],1); 

CDF_panel([1930 1955 -.4 .4],'','','','','fontsize',16,'fontweight','normal')
set(gca,'ytick',[-.4:.2:.6])
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 15 5 3],'unit','inches')

% =========================================================================
% Figure 5 - Panel b: Collocated differences
% =========================================================================
figure(52); clf; hold on;
patch([1940.5 1945.5 1945.5 1940.5],[-100 -100 100 100],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')

plot(1930:1955,nanmean(Dif_Bucket_ERI.SST_glb_raw,1),'color',[0 0 0]+0.5,'linewi',3); 
plot(1930:1955,nanmean(Dif_Bucket_ERI.SST_glb_adj,1),'color',[.7 0 0],'linewi',3); 

CDF_panel([1930 1955 -.2 1],'','','','','fontsize',16,'fontweight','normal')
set(gca,'ytick',[-0:.2:.8])
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 5 3],'unit','inches')

% =========================================================================
% Figure 5 - Panel c: Groupwise decomposition of adjustments
% =========================================================================
[grp_all,col_all] = WWIIWA_all_groups_have_colors;
grp = IDV.groups;
N_grp = size(grp,1);

target_yr = [1934:1951];
pic_raw  = squeeze(nanmean(Full.SST_glb_raw(:,target_yr-1929),1));
pic_grp  = squeeze(nanmean(Full.SST_glb_adj(:,target_yr-1929),1)) - pic_raw;
pic_idv  = squeeze(nanmean(IDV.SST_glb_adj(:,target_yr-1929,1:N_grp),1)) - repmat(pic_raw',1,N_grp);

figure(53); clf; hold on; clear('h')
patch([1940.5 1945.5 1945.5 1940.5],[-1e2 -1e2 1e2 1e2],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')

clear('pic')
l =  max(abs(pic_idv),[],1) > 0.015 & nansum((pic_idv ~= 0),1) >= 3;
grp_pic = grp(l,:);
pic       = pic_idv(:,l)';
pic_other = pic_idv(:,~l)';
col_other = [.8 .4 .4; .4 .4 .8]*0;
pic_other_pos = pic_other;         pic_other_pos(pic_other_pos < 0) = 0;   pic_other_pos = nansum(pic_other_pos,1);
pic_other_nag = pic_other;         pic_other_nag(pic_other_nag > 0) = 0;   pic_other_nag = nansum(pic_other_nag,1);
pic_pos   = [pic; pic_other_pos];  pic_pos(pic_pos < 0) = 0;
pic_nag   = [pic; pic_other_nag];  pic_nag(pic_nag > 0) = 0;

l = ismember(grp_all,grp_pic,'rows');
col = col_all(l,:);

CDF_bar_stack(target_yr,pic_pos,[col;col_other(1,:)]);
CDF_bar_stack(target_yr,pic_nag,[col;col_other(2,:)]);
 
CDF_histplot(target_yr, pic_grp,'-','w',5);
plot(target_yr,-pic_raw-0.3,'w-','linewi',5);

CDF_histplot(target_yr, pic_grp,'-','k',2);
plot(target_yr,-pic_raw-0.3,'-','linewi',2,'color',[1 1 1]*.6);

set(gca,'xtick',1935:5:1950,'ytick',[-.4:.2:.4])
CDF_panel([1935 1950 -.5 .5],'','','','','fontsize',18,'fontweight','normal')

set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[5.1 13 5 3.25],'unit','inches')

% =========================================================================
% Figure 5 - legend
% =========================================================================
figure(54); clf; hold on;
nnn = 3;        % number of columns
grp_pic_both   = grp_pic;
l   = ismember(grp_all,grp_pic_both,'rows');
col = col_all(l,:);

for i = 1:nnz(l)
    [yy,xx] = ind2sub([ceil(nnz(l)/nnn), nnn],i);

    if grp_pic_both(i,1) < 100
        temp_text = [grp_pic_both(i,1:2),'  D',num2str(grp_pic_both(i,3))];
    else
        temp_text = ['Deck',num2str(grp_pic_both(i,3))];
    end

    clear('surfix_col')
    switch grp_pic_both(i,4)
        case 0
            surfix_col = 'b';
        case 1
            surfix_col = 'r';
        case -1
            surfix_col = [0.5,0.5,0.5];
        case 3
            surfix_col = [1,.6,0];
    end

    patch([xx xx+0.2 xx+0.2 xx],-[yy yy yy+0.8 yy+0.8]+0.4,col(i,:),'linest','none');
    h = text(0.25+xx,-yy,temp_text,'color',surfix_col);
    set(h,'fontsize',16,'fontweight','normal')

end
axis off
axis([0.9 nnn+1.2   -floor(nnz(l)/nnn)-2 0]); 

set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 7 3],'unit','inches')

% ========================================================================
% dir_save = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/M/';
% for ct = 1:4
%     file_save = [dir_save,'Fig.5_',num2str(ct),'.png'];
%     CDF_save(ct,'png',300,file_save);
% end