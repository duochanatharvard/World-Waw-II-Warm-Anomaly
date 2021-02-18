% sbatch --account=huybers_lab  -J Screen_pairs  -p huce_intel -n 1  --mem-per-cpu=10000  --array=1-1980  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;LME_Step_06_Screen_Pairs_Ship;quit;">>log_ACDC_03' 


addpath(genpath(pwd));
addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Computation/')
addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Figures/')
addpath('/n/home10/dchan/script/Peter/Hvd_SST/Code_Homo_early_20cent_warming/Function')

% [mon_num, yr_num] = ind2sub([12,165],num);
yr_num = num;
for yr = 1849+yr_num
%    for mon = mon_num
    for mon = 1:12
        try,

            % ERI compared with ERI - standard analysis  ---------------
            clear('P')
            P.yr                   = yr;
            P.mon                  = mon;
            P.do_connect           = 1;
            P.connect_Kobe         = 1;
            P.use_kent_tracks      = 0;
            P.use_diurnal_points   = 0;
            P.diurnal_QC           = 0;
            P.type                 = 'Ship_vs_Ship';
            P.all_ERI_in_one_group = 0;
            P.all_BCK_in_one_group = 0;
            P.save_app             = 'Ship_vs_Ship';
            P.relative             = 'mean_SST';
            P.save_app             = [P.save_app,'_all_measurements'];
            LME_pair_02_Screen_Pairs(P);

        catch
            disp(['Year ',num2str(yr),' Mon',num2str(mon),' Failed...'])
        end

    end
end
