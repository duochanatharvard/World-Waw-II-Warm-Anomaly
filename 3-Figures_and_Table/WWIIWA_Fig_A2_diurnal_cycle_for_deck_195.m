clear; % clc;

dir = WWIIWA_IO('data');
% =========================================================================
% Load data
% =========================================================================
DA         = load([dir,'SUM_all_ships_DA_signals_1935_1949_Annual_relative_to_mean_SST.mat']);
DA_rm_6hr  = load([dir,'SUM_all_ships_DA_signals_1935_1949_Annual_relative_to_mean_SST_remove_6hr.mat']);
% remove the criteria of at least 1 measurement in every 6-hourly bin of a
% day to compute diurnal anoamlies for deck 195 measurements

% Adjust local hour for deck 195 because of the boundary effect of time zone division.
% Based on log-books, all measurements were taken at 8, 12, and 20 local hour.
l   = DA_rm_6hr.C1_DCK == 195 & ismember(DA_rm_6hr.C0_LCL,[7 11 19]);
DA_rm_6hr.C0_LCL(l) = DA_rm_6hr.C0_LCL(l) + 1;

for location = 1:5
    
    % =====================================================================
    % Subset data to only certain latitude bands and seasons
    % =====================================================================
    switch location
        case 1
            l_location = DA.C0_LAT < 90 & DA.C0_LAT > -90;
            l_location_rm_6hr = DA_rm_6hr.C0_LAT < 90 & DA_rm_6hr.C0_LAT > -90;
        case 2
            l_location = DA.C0_LAT < 30 & DA.C0_LAT > -30;
            l_location_rm_6hr = DA_rm_6hr.C0_LAT < 30 & DA_rm_6hr.C0_LAT > -30;
        case 3
            l_location = DA.C0_LAT < 60 & DA.C0_LAT > 30;
            l_location_rm_6hr = DA_rm_6hr.C0_LAT < 60 & DA_rm_6hr.C0_LAT > 30;
        case 4
            l_location = DA.C0_LAT < 60 & DA.C0_LAT > 30 & ismember(DA.C0_MO,[6 7 8]);
            l_location_rm_6hr = DA_rm_6hr.C0_LAT < 60 & DA_rm_6hr.C0_LAT > 30 & ismember(DA_rm_6hr.C0_MO,[6 7 8]);
        case 5
            l_location = DA.C0_LAT < 60 & DA.C0_LAT > 30 & ismember(DA.C0_MO,[1 2 12]);
            l_location_rm_6hr = DA_rm_6hr.C0_LAT < 60 & DA_rm_6hr.C0_LAT > 30 & ismember(DA_rm_6hr.C0_MO,[1 2 12]);
    end
    
    % =====================================================================
    % Estimate diurnal cycles for different components
    % =====================================================================
    % Get the diurnal cycle for bucket SSTs
    l_use = DA.C0_SI_4 == 0 & l_location;
    [diurnal_bck,diurnal_quantile_bck,num_bck,fit_out_bck,fit_out_std_bck,diurnal_std_bck] = ...
        Compute_and_fit_diurnal_signal(DA.C0_LCL(l_use),DA.Diurnal_signal(l_use));
    
    % Get the diurnal cycle for ERI and inferred US SSTs
    l_use = (DA.C0_SI_4 == 1 | (DA.C0_SI_4 == -1 & DA.C1_DCK ~= 195 & ismember(DA.C0_CTY_CRT,'US','rows')')) & l_location;
    [diurnal_eri,diurnal_quantile_eri,num_eri,fit_out_eri,fit_out_std_eri,diurnal_std_eri] = ...
        Compute_and_fit_diurnal_signal(DA.C0_LCL(l_use),DA.Diurnal_signal(l_use));
    
    % Get the diurnal cycle for deck 195 measurements
    l_use = DA_rm_6hr.C1_DCK == 195 & l_location_rm_6hr;
    [diurnal_195,diurnal_quantile_195,num_195,fit_out_195,fit_out_std_195,diurnal_std_195] = ...
        Compute_and_fit_diurnal_signal(DA_rm_6hr.C0_LCL(l_use),DA_rm_6hr.Diurnal_signal(l_use));
    
    % Get the diurnal cycle for collocated buoy SSTs (with deck 195 measurements)
    % for estimating the anomalous amplitude of diurnal cycles
    [diurnal_buoy,diurnal_quantile_buoy,num_buoy,fit_out_buoy,fit_out_std_buoy,diurnal_std_buoy] = ...
        Compute_and_fit_diurnal_signal(DA_rm_6hr.C0_LCL(l_use),DA_rm_6hr.D1_EXP(l_use));
    
    % Error estimates
    diurnal_std_bck = diurnal_std_bck./ sqrt(num_bck);
    diurnal_std_eri = diurnal_std_eri./ sqrt(num_eri);
    diurnal_std_195 = diurnal_std_195./ sqrt(num_195);
    
    % =====================================================================
    % Subset the number and time of diurnal cycles
    % =====================================================================
    c = hist(DA_rm_6hr.C0_LCL(l_location_rm_6hr & DA_rm_6hr.C1_DCK == 195),1:1:24);
    
    % =====================================================================
    % Figure S1: Diurnal cycles for deck 195
    % =====================================================================
    figure(110+location); clf; hold on;
    
    id = 29;
    
    CDF_bar(1:24,c/200000,-.25,repmat([.5 .5 .5],24,1),'facealpha',.4);
    
    CDF_panel([.5 24.5 -.25 .25],'','','Local hour','Diurnal SST anomalies [^oC]','fontsize',20)
    
    b1 = diurnal_bck - nanmean(diurnal_bck([8 12 20])) + 2 * diurnal_std_bck;
    b2 = diurnal_bck - nanmean(diurnal_bck([8 12 20])) - 2 * diurnal_std_bck;
    
    e1 = diurnal_eri - nanmean(diurnal_eri([8 12 20])) + 2 * diurnal_std_eri;
    e2 = diurnal_eri - nanmean(diurnal_eri([8 12 20])) - 2 * diurnal_std_eri;
    
    patch([1:24 24:-1:1],[b1 fliplr(b2)],[1 .3 .3],'linest','none','facealpha',.4);
    patch([1:24 24:-1:1],[e1 fliplr(e2)],[0 .3 1],'linest','none','facealpha',.4);
    
    plot(diurnal_bck - nanmean(diurnal_bck([8 12 20])),'-','linewi',2,'color',[.8 0 0])
    plot(diurnal_eri - nanmean(diurnal_eri([8 12 20])),'-','linewi',2,'color',[0 0 .8])
    
    plot([8 12 20],squeeze(diurnal_195([8 12 20])),'wo','markersize',20,'linewi',2,'markerfacecolor','k')
    plot([8 12 20]-1,squeeze(diurnal_195([8 12 20]-1)),'wo','markersize',10,'linewi',2,'markerfacecolor','k')

    for ct = [7 8 11 12 19 20]
        plot([ct ct],diurnal_195(ct) + [-1 1]* diurnal_std_195(ct)*2,'y','linewi',4);
    end
    
    set(gca,'xtick',[4:4:20],'ytick',[-.2:.1:.2])
    
    set(gcf,'position',[.1 13 10 5],'unit','inches')
    set(gcf,'position',[.1 13 10 5],'unit','inches')
    
%     dir_save = '/Users/duochan/Dropbox/Research/01_SST_Bucket_Intercomparison/02_Manuscript/04_WWII_2020/JC_manuscript/1_revision/Figures/M/';
%     clear('a')
%     for ct = [110+location]
%         file_save = [dir_save,'FigS1_',num2str(location),'.png'];
%         CDF_save(ct,'png',300,file_save);
%         a{ct} = imread(file_save);
%     end

    % =====================================================================
    % Fit for the combination of bucket and ERI measurements
    % =====================================================================
    E = [];
    ct = 0;
    x = 0:0.01:2;
    
    for r = x
        ct = ct + 1;
        y = diurnal_bck * (1-r) + diurnal_eri * r;
        y = y - nanmean(y([8 12 20]));
        y_std = sqrt(diurnal_std_bck.^2 * (1-r).^2 + diurnal_std_eri.^2 * r.^2);
        y_dif = (y - diurnal_195) ./ sqrt(y_std.^2 + diurnal_std_195.^2);
        E(ct) = nanmean(y_dif([7 8 11 12 19 20]).^2);
    end
    
    r = x((E == min(E)));
    R = fit_out_eri*r + fit_out_bck*(1-r);
    R_std =  sqrt(fit_out_std_eri.^2*r^2 + fit_out_std_bck.^2*(1-r)^2);
    
    disp(['Location: ',num2str(location),''])
    disp(['Ratio of ERI: ',num2str(round(r*100)),'%'])
    
    [amp,~,amp_std,~] = parse_DA(R,R_std);
    [amp_buoy,~,amp_std_buoy,~] = parse_DA(fit_out_buoy,fit_out_std_buoy);

        disp(['Diurnal amplitude deck 195: ',num2str(amp)])
    disp(['Difference in diurnal amplitude: ',num2str(amp - amp_buoy)])
    disp(['Uncertainties in diurnal amplitude: ',num2str(amp_std^2 + amp_std_buoy^2)])
    disp(' ')
end