% This is a trial that treats individual decks as a hierarchical structure
% under their belonging nations

function LME_lme_fit_hierarchy(P)

    % *********************************************************************
    % Load aggregated pairs
    % *********************************************************************
    disp('==============================================================>')
    disp('Start Fitting the (hierarchical) LME model ...')
    dir_load = LME_OI('bin_pairs');
    file_load = [dir_load,'Binned_pairs_',P.save_bin,'.mat'];
    load(file_load,'BINNED','W_X');

    % *********************************************************************
    % Assign data and effects
    % *********************************************************************
    clear('D')
    D.W_X   = W_X;
    P.N_grp = size(BINNED.Bin_kind,2)/2;
    D.kind_cmp_1 = double(BINNED.Bin_kind(:,1:P.N_grp));
    D.kind_cmp_2 = double(BINNED.Bin_kind(:,P.N_grp+1:end));

    D.group_season = double(BINNED.Bin_season);
    D.group_region = double(BINNED.Bin_region);
    D.group_decade = double(BINNED.Bin_decade);
    D.weigh_use    = double(BINNED.Bin_w);
    D.data_cmp     = double(BINNED.Bin_y);

    % *********************************************************************
    % Convert grouping into numbers     
    % kind_cmp = unique_grp(J_grp,:);   
    % *********************************************************************
    P.N_pairs = size(D.data_cmp,1);
    [D.unique_grp,~,J_grp] = unique([D.kind_cmp_1;D.kind_cmp_2],'rows');
    D.J_grp_1 = J_grp(1:P.N_pairs);
    D.J_grp_2 = J_grp(P.N_pairs+1:end);
    P.N_groups = size(D.unique_grp,1);

    % *********************************************************************
    % See how many subgroups to the comparison form 
    % Typically, there should be one group          
    % *********************************************************************
    [JJ_grp,~,~] = unique([D.J_grp_1 D.J_grp_2],'rows');
    clusters = LME_function_find_group(JJ_grp);
    P.N_clusters = size(clusters,1);
    
    if P.N_clusters ~= 1,
        error(['This LME should be broken into ',num2str(P.N_clusters),' runs']);
    end
    disp(' ')
    
    % *********************************************************************
    % Prepare for the Design Matrices of LME
    % *********************************************************************
    disp('==============================================================>')
    disp('Assign Matrices ...')
    if P.target == 0,

        if P.do_hierarchy == 0,

            [M,P] = LME_lme_matrix(D,P);

        else

            [W_out,L] = LME_lme_build_hierarchy(D,P);

            % *************************************************************
            % Assign Matrix as if using nations to compute LME          
            % *************************************************************
            clear('DD_nat','PP_nat')
            DD_nat = D;
            [D.unique_nat,~,J_nat] = unique([D.kind_cmp_1(:,P.nation_id); ... 
                                           D.kind_cmp_2(:,P.nation_id)],'rows');
            DD_nat.J_grp_1    = J_nat(1:P.N_pairs);
            DD_nat.J_grp_2    = J_nat(P.N_pairs+1:end);
            DD_nat.kind_cmp_1 = D.kind_cmp_1(:,P.nation_id);
            DD_nat.kind_cmp_2 = D.kind_cmp_2(:,P.nation_id);
            P.N_nat           = size(D.unique_nat,1);
            DD_nat.W_X        = W_out(:,1:P.N_nat);
            
            PP_nat = P;
            PP_nat.N_groups = P.N_nat;
            
            M_nat = LME_lme_matrix(DD_nat,PP_nat);

            % *************************************************************
            % Assign Matrix as if using nation-deck to compute LME          
            % *************************************************************
            clear('DD_dck','PP_dck')
            DD_dck = D;
            DD_dck.W_X        = W_out(:,(1+P.N_nat):end);
            
            PP_dck = P;
            
            M_dck = LME_lme_matrix(DD_dck,PP_dck);

            % *************************************************************
            % This function merges the matrice at nation and deck levels
            % given the information of grouping and deck in L
            % *************************************************************
            M = LME_merge_nat_deck_matrices(M_nat,M_dck,L,P);

        end

        M.N_decade = max(D.group_decade);
        M.N_region = max(D.group_region);
        M.N_season = max(D.group_season);

    end
    disp('Matrices Assigned~!')
    disp(' ')
    
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % To be done, adding relative to a nation function !!
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    % *********************************************************************
    % Remove Non-informative Pairs
    % *********************************************************************
    clear('logic_non')
    logic_non(:,1) = all(M.X_in == 0,2);
    if M.do_random == 1,
        for i = 1:numel(M.Z_in)
            logic_non(:,i+1) = all(M.Z_in{i} == 0,2);
        end
    end
    logic_non = all(logic_non,2);
    disp(['Remove ',num2str(nnz(logic_non)),' non informative pairs'])

    M.X_in(logic_non,:) = [];
    M.Y(logic_non) = [];
    M.W(logic_non) = [];
    if M.do_random == 1,
        for i=1:numel(M.Z_in)
            M.Z_in{i}(logic_non,:) = [];
        end
    end
    disp(' ')

    % *********************************************************************
    % Fitting the LME model 
    % *********************************************************************
    disp('==============================================================>')
    disp('Fit the LME model ...')
    clear('JJ_grp','J_grp','J_nat','M_nat')
    clear('BINNED','DD_dck','DD_nat','PP_dck','PP_nat')
    clear('W_X','W_out','clusters','logic_non')
    
    if M.do_random == 0,
        lme = fitlmematrix(double(M.X_in),double(M.Y),[],[],...
            'FitMethod','ML','Weights',double(M.W));
    else
        lme = fitlmematrix(double(M.X_in),double(M.Y),M.Z_in,[],...
            'Covariancepattern',M.structure,'FitMethod','ML',...
            'Weights',double(M.W));
    end
    disp('LME model fitted!')
    disp(' ')
    Fitted = lme.fitted;
    
    %% *********************************************************************
    % Post-processing 
    % *********************************************************************
    disp('==============================================================>')
    disp('Start post-processing ...')
    if P.target == 0,

        if P.do_hierarchy == 0,

            out = LME_lme_post(M,lme,D,P);

            out_temp = out;
            clear('out','out_rnd')
            
            % -------------------------------------------------------------
            out.bias_fixed                  = out_temp.bias_fixed;
            out.bias_fixed_std              = out_temp.bias_fixed_std;
            out.unique_grp                  = out_temp.unique_grp;
            out.Covariance_fixed            = out_temp.Covariance_fixed;
            out.Covariance_conditional      = out_temp.Covariance_conditional;
            out.MSE                         = out_temp.MSE;
            out.Y_hat                       = out_temp.Y_hat;
            out.Y_raw                       = out_temp.Y_raw;
            if P.do_region == 1, 
                out.bias_region             = out_temp.bias_region; 
                out.bias_region_std         = out_temp.bias_region_std;
            end
            if P.do_decade == 1, 
                out.bias_decade             = out_temp.bias_decade; 
                out.bias_decade_std         = out_temp.bias_decade_std;
            end
            if P.do_season == 1, 
                out.bias_season             = out_temp.bias_season; 
                out.bias_season_std         = out_temp.bias_season_std;
            end

            % -------------------------------------------------------------
            out_rnd.bias_fixed_random       = out_temp.bias_fixed_random;
            out_rnd.unique_grp              = out_temp.unique_grp;
            if P.do_region == 1, 
                out_rnd.bias_region_rnd     = out_temp.bias_region_rnd; 
            end
            if P.do_decade == 1, 
                out_rnd.bias_decade_rnd     = out_temp.bias_decade_rnd; 
            end
            if P.do_season == 1, 
                out_rnd.bias_season_rnd     = out_temp.bias_season_rnd; 
            end  

            %% ************************************************************
            % Saving Data 
            % *************************************************************
            disp(' ')
            disp('==============================================================>')
            disp('Saving Data ...')
            dir_save = LME_OI('LME_output');
            file_save = [dir_save,'LME_',P.save_lme,'.mat'];
            save(file_save,'out','out_rnd','lme','-v7.3')

        else

            out = LME_lme_post_hierarchy(M,lme,D,P);
            out = LME_lme_post_mask_effects(out,M_dck,P);
            
            %%
            out_temp = out;
            clear('out','out_nat','out_dck','out_rnd','out_rnd_nat','out_rnd_dck')
            
            % -------------------------------------------------------------
            out.bias_fixed                  = out_temp.bias_fixed;
            out.bias_fixed_std              = out_temp.bias_fixed_std;
            out.unique_grp                  = out_temp.unique_grp;
            out.Covariance_fixed            = out_temp.Covariance_fixed;
            if M.do_random == 1,
                out.Covariance_conditional      = out_temp.Covariance_conditional;
            end
            out.MSE                         = out_temp.MSE;
            out.Y_hat                       = out_temp.Y_hat;
            out.Y_raw                       = out_temp.Y_raw;
            if P.do_region == 1, 
                out.bias_region             = out_temp.bias_region; 
                out.bias_region_std         = out_temp.bias_region_std;
            end
            if P.do_decade == 1, 
                out.bias_decade             = out_temp.bias_decade; 
                out.bias_decade_std         = out_temp.bias_decade_std;
            end
            if P.do_season == 1, 
                out.bias_season             = out_temp.bias_season; 
                out.bias_season_std         = out_temp.bias_season_std;
            end
            
            % -------------------------------------------------------------
            out_nat.bias_fixed_nat          = out_temp.bias_fixed_nat;
            out_nat.bias_fixed_std_nat      = out_temp.bias_fixed_std_nat;
            out_nat.unique_nat              = out_temp.unique_nat;
            if P.do_region == 1, 
                out_nat.bias_region_nat     = out_temp.bias_region_nat; 
                out_nat.bias_region_std_nat = out_temp.bias_region_std_nat;
            end
            if P.do_decade == 1, 
                out_nat.bias_decade_nat     = out_temp.bias_decade_nat; 
                out_nat.bias_decade_std_nat = out_temp.bias_decade_std_nat;
            end
            if P.do_season == 1, 
                out_nat.bias_season_nat     = out_temp.bias_season_nat; 
                out_nat.bias_season_std_nat = out_temp.bias_season_std_nat;
            end

            % -------------------------------------------------------------
            out_dck.bias_fixed_dck          = out_temp.bias_fixed_dck;
            out_dck.bias_fixed_std_dck      = out_temp.bias_fixed_std_dck;
            out_dck.unique_grp              = out_temp.unique_grp;
            if P.do_region == 1, 
                out_dck.bias_region_dck     = out_temp.bias_region_dck; 
                out_dck.bias_region_std_dck = out_temp.bias_region_std_dck;
            end
            if P.do_decade == 1, 
                out_dck.bias_decade_dck     = out_temp.bias_decade_dck; 
                out_dck.bias_decade_std_dck = out_temp.bias_decade_std_dck;
            end
            if P.do_season == 1, 
                out_dck.bias_season_dck     = out_temp.bias_season_dck; 
                out_dck.bias_season_std_dck = out_temp.bias_season_std_dck;
            end

            % -------------------------------------------------------------
            out_rnd.bias_fixed_random       = out_temp.bias_fixed_random;
            out_rnd.unique_grp              = out_temp.unique_grp;
            if P.do_region == 1, 
                out_rnd.bias_region_rnd     = out_temp.bias_region_rnd; 
            end
            if P.do_decade == 1, 
                out_rnd.bias_decade_rnd     = out_temp.bias_decade_rnd; 
            end
            if P.do_season == 1, 
                out_rnd.bias_season_rnd     = out_temp.bias_season_rnd; 
            end  

            % -------------------------------------------------------------
            out_rnd_nat.bias_fixed_random_nat   = out_temp.bias_fixed_rnd_nat;
            out_rnd_nat.unique_grp              = out_temp.unique_nat;
            if P.do_region == 1, 
                out_rnd_nat.bias_region_rnd_nat = out_temp.bias_region_rnd_nat; 
            end
            if P.do_decade == 1, 
                out_rnd_nat.bias_decade_rnd_nat = out_temp.bias_decade_rnd_nat; 
            end
            if P.do_season == 1, 
                out_rnd_nat.bias_season_rnd_nat = out_temp.bias_season_rnd_nat; 
            end  

            % -------------------------------------------------------------
            out_rnd_dck.bias_fixed_random_dck   = out_temp.bias_fixed_rnd_dck;
            out_rnd_dck.unique_grp              = out_temp.unique_grp;
            if P.do_region == 1, 
                out_rnd_dck.bias_region_rnd_dck = out_temp.bias_region_rnd_dck; 
            end
            if P.do_decade == 1, 
                out_rnd_dck.bias_decade_rnd_dck = out_temp.bias_decade_rnd_dck; 
            end
            if P.do_season == 1, 
                out_rnd_dck.bias_season_rnd_dck = out_temp.bias_season_rnd_dck; 
            end 
            
            clear('out_temp')
            
            %% ************************************************************
            % Saving Data 
            % *************************************************************
            disp(' ')
            disp('==============================================================>')
            disp('Saving Data ...')
            dir_save = LME_OI('LME_output');
            file_save = [dir_save,'LME_',P.save_lme,'.mat'];
            save(file_save,'out','out_nat','out_dck',...
                'out_rnd','out_rnd_nat','out_rnd_dck','lme','-v7.3')
            
        end
    end
    disp(' ')
    disp('LME analysis completes!')
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % To be done, adding relative to a nation function !!
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end
