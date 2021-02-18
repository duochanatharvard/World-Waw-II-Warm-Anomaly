function [BINNED,W_X] = LME_lme_bin(P)

    % *********************************************************************
    % Debug
    % *********************************************************************
    if 0
        P.yr_list = 1995:1995;
        P.mon_list  = 1:2;
        P.type = 'Bucket_vs_Bucket';
        P.save_app = 'Bucket_vs_Bucket';
        P.buoy_diurnal = 1;
        P.do_connect   = 1;
        P.connect_Kobe = 1;
        P.var_list = {'C0_YR','C0_MO','C0_UTC','C0_LON','C0_LAT',...
                      'C1_DCK','C0_SST','C0_OI_CLIM','C0_SI_4','C0_CTY_CRT'};
        P.key = 2;
        P.varname = 'SST';
        P.method  = 'Bucket';
        P.do_simple = 0;          % Whether all pairs are weighted equally?
        P.do_region = 1;
        P.do_season = 1;
        P.do_decade = 1;
        P.yr_start  = 1995;
        P.yr_interval = 5;
        P.mute_read = 1;
    end

    var_list = [P.var_list, 'DCK', 'Buoy_Diurnal'];
    if isfield(P,'use_fundemental_SST')
        if P.use_fundemental_SST == 1
                var_list = [var_list, 'Fundemental_SST'];
        end
    end

    % *********************************************************************
    % Input and Output
    % *********************************************************************
    dir_save = LME_OI('bin_pairs');
    file_save = [dir_save,'SUM_pairs_',P.save_sum,'.mat'];

    if isfield(P,'restart')
        if P.restart == 1
            try
                delete(file_save);
            catch
                disp([file_save,' does not exist, so not removed!'])
            end
        end
    end

    fid = fopen(file_save);

    if fid <= 0
        dir_load = LME_OI('screen_pairs');
        DATA = [];
        for var = 1:numel(var_list)
            eval(['P1.',var_list{var},' = [];']);
            eval(['P2.',var_list{var},' = [];']);
        end
        disp('==============================================================>')
        disp('Load in data ...')
        for yr = P.yr_list
            for mon = 1:12

                disp(['Starting year: ',num2str(yr),'  month:', num2str(mon)])
                file_load = [dir_load,'IMMA1_R3.0.0_',num2str(yr),'-',...
                    CDF_num2str(mon,2),'_',P.save_app,'.mat'];
                
                try 
                    load(file_load,'DATA_save');
                    DATA = [DATA DATA_save];

                    PP = P;   PP.yr = yr;  PP.mon = mon;  PP.C98_UID = DATA_save(1,:);
                    P1_temp = LME_pair_function_read_data(PP);    clear('PP')
                    PP = P;   PP.yr = yr;  PP.mon = mon;  PP.C98_UID = DATA_save(2,:);
                    P2_temp = LME_pair_function_read_data(PP);    clear('PP')

                    for var = 1:numel(var_list)
                        if ~ismember(var_list{var},{'C0_ID','C0_CTY_CRT','DCK'})
                            eval(['P1.',var_list{var},' = [P1.',var_list{var},'  P1_temp.',var_list{var},'];']);
                            eval(['P2.',var_list{var},' = [P2.',var_list{var},'  P2_temp.',var_list{var},'];']);
                        else
                            eval(['P1.',var_list{var},' = [P1.',var_list{var},'; P1_temp.',var_list{var},'];']);
                            eval(['P2.',var_list{var},' = [P2.',var_list{var},'; P2_temp.',var_list{var},'];']);
                        end
                    end
                catch
                    disp(['something wrong with data in ',num2str(yr),' Month ',num2str(mon)])
                end
            end
        end
        clear('P1_temp','P2_temp','var_list_temp','DATA_save','yr','mon');
        disp('Load in data completes!')
        disp(' ')

        dir_save = LME_OI('bin_pairs');
        file_save = [dir_save,'SUM_pairs_',P.save_sum,'.mat'];
        save(file_save,'P1','P2','-v7.3');
    else
        disp('Read existing file')
        load(file_save);
        fclose(fid);
    end

    % *********************************************************************
    % Reassign measurement methods
    % *********************************************************************
    P1 = LME_function_preprocess_SST_method(P1);
    P2 = LME_function_preprocess_SST_method(P2);

    % *********************************************************************
    % Remove pairs that have the same groupings
    % *********************************************************************
    disp('==============================================================>')
    disp('Remove duplicate pairs and small groups ...')
    clear('l_rp','l_sm','l_rm')
    grp1 = [P1.DCK P1.C0_SI_4'];
    grp2 = [P2.DCK P2.C0_SI_4'];

    if strcmp(P.type,'Bucket_vs_ERI')
        if isfield(P,'all_ERI_in_one_group')
            if P.all_ERI_in_one_group == 1
                l1 = grp1(:,end) == 1;
                l2 = grp2(:,end) == 1;
                grp1(l1,:) = 1;
                grp2(l2,:) = 1;
            end
        end
    end

    if strcmp(P.type,'ERI_vs_Bucket') || strcmp(P.type,'ERIex_vs_Bucket')
        if isfield(P,'all_BCK_in_one_group')
            if P.all_BCK_in_one_group == 1
                l1 = grp1(:,end) == 0;
                l2 = grp2(:,end) == 0;
                grp1(l1,:) = 0;
                grp2(l2,:) = 0;
            end
        end
    end
    l_rp = all(grp1 == grp2,2);


    [~,~,L] = unique([grp1; grp2],'rows');
    l_sm = ismember(L,find(hist(L,1:1:max(L)) <= P.key));
    l_sm = any([l_sm(1:numel(l_sm)/2)  l_sm(numel(l_sm)/2+1:end)],2);
    clear('L')

    l_rm = l_rp | l_sm;

    % Remove points that does not belong to a certain region --------------
    if isfield(P,'select_region')
        if any(P.select_region) ~= 0
            mx = LME_function_mean_period([P1.C0_LON; P2.C0_LON],360);
            my = nanmean([P1.C0_LAT; P2.C0_LAT],1);
            Id_region = LME_lme_effect_regional(mx,my,5);
            l_rm = l_rm | ~ismember(Id_region',P.select_region);
        end
    end

    % Remove points that does not belong to a certain month ---------------
    if isfield(P,'mon_list')
        if numel(P.mon_list) ~= 12
            my = nanmean([P1.C0_LAT; P2.C0_LAT],1);
            mon_temp = P1.C0_MO;
            mon_temp(my < 0) = mon_temp(my < 0) + 6;
            mon_temp(mon_temp > 12) = mon_temp(mon_temp > 12) - 12;
            l_rm = l_rm | ~ismember(mon_temp',P.mon_list);
        end
    end

    % Remove points that does not belong to a certain season --------------
    if isfield(P,'select_season')
        if any(P.select_season) ~= 0
            my = nanmean([P1.C0_LAT; P2.C0_LAT],1);
            Id_season = LME_lme_effect_seasonal(my,P1.C0_MO);
            Id_season = rem(Id_season - 0.5,4)+0.5;
            l_rm = l_rm | ~ismember(Id_season',P.select_season);
        end
    end

    for var = 1:numel(var_list)
        if ~ismember(var_list{var},{'C0_ID','C0_CTY_CRT','DCK'})
            eval(['P1.',var_list{var},' = P1.',var_list{var},'(~l_rm);']);
            eval(['P2.',var_list{var},' = P2.',var_list{var},'(~l_rm);']);
        else
            eval(['P1.',var_list{var},' = P1.',var_list{var},'(~l_rm,:);']);
            eval(['P2.',var_list{var},' = P2.',var_list{var},'(~l_rm,:);']);
        end
    end
    N_pairs = nnz(~l_rm);
    clear('l_rp','l_sm','l_rm','DATA','mx','my','Id_region','Id_season','l')
    disp('Remove duplicate pairs and small groups completes!')
    disp(' ')

    % *********************************************************************
    % Assign error structure for pairs
    % *********************************************************************
    disp('==============================================================>')
    disp('Assign error structure ...')
    clear('l_rp','l_sm','l_rm')
    if P.do_simple == 0
        % *****************************************************************
        % Compute the climatic variance of SST
        % *****************************************************************
        disp(['Compute the climatic variance ...'])
        var_clim = LME_lme_var_clim(P1.C0_LON,P2.C0_LON,P1.C0_LAT,P2.C0_LAT,...
            P1.C0_UTC,P2.C0_UTC,P1.C0_MO,P);
        var_clim(isnan(var_clim)) = 10;                             % P.varname

        % ****************************************************************
        % Compute the observational variance of SST
        % *****************************************************************
        disp(['Compute the observational variance ...'])
        [var_rnd,var_ship] = LME_lme_var_obs_cd(P);
        var_rnd  = repmat(var_rnd,1,N_pairs);
        var_ship = repmat(var_ship,1,N_pairs);
        var_obs  = var_rnd + var_ship;

        % *****************************************************************
        % Assign power of error decay
        % *****************************************************************
        [~,~,pow] = LME_lme_var_obs_cd(P);

        % *****************************************************************
        % Assign weights to pairs of SSTs
        % *****************************************************************
        % weight = 1./(2*var_obs + var_clim);
        % individual pairs are always weighted equally in the aggregation
        weight = ones(1,N_pairs);
        var_list_2 = {'var_clim','var_obs','var_rnd','var_ship','weight'};
    else
        weight = ones(1,N_pairs);
        var_list_2 = {'weight'};
    end
    disp('Assign error structure completes!')
    disp(' ')

    % *********************************************************************
    % Assign Effects to pairs of SSTs
    % *********************************************************************
    disp('==============================================================>')
    disp('Assign effects ...')
    % ---------------------------------------------------------------------
    % Assign regional effect
    % ---------------------------------------------------------------------
    mx = LME_function_mean_period([P1.C0_LON; P2.C0_LON],360);
    my = nanmean([P1.C0_LAT; P2.C0_LAT],1);
    if P.do_region == 1
        group_region = LME_lme_effect_regional(mx,my,5);
    else
        group_region = zeros(1,N_pairs);
    end
    var_list_2 = [var_list_2, 'mx','my','group_region'];

    % ---------------------------------------------------------------------
    % remove pairs that are too close to the coasts
    % ---------------------------------------------------------------------
    clear('l_rm')
    l_rm = isnan(group_region) | isnan(var_clim);
    for var = 1:numel(var_list)
        if ~ismember(var_list{var},{'C0_ID','C0_CTY_CRT','DCK'})
            eval(['P1.',var_list{var},' = P1.',var_list{var},'(~l_rm);']);
            eval(['P2.',var_list{var},' = P2.',var_list{var},'(~l_rm);']);
        else
            eval(['P1.',var_list{var},' = P1.',var_list{var},'(~l_rm,:);']);
            eval(['P2.',var_list{var},' = P2.',var_list{var},'(~l_rm,:);']);
        end
    end
    for var = 1:numel(var_list_2)
        eval([var_list_2{var},' = ',var_list_2{var},'(~l_rm);']);
    end
    N_pairs = nnz(~l_rm);
    clear('l_rm')

    % ---------------------------------------------------------------------
    % Assign seasonal effect
    % ---------------------------------------------------------------------
    if P.do_season == 1
        group_season = LME_lme_effect_seasonal(my,P1.C0_MO);
    else
        group_season = zeros(1,N_pairs);
    end
    var_list_2 = [var_list_2,'group_season'];

    % ---------------------------------------------------------------------
    % Assign decadal effect
    % ---------------------------------------------------------------------
    if P.do_decade == 1
        group_decade = LME_lme_effect_decadal(P1.C0_YR,P);
    else
        group_decade = zeros(1,N_pairs);
    end
    var_list_2 = [var_list_2,'group_decade'];
    clear('mx','my')
    disp('Assign effects completes!')
    disp(' ')

    % *********************************************************************
    % Prepare for the data to be binned
    % *********************************************************************
    disp('==============================================================>')
    disp('Prepare data to be binned ...')
    clear('data_cmp')
    kind_cmp_1 = [P1.DCK P1.C0_SI_4'];
    kind_cmp_2 = [P2.DCK P2.C0_SI_4'];

    if strcmp(P.type,'Bucket_vs_ERI')
        if isfield(P,'all_ERI_in_one_group')
            if P.all_ERI_in_one_group == 1
                l1 = kind_cmp_1(:,end) == 1;
                l2 = kind_cmp_2(:,end) == 1;
                kind_cmp_1(l1,:) = 1;
                kind_cmp_2(l2,:) = 1;
            end
        end
    end

    if strcmp(P.type,'ERI_vs_Bucket') || strcmp(P.type,'ERIex_vs_Bucket')
        if isfield(P,'all_BCK_in_one_group')
            if P.all_BCK_in_one_group == 1
                l1 = kind_cmp_1(:,end) == 0;
                l2 = kind_cmp_2(:,end) == 0;
                kind_cmp_1(l1,:) = 0;
                kind_cmp_2(l2,:) = 0;
            end
        end
    end

    var_list_2 = [var_list_2,'kind_cmp_1','kind_cmp_2'];

    % *********************************************************************
    % Find the data to be binned
    % *********************************************************************
    if strcmp(P.varname,'SST')
        data_cmp = (P1.C0_SST - P1.C0_OI_CLIM - P1.Buoy_Diurnal) - ...
                   (P2.C0_SST - P2.C0_OI_CLIM - P2.Buoy_Diurnal);
        if isfield(P,'use_fundemental_SST')
            if P.use_fundemental_SST == 1
                clear('data_cmp')
                data_cmp = P1.Fundemental_SST - P2.Fundemental_SST;
            end
        end
        var_list_2 = [var_list_2,'data_cmp'];
    end

    % *********************************************************************
    % Trimming of the data by 3 sigmas is removed in this version
    % *********************************************************************

    % *********************************************************************
    % Generate BINs
    % *********************************************************************
    [kind_bin_uni,~,group_nation] = unique([kind_cmp_1 kind_cmp_2],'rows');

    [kind_binned_uni,~,~] = unique([group_decade', group_nation,...
                                    group_region', group_season'],'rows');

    disp(' ')
    disp(['A total of ',num2str(size(kind_binned_uni,1)),' combinations of groups + region + decade'])
    disp(['A total of ',num2str(size(kind_bin_uni,1)),' combinations of groups'])
    
    % *********************************************************************
    % Compute the weights in the constrain
    % *********************************************************************
    [Group_uni,~,J_group] = unique([kind_cmp_1;kind_cmp_2],'rows');
    for ct = 1:size(Group_uni,1)
        W_X(1,ct) = nnz(J_group == ct);
    end
    W_X = W_X./nansum(W_X);
    clear('P1','P2')
    disp(' ')

    % *********************************************************************
    % Clean up variables in var_list_2
    % *********************************************************************
    l = ismember(var_list_2,{'mx','my','kind_cmp_1','kind_cmp_2'});
    var_list_2(l) = [];

    % *********************************************************************
    % Bin the pairs in a fast manner
    % *********************************************************************
    disp('==============================================================>')
    disp('Start Binning ...')

    % BINNED.Bin_y = [];
    % BINNED.Bin_w = [];
    % BINNED.Bin_n = [];
    % BINNED.Bin_region = [];
    % BINNED.Bin_decade = [];
    % BINNED.Bin_season = [];
    % BINNED.Bin_kind   = [];
    N_total = size(kind_binned_uni,1);
    BINNED.Bin_y = nan(N_total,1);
    BINNED.Bin_w = nan(N_total,1);
    BINNED.Bin_n = nan(N_total,1);
    BINNED.Bin_region = nan(N_total,1);
    BINNED.Bin_decade = nan(N_total,1);
    BINNED.Bin_season = nan(N_total,1);
    BINNED.Bin_kind = nan(N_total,size(kind_bin_uni,2));

    if P.do_simple == 0
        % BINNED.Bin_var_clim = [];
        % BINNED.Bin_var_rnd  = [];
        % BINNED.Bin_var_ship = [];
        BINNED.Bin_var_clim = nan(N_total,1);
        BINNED.Bin_var_rnd  = nan(N_total,1);
        BINNED.Bin_var_ship = nan(N_total,1);
    end

    ct_save = 0;
    for ct_nat = 1:max(group_nation)
        if rem(ct_nat,100) == 0
            disp(['Starting the ',num2str(ct_nat),'th Pairs'])
        end
        if nnz(group_nation == ct_nat) > 0

            clear('l');  l = group_nation == ct_nat;
            for var = 1:numel(var_list_2)
                eval(['clear(''temp_',var_list_2{var},'_ly_nat'')'])
                eval(['temp_',var_list_2{var},'_ly_nat = ',var_list_2{var},'(l);']);
            end

            clear('temp_decade_uni','J_decade')
            [temp_decade_uni,~,J_decade] = unique(temp_group_decade_ly_nat);

            for ct_dcd = 1:max(J_decade)
                if nnz(J_decade == ct_dcd) > 0

                    clear('l');  l = J_decade == ct_dcd;
                    for var = 1:numel(var_list_2)
                        eval(['clear(''temp_',var_list_2{var},'_ly_dcd'')'])
                        eval(['temp_',var_list_2{var},'_ly_dcd = temp_',var_list_2{var},'_ly_nat(l);']);
                    end

                    clear('temp_region_uni','J_region')
                    [temp_region_uni,~,J_region] = unique(temp_group_region_ly_dcd);

                    for ct_reg = 1:max(J_region)
                        if nnz(J_region == ct_reg) > 0

                            clear('l');  l = J_region == ct_reg;
                            for var = 1:numel(var_list_2)
                                eval(['clear(''temp_',var_list_2{var},'_ly_reg'')'])
                                eval(['temp_',var_list_2{var},'_ly_reg = temp_',var_list_2{var},'_ly_dcd(l);']);
                            end

                            clear('temp_season_uni','J_season')
                            [temp_season_uni,~,J_season] = unique(temp_group_season_ly_reg);

                            for ct_sea = 1:max(J_season)
                                if nnz(J_season == ct_sea) > 0

                                    clear('l');  l = J_season == ct_sea;
                                    for var = 1:numel(var_list_2)
                                        eval(['clear(''temp_',var_list_2{var},'_ly_sea'')'])
                                        eval(['temp_',var_list_2{var},'_ly_sea = temp_',var_list_2{var},'_ly_reg(l);']);
                                    end

                                    % *************************************
                                    % Compute the binned average
                                    % *************************************
                                    clear('temp_w','temp_y_bin','temp_w_bin',...
                                          'temp_binned','temp_n_bin')
                                    temp_w = temp_weight_ly_sea ./ nansum(temp_weight_ly_sea);
                                    temp_y_bin = nansum(temp_data_cmp_ly_sea .* temp_w);
                                    temp_n_bin = numel(temp_weight_ly_sea);

                                    if P.do_simple == 1
                                        temp_w_bin = temp_n_bin;
                                    else
                                        clear('temp_var_clim_bin','temp_var_rnd_bin',...
                                              'temp_var_ship_bin','temp_sigma_2')
                                        temp_var_clim_bin = nanmean(temp_var_clim_ly_sea) ./ temp_n_bin;
                                        temp_var_rnd_bin  = 2 * nanmean(temp_var_rnd_ly_sea)  ./ temp_n_bin;
                                        temp_var_ship_bin = 2 * nanmean(temp_var_ship_ly_sea) ./ (temp_n_bin.^pow);
                                        temp_sigma_2 = temp_var_clim_bin + temp_var_rnd_bin + temp_var_ship_bin;
                                        temp_w_bin = 1./temp_sigma_2;
                                    end

                                    ct_save = ct_save + 1;
                                    % BINNED.Bin_y = [BINNED.Bin_y;  temp_y_bin];
                                    % BINNED.Bin_w = [BINNED.Bin_w;  temp_w_bin];
                                    % BINNED.Bin_n = [BINNED.Bin_n;  temp_n_bin];
                                    % BINNED.Bin_region = [BINNED.Bin_region;  temp_region_uni(ct_reg)];
                                    % BINNED.Bin_decade = [BINNED.Bin_decade;  temp_decade_uni(ct_dcd)];
                                    % BINNED.Bin_season = [BINNED.Bin_season;  temp_season_uni(ct_sea)];
                                    % BINNED.Bin_kind   = [BINNED.Bin_kind;    kind_bin_uni(ct_nat,:) ];
                                    BINNED.Bin_y(ct_save) = temp_y_bin;
                                    BINNED.Bin_w(ct_save) = temp_w_bin;
                                    BINNED.Bin_n(ct_save) = temp_n_bin;
                                    BINNED.Bin_region(ct_save) = temp_region_uni(ct_reg);
                                    BINNED.Bin_decade(ct_save) = temp_decade_uni(ct_dcd);
                                    BINNED.Bin_season(ct_save) = temp_season_uni(ct_sea);
                                    BINNED.Bin_kind(ct_save,:) = kind_bin_uni(ct_nat,:);

                                    if P.do_simple == 0
                                        % BINNED.Bin_var_clim = [BINNED.Bin_var_clim;  temp_var_clim_bin];
                                        % BINNED.Bin_var_rnd  = [BINNED.Bin_var_rnd;   temp_var_rnd_bin ];
                                        % BINNED.Bin_var_ship = [BINNED.Bin_var_ship;  temp_var_ship_bin];
                                        BINNED.Bin_var_clim(ct_save) = temp_var_clim_bin;
                                        BINNED.Bin_var_rnd(ct_save)  = temp_var_rnd_bin;
                                        BINNED.Bin_var_ship(ct_save) = temp_var_ship_bin;
                                    end

                                    clear('temp_w','temp_y_bin','temp_w_bin',...
                                          'temp_binned','temp_n_bin')
                                    clear('temp_var_clim_bin','temp_var_rnd_bin',...
                                          'temp_var_ship_bin','temp_sigma_2')
                                end
                            end
                            clear('temp_season_uni','J_season')
                        end
                    end
                    clear('temp_region_uni','J_region')
                end
            end
            clear('temp_decade_uni','J_decade')
        end
    end
    disp('Binning completes!')
    disp(' ')
    for var = 1:numel(var_list_2)
        eval(['clear(''',var_list_2{var},''')'])
        eval(['clear(''temp_',var_list_2{var},'_ly_nat'')'])
        eval(['clear(''temp_',var_list_2{var},'_ly_reg'')'])
        eval(['clear(''temp_',var_list_2{var},'_ly_dcd'')'])
        eval(['clear(''temp_',var_list_2{var},'_ly_sea'')'])
    end

    % *********************************************************************
    % Post-processing BINNED
    % *********************************************************************
    clear('data_cmp','kind_cmp_1','kind_cmp_2','group_season',...
          'group_region','group_decade','weigh_use')
    clear('ct','ct_dcd','ct_nat','ct_sea','ct_reg')
    l_nan = isnan(BINNED.Bin_y) | isnan(BINNED.Bin_w);
    N_grp = size(BINNED.Bin_kind,2)/2;
    l_rm  = all(BINNED.Bin_kind(:,1:N_grp) == BINNED.Bin_kind(:,N_grp+1:end),2);
    l_rm = l_rm | l_nan;

    var_list_bin = fieldnames(BINNED);
    for var = 1:numel(var_list_bin)
        eval(['BINNED.',var_list_bin{var},'(l_rm,:) = [];']);
    end
    BINNED.Group_uni = Group_uni;

    % *********************************************************************
    % Save data
    % *********************************************************************
    dir_save = LME_OI('bin_pairs');
    file_save = [dir_save,'Binned_pairs_',P.save_bin,'.mat'];
    save(file_save,'BINNED','W_X','-v7.3');

end
