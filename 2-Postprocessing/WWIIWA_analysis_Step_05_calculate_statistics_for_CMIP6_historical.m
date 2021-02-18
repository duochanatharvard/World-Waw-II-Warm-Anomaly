clear;

dir_cmip = '/Users/duochan/Data/CMIP6/';
dir_save = '/Users/duochan/Dropbox/Git_code/World-Waw-II-Warm-Anomaly/Data/';
dir_pi   = [dir_cmip,'tos_monthly_processed/'];
file_name = CDF_filenames(dir_pi);

% =========================================================================
% Compute statistics for historical simulations      
% =========================================================================
clear('CMIP5_his')
for ct = 1:numel(file_name)

    list = find(ismember(file_name{ct},'_'));
    CMIP6_hist.name{ct,1} = file_name{ct}(list(2)+1 : list(3)-1);
    CMIP6_hist.name{ct,2} = file_name{ct}(list(4)+1 : list(5)-1);
    
    file = [dir_pi,file_name{ct}];
    clear('raw','raw_detrd')
    raw = ncread(file,'tos');
    raw_demean = CDC_demean(raw,3,12);
    disp(CMIP6_hist.name{ct,1})
    
    tos = reshape(raw_demean,72,36,12,165);  
    
    [CMIP6_hist.SST_glb(:,:,ct),CMIP6_hist.sst_var(ct)] = WWIIWA_analysis_calculate_statistics(tos,1850:2014);
    
    clear('raw','raw_detrd','tos')
end

file_save = [dir_save,'WWIIWA_statistics_for_CMIP6_historical_runs.mat'];
save(file_save,'CMIP6_hist','-v7.3')