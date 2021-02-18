function [WM,ST,NUM] = LME_correct_infer_day_night(P)
    
    % *********************************************************************
    % O/I 
    % *********************************************************************
    if ~exist('env','var')
        env = 1;            % 1 means on odyssey
    end

    if ~isfield(P,'connect_Kobe')
        P.connect_Kobe = 0;
    end

    if ~isfield(P,'do_add_JP')
        P.do_add_JP = 0;
    end

    if ~isfield(P,'do_rmdup')
        P.do_rmdup = 0;
    end

    % *********************************************************************
    % Set Parameters for gridding 
    % *********************************************************************
    reso_x = P.reso_x;
    reso_y = P.reso_y;
    yr_list = P.yr_list;
    yr_num = numel(yr_list);

    if P.en == 0
        P.do_individual = 0;
    end

    mon_list = 1:12;

    if P.en == 0 || P.do_individual == 1
        P.do_random = 0;
    else
        P.do_random = 1;
    end

    % *********************************************************************
    % Read the LME outputs 
    % & 
    % Assigning effects to be corrected 
    % *********************************************************************
    % dir_lme = LME_OI('LME_output');
    dir_lme = LME_OI('LME_output');
    % dir_lme = '/n/home10/dchan/holy_kuang/LME_intercomparison/Step_04_LME_output_v18/';
    if numel(P.mon_list) == 12

        file_lme = [dir_lme,'LME_',P.save_lme,'.mat'];
        lme = load(file_lme,'out','out_rnd');
        
        clear('E')
        E = LME_correct_assign_effect(lme,P);
    else
        mon_abb = 'JFMAMJJASOND';
        clear('E','lme_groups')

        for ct = 8
            li = [ct-1 ct ct+1];  li(li<1) = li(li<1) + 12;  li(li>12) = li(li>12) - 12;
            file_lme = [dir_lme,'LME_',P.save_sum,'_mon_',mon_abb(li),'.mat'];
            disp(file_lme)
            temp = load(file_lme,'out');
            grp_ref = temp.out.unique_grp;
        end

       for ct = 1:12
            li = [ct-1 ct ct+1];  li(li<1) = li(li<1) + 12;  li(li>12) = li(li>12) - 12;
            file_lme = [dir_lme,'LME_',P.save_sum,'_mon_',mon_abb(li),'.mat'];
            disp(file_lme)
            lme  = load(file_lme,'out','out_rnd');

            l_grp = ismember(grp_ref,lme.out.unique_grp,'rows');

            clear('lme_temp','temp','temp2')
            lme_temp.out.bias_fixed                     = zeros(numel(l_grp),1);
            lme_temp.out.bias_fixed_random              = zeros(1000,numel(l_grp));
            lme_temp.out.bias_fixed(l_grp)              = lme.out.bias_fixed;
            lme_temp.out_rnd.bias_fixed_random(:,l_grp) = lme.out_rnd.bias_fixed_random;
            

            if P.do_region == 1
                lme_temp.out.bias_region                    = zeros(17,numel(l_grp));
                lme_temp.out.bias_region_rnd                = zeros(17,numel(l_grp),1000);
                lme_temp.out.bias_region(:,l_grp)           = lme.out.bias_region;
                lme_temp.out_rnd.bias_region_rnd(:,l_grp,:) = lme.out_rnd.bias_region_rnd;
            end

            if P.do_season == 1
                lme_temp.out.bias_season                    = zeros(16,numel(l_grp));
                lme_temp.out.bias_season_rnd                = zeros(16,numel(l_grp),1000);
                lme_temp.out.bias_season(:,l_grp)           = lme.out.bias_season;
                lme_temp.out_rnd.bias_season_rnd(:,l_grp,:) = lme.out_rnd.bias_season_rnd;
            end

            if P.do_decade == 1
                lme_temp.out.bias_decade                    = zeros(33,numel(l_grp));
                lme_temp.out.bias_decade_rnd                = zeros(33,numel(l_grp),1000);
                lme_temp.out.bias_decade(:,l_grp)           = lme.out.bias_decade;
                lme_temp.out_rnd.bias_decade_rnd(:,l_grp,:) = lme.out_rnd.bias_decade_rnd;
            end
            
            temp = LME_correct_assign_effect(lme_temp,P);
            E{ct} = temp;
            lme_groups{ct} = grp_ref; % lme.out.unique_grp;
        end
        clear('lme','lme_temp')

    end

    % *********************************************************************
    % Initialize the correction 
    % *********************************************************************
    N = double(P.do_region) + double(P.do_season) + double(P.do_decade) + 3;

    clear('WM','ST','NUM')
    if P.en == 0 && P.do_individual == 0
        WM  = nan(360/reso_x,180/reso_y,N,12,yr_num);
        ST  = nan(360/reso_x,180/reso_y,N,12,yr_num);
        NUM = nan(360/reso_x,180/reso_y,N,12,yr_num);
    else
        WM  = nan(360/reso_x,180/reso_y,12,yr_num);
        ST  = nan(360/reso_x,180/reso_y,12,yr_num);
        NUM = nan(360/reso_x,180/reso_y,12,yr_num);
    end

    % *********************************************************************
    % Start the correction 
    % *********************************************************************
    for yr = yr_list
        for mon = mon_list

            disp(['En :',num2str(P.en),' Starting Year ',...
                                      num2str(yr),'  Month ',num2str(mon)])

            % *************************************************************
            % Read in files 
            % *************************************************************
            disp('Reading data ...')
            clear('DATA')
            PP = P;  PP.yr  = yr;  PP.mon = mon;   PP.mute_read = 1; % PP.do_nighttime_LME = 1;
            DATA = LME_pair_function_read_data(PP);
            DATA = LME_function_preprocess_SST_method(DATA);

            % remove non-ship and non bucket, ERI, Hull, or missing SSTs
            if strcmp(P.method,'Ship')
                
                target_list = [-1 0 1 3 13 14];
                if isfield(P,'only_correct')
                    target_list = P.only_correct;
                end
               
                if numel(target_list) > 1 
                    l_rm = ~ismember(DATA.C0_SI_4,target_list);
                else
                    l_use = ismember(DATA.C0_SI_4,target_list);
                    % below are inferred methods
                    if target_list == 1  % ERI
                        l_use_2 = DATA.C0_YR >= 1930 & DATA.C0_SI_4 == -1 & ismember(DATA.C0_CTY_CRT,'US','rows')';
				        l_rm = ~l_use & ~l_use_2;
                    elseif target_list == 0   % Bucket
                        switch P.exp_bck_id
                            case 1
                                l_use_2 = DATA.C0_SI_4 == -1 & DATA.C1_DCK == 245;
                            case 2
                                l_use_2 = DATA.C0_SI_4 == -1 & DATA.C1_DCK == 118;
                            case 3
                                l_use_2 = DATA.C0_SI_4 == -1 & (DATA.C1_DCK == 245 | DATA.C1_DCK == 118);
                            case 4 
                                l_use_2 = DATA.C0_SI_4 == 99999;  % use only bucket and do not infer anything
                        end
                        l_rm = ~l_use & ~l_use_2;
                    end
                end 

                % remove daytime or nighttime measurements
                if P.do_day == 1
                   l_use_3 = DATA.C1_ND == 2;
                else
                   l_use_3 = DATA.C1_ND == 1;
                end
                l_rm = l_rm | ~l_use_3;
       
                var_list = fieldnames(DATA);
                for var = 1:numel(var_list)
                    if ~ismember(var_list{var},{'C0_ID','C0_CTY_CRT','DCK'})
                        eval(['DATA.',var_list{var},'(l_rm) = [];']);
                    else
                        eval(['DATA.',var_list{var},'(l_rm,:) = [];']);
                    end
                end
            end
            kind = [DATA.DCK DATA.C0_SI_4'];

            if strcmp(P.type,'Bucket_vs_ERI')
                if isfield(P,'all_ERI_in_one_group')
                    if P.all_ERI_in_one_group == 1
                        kind(kind(:,end) == 1,:) = 1;
                    end
                end
            end

            if strcmp(P.type,'ERI_vs_Bucket') || strcmp(P.type,'ERIex_vs_Bucket')
                if isfield(P,'all_BCK_in_one_group')
                    if P.all_BCK_in_one_group == 1
                        kind(kind(:,end) == 0,:) = 0;
                    end
                end
            end
              
            % *************************************************************
            % Assigning Effects
            % *************************************************************
            disp(['Assigning effects ...'])
            clear('ID')
            if P.do_region == 1
                ID.rid = LME_lme_effect_regional(DATA.C0_LON,DATA.C0_LAT,5);
            end

            if P.do_season == 1
                ID.sid = LME_lme_effect_seasonal(DATA.C0_LAT,DATA.C0_MO);
            end

            if P.do_decade == 1
                ID.did = LME_lme_effect_decadal(DATA.C0_YR,P);
            end
            clear('mx','my')

            % *************************************************************
            % Applying Correction 
            % The correction follows: 1. all 2.fix 3.reg 4.dcd 5.sea
            % the output is correction but not bias
            % *************************************************************
            disp(['Applying Correction ...'])
            if numel(P.mon_list) == 12
                clear('CORR')
                CORR = LME_correct_find_corr(DATA,E,P,ID,kind,lme.out.unique_grp);
            else
                clear('CORR_NH','CORR_SH','CORR')
                m_NH = mon;
                CORR_NH = LME_correct_find_corr(DATA,E{m_NH},P,ID,kind,lme_groups{m_NH});
                m_SH = mon + 6;  m_SH(m_SH<1) = m_SH(m_SH<1) + 12;  m_SH(m_SH>12) = m_SH(m_SH>12) - 12;
                CORR_SH = LME_correct_find_corr(DATA,E{m_SH},P,ID,kind,lme_groups{m_SH});
                l_NH = DATA.C0_LAT > 0;
                CORR.sst_correction(:,l_NH) = CORR_NH.sst_correction(:,l_NH);
                CORR.sst_correction(:,~l_NH) = CORR_SH.sst_correction(:,~l_NH);
            end

            % *************************************************************
            % Gridding data 
            % *************************************************************
            disp(['Gridding data ...'])
            yr_id = yr-yr_list(1)+1;

            if P.en == 0 && P.do_individual == 0

                for ct = 1:size(CORR.sst_correction,1)+1
                    
                    if ct == 1
                        SST_in = DATA.C0_SST- DATA.C0_OI_CLIM;
                    else
                        SST_in = nansum([DATA.C0_SST- DATA.C0_OI_CLIM; CORR.sst_correction(ct-1,:)],1);
                    end

                    [WM(:,:,ct,mon,yr_id),ST(:,:,ct,mon,yr_id),NUM(:,:,ct,mon,yr_id)] = ...
                    LME_function_gridding(DATA.C0_LON,DATA.C0_LAT,[],SST_in,[],reso_x,reso_y,[],2,[],[],[]);
                end
                
            else

                SST_in = nansum([DATA.C0_SST- DATA.C0_OI_CLIM; CORR.sst_correction(1,:)],1);

                [WM(:,:,mon,yr_id),ST(:,:,yr_id),NUM(:,:,mon,yr_id)] = ...
                LME_function_gridding(DATA.C0_LON,DATA.C0_LAT,[],SST_in,[],reso_x,reso_y,[],2,[],[],[]);

            end
        end
    end
end
