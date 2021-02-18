% LME_Step_02_Screen_Pairs(yr,mon)
%
% Required parameters are:
%     P.yr
%     P.mon
%     P.do_connect
%     P.connect_Kobe
%     P.type:   Bucket_vs_Bucket     Bucket_vs_ERI      ERI_vs_ERI
%     P.save_app
%     P.all_ERI_in_one_group
%     P.use_C0_SI_2

function LME_pair_02_Screen_Pairs(P)

    % *********************************************************************
    % Input and Output
    % *********************************************************************
    dir_load = LME_OI('all_pairs');
    dir_save = LME_OI('screen_pairs');

    % *********************************************************************
    % File name for the saving data
    % *********************************************************************
    file_load = [dir_load,'IMMA1_R3.0.0_',num2str(P.yr),'-',...
                           CDF_num2str(P.mon,2),'_All_pairs.mat'];

    fid = fopen(file_load);
    if fid > 0

        fclose(fid);
        clear('DATA','DATA_save')
        % *****************************************************************
        % Load in pairs for that year and month
        % *****************************************************************
        if strcmp(P.type,'Bucket_vs_Bucket')
            load(file_load,'Bucket_vs_Bucket');
            DATA = Bucket_vs_Bucket;
            clear('Bucket_vs_Bucket')
        elseif strcmp(P.type,'Bucket_vs_ERI')
            if isfield(P,'all_ERI_in_one_group')
                if P.all_ERI_in_one_group == 1
                    load(file_load,'Bucket_vs_Bucket','Bucket_vs_ERI');
                    DATA = [Bucket_vs_Bucket  Bucket_vs_ERI];
                    clear('Bucket_vs_Bucket','Bucket_vs_ERI');
                else
                    load(file_load,'Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI');
                    DATA = [Bucket_vs_Bucket  Bucket_vs_ERI   ERI_vs_ERI];
                    clear('Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI');
                end
            else
                load(file_load,'Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI');
                DATA = [Bucket_vs_Bucket  Bucket_vs_ERI   ERI_vs_ERI];
                clear('Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI');
            end
        elseif strcmp(P.type,'ERI_vs_ERI') || strcmp(P.type,'ERIex_vs_ERIex')
            load(file_load,'ERI_vs_ERI');
            DATA = [ERI_vs_ERI];
            clear('ERI_vs_ERI');
        elseif strcmp(P.type,'ERI_vs_Bucket') || strcmp(P.type,'ERIex_vs_Bucket')
            if isfield(P,'all_BCK_in_one_group')
                if P.all_BCK_in_one_group == 1
                    load(file_load,'ERI_vs_ERI','Bucket_vs_ERI');
                    DATA = [ERI_vs_ERI  Bucket_vs_ERI];
                    clear('ERI_vs_ERI','Bucket_vs_ERI');
                else
                    load(file_load,'Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI');
                    DATA = [Bucket_vs_Bucket  Bucket_vs_ERI   ERI_vs_ERI];
                    clear('Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI');
                end
            else
                load(file_load,'Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI');
                DATA = [Bucket_vs_Bucket  Bucket_vs_ERI   ERI_vs_ERI];
                clear('Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI');
            end
        elseif strcmp(P.type,'Ship_vs_Ship')
            load(file_load,'Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI','Ship_vs_Ship');
            DATA = [Bucket_vs_Bucket  Bucket_vs_ERI   ERI_vs_ERI  Ship_vs_Ship];
            clear('Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI','Ship_vs_Ship');
        end

        % *****************************************************************
        % Choose if to use data that only belong to tracked kent data
        % *****************************************************************
        if isfield(P,'use_kent_tracks')
            if P.use_kent_tracks == 1
                dir_kent = LME_OI('kent_track');
                file_kent = [dir_kent,'IMMA1_R3.0.0_',num2str(P.yr),'-',...
                                       CDF_num2str(P.mon,2),'_Tracks_Kent.mat'];
                load(file_kent,'C0_ID_K','C98_UID');
                l_rm = all(C0_ID_K == ' ',2) | ismember(C0_ID_K(:,1:2),'NA','rows');
                C98_UID(l_rm) = [];
                l_use  = ismember(DATA(1,:),C98_UID) & ismember(DATA(2,:),C98_UID);
                DATA = DATA(:,l_use);
                clear('l_use','C0_ID_K','l_rm','C98_UID','dir_kent','file_kent')
            end
        end

        % Or to exclude data to only have points with computed diurnal cycles
        if isfield(P,'use_diurnal_points')
            if P.use_diurnal_points == 1
                dir_diurnal  = LME_OI('ship_diurnal');
                file_diurnal = [dir_diurnal,'IMMA1_R3.0.0_',num2str(P.yr),'-',...
                                       CDF_num2str(P.mon,2),'_Ship_Diurnal_Signal',...
                                       '_relative_to_',P.relative,'.mat'];
                load(file_diurnal,'Day_indicator','C98_UID');
                if P.diurnal_QC == 1
                    l_rm = ~ismember(Day_indicator,[0 1]);
                    C98_UID(l_rm) = [];
                end
                l_use  = ismember(DATA(1,:),C98_UID) & ismember(DATA(2,:),C98_UID);
                DATA = DATA(:,l_use);
                clear('l_use','Day_indicator','l_rm','C98_UID','dir_diurnal','file_diurnal')
            end
        end

        % *****************************************************************
        % Load data with corresponding Ship information
        % *****************************************************************
        PP = P;     PP.C98_UID = DATA(1,:);
        P1 = LME_pair_function_read_data(PP);    clear('PP')
        PP = P;     PP.C98_UID = DATA(2,:);
        P2 = LME_pair_function_read_data(PP);    clear('PP')
        var_list = fieldnames(P1);

        % *********************************************************************
        % Reassign measurement methods
        % *********************************************************************
        P1 = LME_function_preprocess_SST_method(P1);
        P2 = LME_function_preprocess_SST_method(P2);

        % *****************************************************************
        % Remove pairs that come from the same group
        % This step is important, becase we did not process ID information
        % in step 1.
        % This part can be expended to remove data using other criteria
        % *****************************************************************
        clear('l_rm')
        grp1 = [P1.DCK P1.C0_SI_4'];
        grp2 = [P2.DCK P2.C0_SI_4'];
        if strcmp(P.type,'Bucket_vs_Bucket')
            l_rm = all(grp1 == grp2,2);
        elseif strcmp(P.type,'Bucket_vs_ERI')
            l_rm = (P1.C0_SI_4 == 3 | P2.C0_SI_4 == 3);
            if isfield(P,'all_ERI_in_one_group')
                if P.all_ERI_in_one_group == 1
                    l1 = grp1(:,end) == 1;
                    l2 = grp2(:,end) == 1;
                    grp1(l1,:) = 1;
                    grp2(l2,:) = 1;
                end
            end
            l_rm = all(grp1 == grp2,2) | l_rm';
        elseif strcmp(P.type,'ERI_vs_ERI')
            l_rm = (P1.C0_SI_4 == 3 | P2.C0_SI_4 == 3);
            l_rm = all(grp1 == grp2,2) | l_rm';
        elseif strcmp(P.type,'ERI_vs_Bucket')
            l_rm = (P1.C0_SI_4 == 3 | P2.C0_SI_4 == 3);
            if isfield(P,'all_BCK_in_one_group')
                if P.all_BCK_in_one_group == 1
                    l1 = grp1(:,end) == 0;
                    l2 = grp2(:,end) == 0;
                    grp1(l1,:) = 0;
                    grp2(l2,:) = 0;
                end
            end
            l_rm = all(grp1 == grp2,2) | l_rm';
        elseif strcmp(P.type,'ERIex_vs_ERIex')
            l_rm = all(grp1 == grp2,2);
        elseif strcmp(P.type,'ERIex_vs_Bucket')
            if isfield(P,'all_BCK_in_one_group')
                if P.all_BCK_in_one_group == 1
                    l1 = grp1(:,end) == 0;
                    l2 = grp2(:,end) == 0;
                    grp1(l1,:) = 0;
                    grp2(l2,:) = 0;
                end
            end
            l_rm = all(grp1 == grp2,2);
        elseif strcmp(P.type,'Ship_vs_Ship')
            l_rm = (ismember(P1.C0_SI_4,[2 5 6 11 12]) | ismember(P2.C0_SI_4,[2 5 6 11 12]));
            l_rm = all(grp1 == grp2,2) | l_rm';
        end

        if isfield(P,'use_C0_SI_2')
            if P.use_C0_SI_2 == 1
                l_si2_1 = ~ismember(P1.C0_SI_2,[0 1 -2 3]);
                l_si2_2 = ~ismember(P2.C0_SI_2,[0 1 -2 3]);
            end
            l_rm = l_rm | l_si2_1' | l_si2_2';
        end

        if isfield(P,'do_nighttime_LME')
            % C1_ND == 1 night;   == 2 day
            if P.do_nighttime_LME == 1
                l_day_1 = P1.C1_ND == 2;
                l_day_2 = P2.C1_ND == 2;
            end
            l_rm = l_rm | l_day_1' | l_day_2';
        end

        % for var = 1:numel(var_list)
        %     if ~ismember(var_list{var},{'C0_ID','C0_CTY_CRT','DCK'}),
        %         eval(['P1.',var_list{var},' = P1.',var_list{var},'(~l_rm);']);
        %         eval(['P2.',var_list{var},' = P2.',var_list{var},'(~l_rm);']);
        %     else
        %         eval(['P1.',var_list{var},' = P1.',var_list{var},'(~l_rm,:);']);
        %         eval(['P2.',var_list{var},' = P2.',var_list{var},'(~l_rm,:);']);
        %     end
        % end

        DATA = DATA(:,~l_rm);
        clear('l_rm','P1','P2');

        % *****************************************************************
        % compute distance of individual pairs
        % *****************************************************************
        clear('dist_s','dist_t','dist')
        dist_s = DATA(3,:);
        dist_t = DATA(4,:);
        dist = dist_t / 12 + dist_s;
        [~,I] = sort(dist);

        % *****************************************************************
        % To transform UID into numbers
        % *****************************************************************
        UID_pairs           = [DATA(1,:)' DATA(2,:)'];
        [point_uni,~,J_uid] = unique(UID_pairs(:));
        NN                  = size(UID_pairs,1);
        J_uid_pairs         = [J_uid(1:NN) J_uid((NN+1):end)];

        % *****************************************************************
        % Remove ships that does not provide additional information
        % *****************************************************************
        disp('eliminating duplicate pairs')
        % each individual data point is only used once
        logic_point = false(1,numel(point_uni));
        logic_use_pairs = false(1,size(J_uid_pairs,1));
        for ct = I  % starting searching from the smallest distance

            clear('logic_1','logic_2')
            logic_1 = logic_point(J_uid_pairs(ct,1));
            logic_2 = logic_point(J_uid_pairs(ct,2));

            if logic_1 == 0 && logic_2 == 0
                logic_point(1,J_uid_pairs(ct,:)) = 1;
                logic_use_pairs(ct) = 1;
            end
        end
        clear('ct','ct1','ct2','dist_sort','dist','dist_s','dist_t')

        % *****************************************************************
        % Screening the pairs
        % *****************************************************************
        DATA_save   = DATA([1 2 5 6],logic_use_pairs);

        % *****************************************************************
        % File name for saving data
        % *****************************************************************
        disp('saving data ...')
        file_save = [dir_save,'IMMA1_R3.0.0_',num2str(P.yr),'-',...
                                   CDF_num2str(P.mon,2),'_',P.save_app,'.mat'];
        save(file_save,'DATA_save','-v7.3');
    end
end
