addpath('/n/home10/dchan/script/Peter/Hvd_SST/ICOADS_preprocess/');
addpath('/n/home10/dchan/Matlab_Tool_Box/');
if 0
    [y_st,m_st] = ind2sub([100,12],num);
    for yr = (1659+y_st):100:2014
        for mon = m_st
            ICOADS_Step_02_pre_QC_not_infer_SST_methods(yr, mon);
        end
    end
else
    [m_st,y_st] = ind2sub([12,6],num);
    for yr = 2014+y_st
        for mon = m_st
            ICOADS_Step_02_pre_QC_not_infer_SST_methods(yr,mon);
        end
    end
end
