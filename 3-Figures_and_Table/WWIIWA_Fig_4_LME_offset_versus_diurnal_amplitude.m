clear;


dir = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
load([dir,'WWIIWA_statistics_for_ICOADS_raw_and_group_adjusted.mat']);
load([dir,'LME_offsets_seasonality_over_regions_SST_pairs.mat']);

% generate colormaps
load([dir,'Stats_All_ships_groupwise_global_analysis.mat'],'Stats_glb','unique_grp');
DA        = load([dir,'DATA_Plot_DA&LME_1935_1949_Global.mat']);
try
    DA.DATA_pic.group = DA.DATA_pic.group_bck;
end

grp_DA_LME    = DA.DATA_pic.group;
[grp_all,col_all] = WWIIWA_all_groups_have_colors;

% close all;

l = ismember(grp_all,grp_DA_LME,'rows');
col = col_all(l,:);

x     = DA.DATA_pic.DA_amp(:,1) - DA.DATA_pic.DA_amp_clim(:,1);
x_std = sqrt(DA.DATA_pic.DA_amp_std(:,1).^2 + DA.DATA_pic.DA_amp_clim_std(:,1).^2);
y     = DA.DATA_pic.LME;
y_std = DA.DATA_pic.LME_std;

P.mute_output = 1;
[slope, inter, slope_member, inter_member] = CDC_yorkfit_bt(y,x,y_std,x_std,0,1,10000,P);

pic_x = repmat([-1:0.001:1],10000,1);
pic_y = pic_x.*repmat(slope_member,1,size(pic_x,2)) + repmat(inter_member,1,size(pic_x,2));
pic_y_q = quantile(pic_y,[0.025,0.975],1);

% =========================================================================
% Figure 4 - LME offsets versus DA 
% =========================================================================
figure(41);  clf; hold on;
patch([pic_x(1,:),fliplr(pic_x(1,:))],[pic_y_q(1,:),fliplr(pic_y_q(2,:))],...
                                [1 1 1]*.7,'linest','none','facealpha',0.4)

for ct = 1:numel(x)   
    plot(x(ct) + [-1 1]*x_std(ct)*2,y(ct) + [-1 1]*y_std(ct)*0,'color',[1 1 1]*.5)
    plot(x(ct) + [-1 1]*x_std(ct)*0,y(ct) + [-1 1]*y_std(ct)*2,'color',[1 1 1]*.5)
end

plot([-1 1],[-1 1]*slope+inter,'k-','linewi',3);

for ct = 1:numel(x)    
    if grp_DA_LME(ct,4) == 0
        col_line = 'b';
    elseif grp_DA_LME(ct,4) == 1
        col_line = 'r';
    elseif grp_DA_LME(ct,4) == -1
        col_line = [.5 .5 .5];
    else
        col_line = [1 .6 0];
    end
    plot(x(ct),y(ct),'o','color',col_line,'markerfacecolor',col(ct,:),'linewi',2,'markersize',20);  
    plot(x(ct),y(ct),'o','color',col_line,'markerfacecolor',col(ct,:),'linewi',2,'markersize',18);  
    plot(x(ct),y(ct),'o','color','w','markerfacecolor',col(ct,:),'linewi',2,'markersize',15);  
end

CDF_panel([-.2 .25 -.5 1],'','','','','fontsize',18);
daspect([.45 1.5 1]);
set(gca,'xtick',[-.1:.1:.2],'ytick',[-.4:.2:.8]);

set(gcf,'position',[.1 13 7 5],'unit','inches');
set(gcf,'position',[.1 13 7 8],'unit','inches');

% =========================================================================
% Plot DECK 195
% =========================================================================
da_195_anomaly = -0.066;  % see the global output from WWIIWA_Fig_S1_diurnal_cycle_for_deck_195.m

