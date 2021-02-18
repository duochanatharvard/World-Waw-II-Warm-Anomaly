clear;

dir = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
load([dir,'Stats_All_ships_groupwise_global_analysis.mat']);

Stats_glb = Stats_glb([1935:1949]-1849,:,:);
clear('temp')
for ct = 1:size(Stats_glb,3)
    temp(:,:,ct) = Stats_glb(:,:,ct)';
end
Stats_glb = reshape(temp,size(Stats_glb,1)*12,size(Stats_glb,3));

l_use     = nansum(Stats_glb,1) > 1e5;      
grp_large_num = unique_grp(l_use,:);

[grp_all,col] = WWIIWA_all_groups_have_colors;

% =========================================================================
% Figure 2 - Panel a: Number of measurements
% =========================================================================
clear('pic_glb')

l_col = ismember(grp_all,grp_large_num,'rows');

pic_glb = Stats_glb(:,l_use);
pic_glb(:,end+1) = nansum(Stats_glb(:,~l_use),2);

figure(21); clf;
patch([1940 1946 1946 1940],[0 0 1e8 1e8],[.6 .6 .6]+0.2,'facealpha',0.3,'linest','none')
col_lgd = [col(l_col,:);0 0 0];
CDF_bar_stack([1:1/12:15.99]+1934,pic_glb',col_lgd)
CDF_panel([1935 1950 0 1e5],'','','','','fontsize',18)
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 8 5],'unit','inches')

% =========================================================================
% Figure 2 - Panel b: - Number of pairs
% =========================================================================
file_2b = [dir,'statistics_N_of_pairs_for_Fig_2b.mat'];

try
    load(file_2b);
catch
    
    dir_all_pairs = '/Users/duochan/Data/LME_intercomparison/Step_03_Binned_Pairs_v17/';
    load([dir_all_pairs,'SUM_pairs_Ship_vs_Ship_all_measurements_1850_2014_Full_SST.mat']);
    P1   = LME_function_preprocess_SST_method(P1);
    P2   = LME_function_preprocess_SST_method(P2);
    grp1 = [P1.DCK P1.C0_SI_4'];
    grp2 = [P2.DCK P2.C0_SI_4'];
    l = P1.C0_YR >= 1935 & P1.C0_YR <= 1949;
    grp1 = grp1(l,:);
    grp2 = grp2(l,:);
    clear('P1','P2','l')
    
    clear('G1','G2')
    l_ot = ~ismember(grp1,grp_large_num,'rows');
    G1 = grp1;  G1(l_ot,:) = 999;
    l_ot = ~ismember(grp2,grp_large_num,'rows');
    G2 = grp2;  G2(l_ot,:) = 999;
    [uni_grp,~,J] = unique([G1;G2],'rows');
    
    M1 = J(1:(numel(J)/2));
    M2 = J((numel(J)/2)+1:end);
    
    clear('Stats_pairs')
    for i = 1:size(uni_grp,1)
        for j = i:size(uni_grp,1)
            ll = (M1 == i & M2 == j) | (M1 == j & M2 == i);
            Stats_pairs(i,j) = nnz(ll);
        end
    end
    
    save(file_2b,'Stats_pairs','uni_grp','-v7.3')
end

figure(22); clf; 
plot_intercompare(Stats_pairs,uni_grp,col_lgd);
set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 9 7],'unit','inches')

% =========================================================================
% Figure 2- Panel c - e: Maps of dominating nations
% =========================================================================
for ct = 0:2
        
    clear('max_grp','max_grp_yr')
    for ct_yr = 1:5
        clear('pic_map_yr','Stats_map_yr')
        Stats_map_yr = squeeze(nansum(Stats_map(:,:,ct*5 + 1935 + ct_yr -1849,:),3));
        pic_map_yr   = Stats_map_yr(:,:,l_use);
        pic_map_yr(:,:,end+1) = nansum(Stats_map_yr(:,:,~l_use),3);
        [~,temp] = max(pic_map_yr,[],3);
        l = nansum(pic_map_yr,3) < 1;
        temp(l) = nan;
        max_grp_yr(:,:,ct_yr) = temp;
    end
    max_grp = mode(max_grp_yr,3);
    l = nansum(~isnan(max_grp_yr),3) >= 3;
    max_grp(~l)  = nan;

    figure(23+ct); clf; hold on;
    CDF_plot_map('pcolor',max_grp+.1,'region',[30 390 -50 80],...
        'bckgrd','w','daspect',[1 .6 1],'fontsize',20,'xtick',[90:90:360])
    colormap(gca,col_lgd)
    caxis([0.5 size([col(l_col,:);0 0 0],1)+0.5])
    colorbar off;

    set(gcf,'position',[.1 13 7 5],'unit','inches')
    set(gcf,'position',[.1 13 6 7],'unit','inches')

end

%% =========================================================================
% Figure 2 - legend
% =========================================================================
figure(26); clf; hold on;
nnn = 5;      % number of columns

for i = 1:(size(grp_large_num,1)+1)
    [yy,xx] = ind2sub([ceil((size(grp_large_num,1)+1)/nnn), nnn],i);

    if i <= size(grp_large_num,1)
        if grp_large_num(i,1) < 100
            temp_text = [grp_large_num(i,1:2),'  D',num2str(grp_large_num(i,3))];
        else
            temp_text = ['Deck  ',num2str(grp_large_num(i,3))];
        end
    else
        temp_text = ['Other groups'];
    end

    clear('surfix_col')
    if i <= size(grp_large_num,1)
        switch grp_large_num(i,4)
            case 0
                surfix_col = 'b';
            case 1
                surfix_col = 'r';
            case -1
                surfix_col = [0.5,0.5,0.5];
            case 3
                surfix_col = [1,.6,0];
            otherwise
                surfix_col = [0,0,0];
        end
    else
        surfix_col = [0,0,0];
    end

    patch([xx xx+0.2 xx+0.2 xx],-[yy yy yy+0.8 yy+0.8]+0.4,col_lgd(i,:),'linest','none');
    h = text(0.25+xx,-yy,temp_text,'color',surfix_col);
    set(h,'fontsize',15,'fontweight','normal');
end
axis off
axis([0.9 nnn+1.2   -floor((size(grp_large_num,1)+1)/nnn)-2 0]); 

set(gcf,'position',[.1 13 7 5],'unit','inches')
set(gcf,'position',[.1 13 12 2],'unit','inches')

% ========================================================================
% dir_save = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/M/';
% for ct = [1:6 100]
%     file_save = [dir_save,'Fig2-',num2str(ct),'.png'];
%     CDF_save(ct,'png',300,file_save);
% end