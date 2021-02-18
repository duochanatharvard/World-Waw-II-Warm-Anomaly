function CORR = LME_correct_find_corr(DATA,E,P,ID,kind,kind_list)

    [kind_uni,~,J_kind] = unique(kind,'rows');

    clear('COR')
    NN = numel(DATA.C0_YR);
    COR.sst_correction_1 = nan(1,NN);
    if P.do_region == 1
        COR.sst_correction_2 = nan(1,NN);
    end
    if P.do_decade == 1
        COR.sst_correction_3 = nan(1,NN);
    end
    if P.do_season == 1
        COR.sst_correction_4 = nan(1,NN);
    end

    for i = 1:max(J_kind)

        [~,id] = ismember(kind_uni(i,:),kind_list,'rows');

        if nnz(id)

            COR.sst_correction_1(J_kind == i) = E.bias_fixed(id);

            if P.do_region == 1
                clear('tem','tem_crt')
                tem = ID.rid(J_kind == i);
                tem_crt = nan(1,nnz(J_kind == i));
                tem_crt(~isnan(tem)) = E.bias_region(tem(~isnan(tem)),id);
                COR.sst_correction_2(J_kind == i) = tem_crt;
            end

            if P.do_decade == 1
                COR.sst_correction_3(J_kind == i) = E.bias_decade(ID.did(J_kind == i),id);
            end

            if P.do_season == 1
                COR.sst_correction_4(J_kind == i) = E.bias_season(ID.sid(J_kind == i),id);
            end
        end
    end

    clear('temp')
    temp = COR.sst_correction_1;
    if P.do_region == 1
        temp = [temp; COR.sst_correction_2];
    end

    if P.do_decade == 1
        temp = [temp; COR.sst_correction_3];
    end

    if P.do_season == 1
        temp = [temp; COR.sst_correction_4];
    end

    CORR.sst_correction = nansum(temp,1);
    CORR.sst_correction = [CORR.sst_correction; temp];
    
    % Before this step, all the CORR in previous lines are in fact biases
    % But the function really returns the correction
    CORR.sst_correction = - CORR.sst_correction;
end
