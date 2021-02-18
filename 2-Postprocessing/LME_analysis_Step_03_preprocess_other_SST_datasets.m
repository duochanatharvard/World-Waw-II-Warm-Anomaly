clear;

% This script regrids all existing SST products to 5x5 resolution
dir_home = '/Users/duochan/Data/Other_SSTs/';

% *************************************************************************
% *************************************************************************
% *************************************************************************

% HadSST4 -----------------------------------------------------------------
dir_HadSST4  = [dir_home,'HadSST4/'];
file         = [dir_HadSST4,'HadSST.4.0.0.0_median.nc'];
time_vec     = datevec(double(ncread(file,'time')+datenum([1850 1 1])));
sst_temp     = ncread(file,'tos');
sst_temp(abs(sst_temp)>1000) = nan;
sst_temp     = sst_temp([37:72 1:36],:,:);
N_yr         = fix(size(sst_temp,3)/12);
HadSST4.sst  = reshape(sst_temp(:,:,1:(N_yr*12)),72,36,12,N_yr);
HadSST4.time = time_vec(1:12:(N_yr*12),:);

% HadSST4_raw -------------------------------------------------------------
file             = [dir_HadSST4,'HadSST.4.0.0.0_unadjusted.nc'];
sst_temp         = ncread(file,'tos');
sst_temp(abs(sst_temp)>1000) = nan;
sst_temp         = sst_temp([37:72 1:36],:,:);
HadSST4.sst_raw  = reshape(sst_temp(:,:,1:(N_yr*12)),72,36,12,N_yr);

% HadSST4_members ----------------------------------------------------------
HadSST4_en.sst_en   = nan(72,36,12,N_yr,200);
for en = 1:200
    
    if rem(en,20) == 0,   disp(['En: ',num2str(en)]);    end
    
    file         = [dir_HadSST4,'HadSST/HadSST.4.0.0.0_ensemble_member_',num2str(en),'.nc'];
    sst_temp     = ncread(file,'tos');
    sst_temp(abs(sst_temp)>1000) = nan;
    sst_temp     = sst_temp([37:72 1:36],:,:);
    HadSST4_en.sst_en(:,:,:,:,en) = reshape(sst_temp(:,:,1:(N_yr*12)),72,36,12,N_yr);
end
HadSST4_en.time  = time_vec(1:12:(N_yr*12),:);

% *************************************************************************
% *************************************************************************
% *************************************************************************

% HadSST3 -----------------------------------------------------------------
dir_HadSST3  = [dir_home,'HadSST3/'];
file         = [dir_HadSST3,'HadSST.3.1.1.0.median.nc'];
time_vec     = datevec(double(ncread(file,'time')+datenum([1850 1 1])));
sst_temp     = ncread(file,'sst');
sst_temp     = sst_temp([37:72 1:36],end:-1:1,:);
N_yr         = fix(size(sst_temp,3)/12);
HadSST3.sst  = reshape(sst_temp(:,:,1:(N_yr*12)),72,36,12,N_yr);
HadSST3.time = time_vec(1:12:(N_yr*12),:);

% HadSST3_raw -------------------------------------------------------------
file             = [dir_HadSST3,'HadSST.3.1.1.0.unadjusted.nc'];
sst_temp         = ncread(file,'sst');
sst_temp         = sst_temp([37:72 1:36],:,:);
HadSST3.sst_raw  = reshape(sst_temp(:,:,1:(N_yr*12)),72,36,12,N_yr);

% HadSST3_members ----------------------------------------------------------
HadSST3_en.sst_en   = nan(72,36,12,N_yr,100);
for en = 1:100
    
    if rem(en,20) == 0,   disp(['En: ',num2str(en)]);    end
    
    file         = [dir_HadSST3,'HadSST/HadSST.3.1.1.0.anomalies.',num2str(en),'.nc'];
    sst_temp     = ncread(file,'sst');
    sst_temp     = sst_temp([37:72 1:36],end:-1:1,:);
    HadSST3_en.sst_en(:,:,:,:,en) = reshape(sst_temp(:,:,1:(N_yr*12)),72,36,12,N_yr);
