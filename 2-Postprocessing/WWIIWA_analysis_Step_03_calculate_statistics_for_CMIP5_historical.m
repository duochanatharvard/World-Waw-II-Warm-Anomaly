clear;

dir_cmip = '/Users/duochan/Data/CMIP5/';
dir_save = '/Users/duochan/Dropbox/Git_code/World-Waw-II-Warm-Anomaly/Data/';
dir_pi   = [dir_cmip,'tos_monthly/'];
file_name = CDF_filenames(dir_pi);

% =========================================================================
% Compute statistics for historical simulations      
% =========================================================================
clear('CMIP5_his')
for ct = 1:numel(file_name)

    list = find(ismember(file_name{ct},'_'));
    CMIP5_hist.name{ct,1} = file_name{ct}(list(2)+1 : list(3)-1);
    CMIP5_hist.name{ct,2} = file_name{ct}(list(4)+1 : list(5)-1);
    
    file = [dir_pi,file_name{ct}];
    clear('raw','raw_detrd')
    raw = ncread(file,'tos');
    raw_demean = CDC_demean(raw,3,12);
    disp(CMIP5_hist.name{ct,1})

    clear('tos')
    tos = nan(72,36,size(raw_demean,3));
    for i = 1:72
        for j = 1:36
            tos(i,j,:) = nanmean(nanmean(raw_demean(i*2-1:i*2,j*2-1:j*2,:),1),2);
        end
    end
    
    tos = reshape(tos,72,36,12,231);  
    
    [CMIP5_hist.SST_glb(:,:,ct),CMIP5_hist.sst_var(ct)] = WWIIWA_analysis_calculate_statistics(tos,1870:2100);
    
    clear('raw','raw_detrd','tos')
end

file_save = [dir_save,'WWIIWA_statistics_for_CMIP5_historical_runs.mat'];
save(file_save,'CMIP5_hist','-v7.3')