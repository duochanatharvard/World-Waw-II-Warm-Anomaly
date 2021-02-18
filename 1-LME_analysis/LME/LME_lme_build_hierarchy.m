% To run this code, you must have nation + deck setup

function [W_out,L] = LME_lme_build_hierarchy(D,P)

    % ***********************************
    % Generate weights for fixed effects
    % ***********************************
    kind_uni = unique([D.kind_cmp_1;D.kind_cmp_2],'rows');
    [nat_uni,~,J_nat]  = unique(kind_uni(:,P.nation_id),'rows');
    N_nat = size(nat_uni,1);
    N_dck = size(kind_uni,1);

    W_out = zeros(0,N_nat + N_dck);
    logic_r_nat = false(1,N_nat);
    logic_r_dck = false(1,N_dck);

    for ct = 1:max(J_nat)
        logic = J_nat == ct;
        W_out(1,ct) = nansum(D.W_X(logic));
        W_out(ct+1,N_nat + find(logic)) = D.W_X(logic)./nansum(D.W_X(logic));
        if nnz(logic) == 1,
            logic_r_nat(ct) = 1;
            logic_r_dck(find(logic)) = 1;
        end
    end
    L.logic_r_dck = logic_r_dck;

    W_out(1+find(logic_r_nat),:) = [];
    % W_out(:,N_nat + find(logic_r_dck)) = []; commented out to be compatible
    % Here, logic_r_dck is the reference that which deck should be
    % kicked out in the deck level fitting because there is only
    % one deck in that nation

    % ********************************************
    % Generate kick out matrix for yearly effects
    % ********************************************
    if all(D.group_decade) ~= 0,
        
        N_yr = max(D.group_decade);
        logic_r_dck_yr = false(N_yr,N_dck);
        
        for ct_yr = 1:N_yr
            
            l = D.group_decade == ct_yr;
            kind_uni_yr = unique([D.kind_cmp_1(l,:);D.kind_cmp_2(l,:)],'rows');
            [nat_uni_yr,~,J_nat_yr]  = unique(kind_uni_yr(:,[P.nation_id]),'rows');
            
            for ct = 1:max(J_nat_yr)
                
                logic = J_nat_yr == ct;
                
                if nnz(logic) == 1,
                    id = ismember(kind_uni(:,P.nation_id),nat_uni_yr(ct,:),'rows');
                    logic_r_dck_yr(ct_yr,id) = 1;
                end
            end
        end
        
        logic_r_dck_yr(:,logic_r_dck) = 1;
        L.logic_r_dck_dcd = logic_r_dck_yr;
    end

    % ********************************************
    % Generate kick out matrix for regional effects
    % ********************************************
    if all(D.group_region) ~= 0,
        
        N_rg = max(D.group_region);
        logic_r_dck_rg = false(N_rg,N_dck);
        
        for ct_rg = 1:N_rg
            
            l = D.group_region == ct_rg;
            kind_uni_rg = unique([D.kind_cmp_1(l,:);D.kind_cmp_2(l,:)],'rows');
            [nat_uni_rg,~,J_nat_rg]  = unique(kind_uni_rg(:,[P.nation_id]),'rows');

            for ct = 1:max(J_nat_rg)
                
                logic = J_nat_rg == ct;
                
                if nnz(logic) == 1,
                    
                    id = ismember(kind_uni(:,P.nation_id),nat_uni_rg(ct,:),'rows');
                    logic_r_dck_rg(ct_rg,id) = 1;
                end
            end
        end
        
        logic_r_dck_rg(:,logic_r_dck) = 1;
        L.logic_r_dck_reg = logic_r_dck_rg;
    end

    % ********************************************
    % Generate kick out matrix for seasonal effects
    % ********************************************
    if all(D.group_season) ~= 0,
        
        N_se = max(D.group_season);
        logic_r_dck_se = false(N_se,N_dck);
        
        for ct_se = 1:N_se
            
            l = D.group_season == ct_se;
            kind_uni_se = unique([D.kind_cmp_1(l,:);D.kind_cmp_2(l,:)],'rows');
            [nat_uni_se,~,J_nat_se]  = unique(kind_uni_se(:,P.nation_id),'rows');
            
            for ct = 1:max(J_nat_se)
                
                logic = J_nat_se == ct;
                
                if nnz(logic) == 1,
                    id = ismember(kind_uni(:,P.nation_id),nat_uni_se(ct,:),'rows');
                    logic_r_dck_se(ct_se,id) = 1;
                end
            end
        end
        
        logic_r_dck_se(:,logic_r_dck) = 1;
        L.logic_r_dck_sea = logic_r_dck_se;
    end
end
