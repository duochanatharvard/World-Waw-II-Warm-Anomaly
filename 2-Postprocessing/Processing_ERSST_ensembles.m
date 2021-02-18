% export JOB_ERSST=`sbatch --account=huybers_lab  -J ERSST_regrid  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1-20  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "version=4; num=\$SLURM_ARRAY_TASK_ID; Processing_ERSST_ensembles;quit;">>logs' | egrep -o -e "\b[0-9]+$"`
% echo JOB_ERSST  ID $JOB_ERSST

dir_home = '/Users/duochan/Data/Other_SSTs/';

version  = 4;
SST_name = ['ERSST',num2str(version)];
dir      = [dir_home,SST_name,'/',SST_name,'_EN_raw/'];
dir_save = [dir_home,SST_name,'/',SST_name,'_EN_processed/'];

en_list  = 11:1000;

for en = en_list
    

    % =====================================================================
    % Read data
    % =====================================================================
    disp(['Start Ensemble ',num2str(en)])
    yr_start = 1854;
    if version == 5
        file = [dir,'sst2d.ano.1854.2017.ensemble.',CDF_num2str(en,4),'.dat'];
        yr_end   = 2017;
    else
        file = [dir,'sst2d.ano.1854.2014.ensemble.',CDF_num2str(en,4),'.dat'];
        yr_end   = 2014;
    end
    
    try
        fid  = fopen(file,'r','s');
        temp = fread(fid,'float32');
        fclose(fid);
        temp(temp<-100) = nan;
        
        % =====================================================================
        % Reshape data into a matrix
        % =====================================================================

        N        = 180 * 89;
        
        ERSST_raw = nan(180,89,(yr_end-yr_start+1)*12);
        for ct_yr = 1:(yr_end-yr_start+1)
            for ct_mon = 1:12
                ct = (ct_yr-1)*12 + ct_mon;
                l  = [1:N] + 1 + (N+2)*(ct-1);
                ERSST_raw(:,:,ct) = reshape(temp(l),180,89);
            end
        end
        
        % =====================================================================
        % Regrid data
        % =====================================================================
        ERSST_regrid = Average_grid(0:2:358,-88:2:88,ERSST_raw,2.5:5:360,-87.5:5:90);
        
        % =====================================================================
        % Save data
        % =====================================================================
        file_save = [dir_save,SST_name,'_regrid_5X5_',...
            num2str(yr_start),'_',num2str(yr_end),'_ensemble_',num2str(en),'.mat'];
        save(file_save,'ERSST_regrid','-v7.3')
    
    catch
        disp([file,' not yet downloaded!'])
    end
    
end

% =========================================================================
% Functions
% =========================================================================
function out = CDF_num2str(num,len)

    out = repmat('0',1,len);
    a = num2str(num);
    out(end-size(a,2)+1:end) = a;
end


function field_out = Average_grid(lon_high,lat_high,field_in,lon_target,lat_target)

    % Averaging from a fine regular grid to a coarse regular grid

    temp = field_in(:,:,1);
    if any(isnan(temp(:)))
        field_type = 'Miss';
    else
        field_type = 'Full';
    end
    
    if min(size(lon_high)) > 1
        lon_high = lon_high(:,1);
        lat_high = lat_high(1,:);
    end
    
    reso_lon = abs(mode(diff(lon_target,[],2)));
    reso_lat = abs(mode(diff(lat_target,[],2)));
    
    if strcmp(field_type,'Full')
        
        field_inter = nan(numel(lon_target),numel(lat_high),size(field_in,3));
        field_out   = nan(numel(lon_target),numel(lat_target),size(field_in,3));
        
        for ct_lon = 1:numel(lon_target)
            
            l_lon = lon_high >= (ct_lon-1) * reso_lon & ...
                lon_high < (ct_lon) * reso_lon;
            
            field_inter(ct_lon,:,:) = nanmean(field_in(l_lon,:,:),1);
        end

        for ct_lat = 1:numel(lat_target)
            
            l_lat = lat_high >= (ct_lat-1) * reso_lat - 90 & ...
                lat_high < (ct_lat) * reso_lat - 90;

            temp     = field_inter(:,l_lat,:);
            lat_temp = repmat(lat_high(l_lat),size(field_inter,1),1,size(field_inter,3));
            weigh    = cos(lat_temp*pi/180);
            
            field_out(:,ct_lat,:) = nansum(temp .* weigh,2) ./ nansum(weigh,2);
        end
        
    elseif strcmp(field_type,'Miss')
        
        mask_invalid = all(isnan(field_in),3);
        field_out = nan(numel(lon_target),numel(lat_target),size(field_in,3));
        
        for ct_lon = 1:numel(lon_target)
            for ct_lat = 1:numel(lat_target)
                
                l_lon = lon_high >= (ct_lon-1) * reso_lon & ...
                    lon_high < (ct_lon) * reso_lon;
                
                l_lat = lat_high >= (ct_lat-1) * reso_lat - 90 & ...
                    lat_high < (ct_lat) * reso_lat - 90;
                
                invalid_temp  = mask_invalid(l_lon,l_lat,:);
                
                if nnz(invalid_temp(:))/numel(invalid_temp(:)) < 0.5
                    
                    temp      = field_in(l_lon,l_lat,:);
                    lat_temp  = repmat(lat_high(l_lat),size(temp,1),1,size(field_in,3));
                    weigh     = cos(lat_temp*pi/180);
                    l         = repmat(invalid_temp,1,1,size(field_in,3));
                    weigh(l == 1) = 0;
                    
                    field_out(ct_lon,ct_lat,:) = nansum(nansum(temp .* weigh,1),2) ./ nansum(nansum(weigh,1),2);
                end
            end
        end
    end
end