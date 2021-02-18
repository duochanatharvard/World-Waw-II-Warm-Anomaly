% export JOB_ERSST=`sbatch --account=huybers_lab  -J ERSST_regrid  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1-20  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "version=4; num=\$SLURM_ARRAY_TASK_ID; Processing_ERSST_ensembles;quit;">>logs' | egrep -o -e "\b[0-9]+$"`
% echo JOB_ERSST  ID $JOB_ERSST

dir_home = '/Volumes/My Passport Pro/';

version  = 5;
SST_name = ['ERSST',num2str(version)];
dir      = [dir_home,SST_name,'/',SST_name,'_EN_raw/'];
dir_save = [dir_home,SST_name,'/',SST_name,'_EN_processed/'];

en_list  = 2:1000;

for en = en_list
    

    % =====================================================================
    % Read data
    % =====================================================================
    disp(['Start Ensemble ',num2str(en)])
    yr_start = 1854;
    
    out = repmat('0',1,4);
    a = num2str(en);
    out(end-size(a,2)+1:end) = a;
    
    if version == 5
        file = [dir,'sst2d.ano.1854.2017.ensemble.',out,'.dat'];
        yr_end   = 2017;
    else
        file = [dir,'sst2d.ano.1854.2014.ensemble.',out,'.dat'];
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
        ERSST_regrid = Average_grid_on_my_old_computer(0:2:358,-88:2:88,ERSST_raw,2.5:5:360,-87.5:5:90);
        
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