end
HadSST3_en.time  = time_vec(1:12:(N_yr*12),:);

% HadSST2 -----------------------------------------------------------------
dir_HadSST2  = [dir_home,'HadSST2/'];
file         = [dir_HadSST2,'HadSST2_1850on.nc'];
time_vec     = datevec(double(ncread(file,'time')/24+datenum([1 1 1])));
sst_temp     = ncread(file,'sst');
sst_temp     = sst_temp([37:72 1:36],:,:);
N_yr         = fix(size(sst_temp,3)/12);
HadSST2.sst  = reshape(sst_temp(:,:,1:(N_yr*12)),72,36,12,N_yr);
HadSST2.time = time_vec(1:12:(N_yr*12),:);

% *************************************************************************
% *************************************************************************
% *************************************************************************

% HadISST2 ----------------------------------------------------------------
en_list = [69 115 137 396 400 1059 1169 1194 1346 1466];
dir_HadISST2 = [dir_home,'HadISST2/'];
for en = 1:10
    
    disp(['Start ',num2str(en),'th HadISST2 ensemble'])
    
    clear('sst_temp','sst_temp2','sst_temp3','sst_temp4')
    file      = [dir_HadISST2,'HadISST.2.1.0.0_realisation_dec2010_',num2str(en_list(en)),'.nc'];
    sst_temp  = ncread(file,'sst');
    sst_temp  = sst_temp([181:360 1:180],[180:-1:1],:);

    sst_temp2 = nan(72,180,size(sst_temp,3));
    sst_temp3 = nan(72,36,size(sst_temp,3));
    for ct = 1:72  sst_temp2(ct,:,:) = nanmean(sst_temp((ct-1)*5+[1:5],:,:),1);    end
    for ct = 1:36  sst_temp3(:,ct,:) = nanmean(sst_temp2(:,(ct-1)*5+[1:5],:),2);   end
    
    land_mask = CDF_land_mask(5,1)';
    N_yr      = fix(size(sst_temp3,3)/12);
    temp      = reshape(sst_temp3(:,:,1:(N_yr*12)),72,36,12,N_yr);
    temp(repmat(land_mask,1,1,12,N_yr) == 1) = NaN;
    HadISST2.sst(:,:,:,:,en) = temp;
end
HadISST2.time = [1850:1:2010]';

% *************************************************************************
% *************************************************************************
% *************************************************************************

% COBESST2 ----------------------------------------------------------------
clear('time_vec')
dir_CobeSST2 = [dir_home,'CobeSST2/'];

clear('sst_temp','sst_temp2','sst_temp3','sst_temp4')
file          = [dir_CobeSST2,'sst.mon.mean.nc'];
time_vec      = datevec(double(ncread(file,'time')+datenum([1891 1 1])));
sst_temp      = ncread(file,'sst');
sst_temp(abs(sst_temp)>500) = nan;
sst_temp      = sst_temp(:,end:-1:1,:);

sst_temp2     = nan(72,180,size(sst_temp,3));
sst_temp3     = nan(72,36,size(sst_temp,3));
for ct = 1:72  sst_temp2(ct,:,:) = nanmean(sst_temp((ct-1)*5+[1:5],:,:),1);    end
for ct = 1:36  sst_temp3(:,ct,:) = nanmean(sst_temp2(:,(ct-1)*5+[1:5],:),2);   end

land_mask     = CDF_land_mask(5,1)';
N_yr          = fix(size(sst_temp3,3)/12);
temp          = reshape(sst_temp3(:,:,1:(N_yr*12)),72,36,12,N_yr);
temp(repmat(land_mask,1,1,12,N_yr) == 1) = NaN;
CobeSST2.sst  = temp;
CobeSST2.time = time_vec(1:12:(N_yr*12),:);

