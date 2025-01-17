clear;

dir_cmip = '/Users/duochan/Data/CMIP6/';
dir_save = '/Users/duochan/Dropbox/Git_code/World-Waw-II-Warm-Anomaly/Data/';
dir_pi   = [dir_cmip,'tos_monthly_piControl_processed/'];
file_name = CDF_filenames(dir_pi);

% =========================================================================
% Compute statistics for piControl simulations      
% =========================================================================
clear('CMIP6_pi')

mask_glb  = LME_analysis_mask_trd;
mask_mini = load('common_minimum_mask.mat');
mask      = mask_mini.common_minimum_mask(:,:,:,[1936:1950]-1929);

CMIP6_pi.SST_glb = [];
CMIP6_pi.sst_var = [];
N_yr = 0;
for ct = 1:numel(file_name)

    list = find(ismember(file_name{ct},'_'));
    CMIP6_pi.name{ct,1} = file_name{ct}(list(2)+1 : list(3)-1);
    CMIP6_pi.name{ct,2} = file_name{ct}(list(4)+1 : list(5)-1);

    file = [dir_pi,file_name{ct}];
    clear('raw','raw_detrd')
    raw = ncread(file,'tos');
    tos = CDC_detrend(raw,3,12);
    disp(CMIP6_pi.name{ct,1})
    N_yr = N_yr + size(tos,3)/12;
    
    n = fix(size(tos,3)/15/12)*15*12;
    tos = reshape(tos(:,:,1:n),72,36,12,15,n/12/15);
    tos(repmat(mask == 0,1,1,1,1,size(tos,5))) = nan;

    tos_ann = squeeze(nanmean(tos,3));
    tos_ann_n = squeeze(nansum(~isnan(tos),3));
    tos_ann(tos_ann_n < 6) = nan;
    
    var_15_yr        = squeeze(CDC_var(tos_ann,3));
    [SST_var,~,~]    = CDC_mask_mean(var_15_yr,-87.5:5:90,mask_glb);
    CMIP6_pi.sst_var = [CMIP6_pi.sst_var; SST_var];  
    
    clear('TS')
    [TS,~,~]     = CDC_mask_mean(tos,-87.5:5:87.5,mask_glb);
    CMIP6_pi.SST_glb  = cat(3,CMIP6_pi.SST_glb,TS);  
    
    CMIP6_pi.number(ct,1) = size(TS,3);
    
    clear('raw','raw_detrd','tos')
end

file_save = [dir_save,'WWIIWA_statistics_for_CMIP6_piControl_runs.mat'];
save(file_save,'CMIP6_pi','-v7.3')