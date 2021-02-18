% *************************************************************************
% This version pairs all sources of data
% This version pairs SST data with land station data
% SST data are from ships only
% excluding C-MAN and Buoy measurements
% *************************************************************************
%
% P.yr           = 1930;
% P.mon          = 1;
% P.do_connect   = 1;
% P.connect_Kobe = 1;
%
% Last update: 2020-03-24

function LME_pair_01_Raw_Pairs_land_station(P)

    % for debug -----------------------------------------------------------
    if 0

        for yr = 2014:-1:1850
            for mon = 1:1:12

                clear('P')
                P.yr           = yr;
                P.mon          = mon;
                P.do_connect   = 1;
                P.connect_Kobe = 1;

                disp([num2str(P.mon)])
                LME_pair_01_Raw_Pairs_land_station(P);
            end
        end
    end

    % *********************************************************************
    % Input and Output
    % *********************************************************************
    dir_save = [LME_OI('home'),'Step_L01_All_Pairs/'];
    dir_mis  = LME_OI('Mis');

    % *********************************************************************
    % Loading SST data
    % *********************************************************************
    DATA = LME_pair_function_read_data(P);
    DATA = LME_function_preprocess_SST_method(DATA);
    disp('Loading data completes!')

    clear('uid_sst','lon_sst','lat_sst','T_sst','grp_sst')
    l_use = DATA.C0_SI_4 ~= -2;
    uid_sst = DATA.C98_UID(l_use);
    lon_sst = DATA.C0_LON(l_use);
    lat_sst = DATA.C0_LAT(l_use);
    T_sst   = DATA.C0_SST(l_use) - DATA.C0_OI_CLIM(l_use);
    grp_sst = [DATA.DCK(l_use,:) DATA.C0_SI_4(l_use)'];

    % *********************************************************************
    % Loading station data
    % *********************************************************************
    if isfield(P,'alpha')
        file_station = [dir_mis,'Station_monthly_temperature_anomalies_processed_alpha_',...
                                      num2str(P.alpha),'_beta_',num2str(P.beta),'.mat'];
    else
        file_station = [dir_mis,'Station_monthly_temperature_anomalies_processed_alpha_and_beta_tunned_by_month.mat'];
    end
    
    LD = load(file_station);

    clear('T_lnd','lon_lnd','lat_lnd')
    T_lnd = squeeze(LD.DATA.T_anm(P.mon,P.yr - LD.yr(1) + 1,:));
    l_lnd = ~isnan(T_lnd);
    T_lnd = T_lnd(l_lnd);
    lon_lnd = LD.DATA.lon(l_lnd);
    lon_lnd(lon_lnd<0) = lon_lnd(lon_lnd<0)+360;
    lat_lnd = LD.DATA.lat(l_lnd);

    % *********************************************************************
    % pairing
    % *********************************************************************
    c_lim  = 200;
    Pairs.C98_UID    = [];
    Pairs.C0_LON     = [];
    Pairs.C0_LAT     = [];
    Pairs.C0_LON_LND = [];
    Pairs.C0_LAT_LND = [];
    Pairs.C0_T_DIF   = [];
    Pairs.Distance   = [];
    Pairs.GRP        = [];

    for ct_lnd = 1:numel(T_lnd)

        dis      = distance(lat_lnd(ct_lnd),lon_lnd(ct_lnd),lat_sst,lon_sst) * 111;
        l_pair   = dis < c_lim;

        Pairs.C98_UID    = [Pairs.C98_UID    uid_sst(l_pair)];
        Pairs.C0_LON     = [Pairs.C0_LON     lon_sst(l_pair)];
        Pairs.C0_LAT     = [Pairs.C0_LAT     lat_sst(l_pair)];
        Pairs.C0_LON_LND = [Pairs.C0_LON_LND repmat(lon_lnd(ct_lnd),1,nnz(l_pair))];
        Pairs.C0_LAT_LND = [Pairs.C0_LAT_LND repmat(lat_lnd(ct_lnd),1,nnz(l_pair))];
        Pairs.C0_T_DIF   = [Pairs.C0_T_DIF   T_sst(l_pair) - T_lnd(ct_lnd)];
        Pairs.Distance   = [Pairs.Distance   dis(l_pair)];
        Pairs.GRP        = [Pairs.GRP;       grp_sst(l_pair,:)];
    end

    % *********************************************************************
    % remove repetitive pairs
    % *********************************************************************
    [uni_uid,~,J] = unique(Pairs.C98_UID');
    clear('l_use')
    l_use = zeros(1,size(uni_uid,1));
    for ct = 1:size(uni_uid,1)
        l         = find(J == ct);
        temp      = Pairs.Distance(l);
        id        = find(temp == min(temp));
        l_use(ct) = l(id(1));
    end
    Pair_picked.C98_UID    = Pairs.C98_UID(l_use);
    Pair_picked.C0_LON     = Pairs.C0_LON(l_use);
    Pair_picked.C0_LAT     = Pairs.C0_LAT(l_use);
    Pair_picked.C0_LON_LND = Pairs.C0_LON_LND(l_use);
    Pair_picked.C0_LAT_LND = Pairs.C0_LAT_LND(l_use);
    Pair_picked.C0_T_DIF   = Pairs.C0_T_DIF(l_use);
    Pair_picked.Distance   = Pairs.Distance(l_use);
    Pair_picked.GRP        = Pairs.GRP(l_use,:);

    if ~isempty(Pair_picked.C98_UID)

        % *****************************************************************
        % Save Data
        % *****************************************************************
        disp('Saving data')
        file_save = [dir_save,'IMMA1_R3.0.0_',num2str(P.yr),...
                   '-',CDF_num2str(P.mon,2),'_All_pairs_land_station.mat'];
        save(file_save,'Pair_picked','-v7.3');
    end
end