% *************************************************************************
% *************************************************************************
% *************************************************************************

% ERSSTV5 -----------------------------------------------------------------
clear('time_vec')
dir_ERSST5 = [dir_home,'ERSST5/'];

clear('sst_temp','sst_temp2','sst_temp3','sst_temp4')
file         = [dir_ERSST5,'sst.mnmean.nc'];
time_vec     = datevec(double(ncread(file,'time')+datenum([1800 1 1])));
sst_temp     = ncread(file,'sst');
sst_temp(abs(sst_temp)>500) = nan;
sst_temp     = sst_temp(:,end:-1:1,:);

sst_temp2(1:2:360,:,:) = sst_temp;
sst_temp2(2:2:360,:,:) = sst_temp;
sst_temp3(:,1:2:178,:) = sst_temp2;
sst_temp3(:,2:2:178,:) = sst_temp2;
sst_temp = sst_temp3(:,[1 1:178 178],:);

sst_temp2    = nan(72,180,size(sst_temp,3));
sst_temp3    = nan(72,36,size(sst_temp,3));
for ct = 1:72  sst_temp2(ct,:,:) = nanmean(sst_temp((ct-1)*5+[1:5],:,:),1);    end
for ct = 1:36  sst_temp3(:,ct,:) = nanmean(sst_temp2(:,(ct-1)*5+[1:5],:),2);   end

land_mask    = CDF_land_mask(5,1)';
N_yr         = fix(size(sst_temp3,3)/12);
temp         = reshape(sst_temp3(:,:,1:(N_yr*12)),72,36,12,N_yr);
temp(repmat(land_mask,1,1,12,N_yr) == 1) = NaN;
ERSST5.sst   = temp;
ERSST5.time  = time_vec(1:12:(N_yr*12),:);

% ERSSTV4 -----------------------------------------------------------------
clear('time_vec')
dir_ERSST4 = [dir_home,'ERSST4/'];

clear('sst_temp','sst_temp2','sst_temp3','sst_temp4')
file         = [dir_ERSST4,'sst.mnmean.v4.nc'];
time_vec     = datevec(double(ncread(file,'time')+datenum([1800 1 1])));
sst_temp     = ncread(file,'sst');
sst_temp(abs(sst_temp)>500) = nan;
sst_temp     = sst_temp(:,end:-1:1,:);

sst_temp2(1:2:360,:,:) = sst_temp;
sst_temp2(2:2:360,:,:) = sst_temp;
sst_temp3(:,1:2:178,:) = sst_temp2;
sst_temp3(:,2:2:178,:) = sst_temp2;
sst_temp = sst_temp3(:,[1 1:178 178],:);

sst_temp2    = nan(72,180,size(sst_temp,3));
sst_temp3    = nan(72,36,size(sst_temp,3));
for ct = 1:72  sst_temp2(ct,:,:) = nanmean(sst_temp((ct-1)*5+[1:5],:,:),1);    end
for ct = 1:36  sst_temp3(:,ct,:) = nanmean(sst_temp2(:,(ct-1)*5+[1:5],:),2);   end

land_mask    = CDF_land_mask(5,1)';
N_yr         = fix(size(sst_temp3,3)/12);
temp         = reshape(sst_temp3(:,:,1:(N_yr*12)),72,36,12,N_yr);
temp(repmat(land_mask,1,1,12,N_yr) == 1) = NaN;
ERSST4.sst   = temp;
ERSST4.time  = time_vec(1:12:(N_yr*12),:);

% *************************************************************************
% *************************************************************************
% *************************************************************************

dir_save     = LME_OI('Mis');
file_save    = [dir_save,'All_earlier_SST_regridded_to_5x5_grids_20200405.mat'];
save(file_save,'HadSST4','HadSST4_en','HadSST3','HadSST2','HadSST3_en',...
               'HadISST2','CobeSST2','ERSST5','ERSST4','-v7.3');