for ct = 1:numel(DA.DATA_pic.LME_only)
    
    if ismember(DA.DATA_pic.group_only(ct,:),[double('US'),195,-1],'rows')
        [l,pst] = ismember(DA.DATA_pic.group_only(ct,:),grp_all,'rows');

        if l
            plot([1 1]*da_195_anomaly,DA.DATA_pic.LME_only(ct) + 2 * [-1 1] * DA.DATA_pic.LME_only_std(ct),'color',[.5 .5 .5],'linewi',1);
            plot(da_195_anomaly,DA.DATA_pic.LME_only(ct),'d','color',[.5 .5 .5],'markerfacecolor',col_all(pst,:),'linewi',2,'markersize',20);  
            plot(da_195_anomaly,DA.DATA_pic.LME_only(ct),'d','color',[.5 .5 .5],'markerfacecolor',col_all(pst,:),'linewi',2,'markersize',18);  
            plot(da_195_anomaly,DA.DATA_pic.LME_only(ct),'d','color','w','markerfacecolor',col_all(pst,:),'linewi',2,'markersize',15);  
        end 
    end
end

% =========================================================================
% Plot DECK 245: before and after the beginning of the war
% =========================================================================
id = find(ismember(grp_DA_LME,[double('GB'),245,-1],'rows'));

for ct = 1:2
    
    if ct == 1
        DA_prior  = load([dir,'DATA_Plot_DA&LME_1935_1939_Global.mat']);
        DA_pic = DA_prior;   st = 'v';
    else
        DA_post   = load([dir,'DATA_Plot_DA&LME_1940_1949_Global.mat']);
        DA_pic = DA_post;    st = '^';
    end
    
    l = find(ismember(DA_pic.DATA_pic.group,[double('GB'),245,-1],'rows'));

    x2(ct) = DA_pic.DATA_pic.DA_amp(l,1) - DA_pic.DATA_pic.DA_amp_clim(l,1);
    x2_std(ct) = sqrt(DA_pic.DATA_pic.DA_amp_std(l,1).^2 + DA_pic.DATA_pic.DA_amp_clim_std(l,1).^2);
    y2(ct)     = DA_pic.DATA_pic.LME(l);
    y2_std(ct) = DA_pic.DATA_pic.LME_std(l);

    plot(x2(ct) + [-1 1]*x2_std(ct)*2,y2(ct) + [-1 1]*y2_std(ct)*0,'color',[1 1 1]*.5)
    plot(x2(ct) + [-1 1]*x2_std(ct)*0,y2(ct) + [-1 1]*y2_std(ct)*2,'color',[1 1 1]*.5)

    col_line = [.5 .5 .5];
    plot(x2(ct),y2(ct),st,'color',col_line,'markerfacecolor',col(id,:),'linewi',2,'markersize',20);  
    plot(x2(ct),y2(ct),st,'color',col_line,'markerfacecolor',col(id,:),'linewi',2,'markersize',18);  
    plot(x2(ct),y2(ct),st,'color','w','markerfacecolor',col(id,:),'linewi',2,'markersize',15);  
end

% =========================================================================
% Figure 4 - Legend
% =========================================================================
figure(42); clf; hold on;
nnn = 2;                                                % number of columns
grp_pic_both   = grp_DA_LME;
l = ismember(grp_all,grp_pic_both,'rows');
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

    plot(xx,-yy,'o','markerfacecolor',col(i,:),'linest','none','color','w','markersize',15);
    h = text(0.25+xx,-yy,temp_text,'color',surfix_col);
    set(h,'fontsize',15,'fontweight','normal');
end
axis off
axis([0.9 nnn+1.2   -floor(nnz(l)/nnn)-2 0]); 

set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 7 6.5],'unit','inches')

% ========================================================================
% dir_save = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/M/';
% for ct = [41:42]
%     file_save = [dir_save,'Fig.4_',num2str(ct),'.png'];
%     CDF_save(ct,'png',300,file_save);
% end

