% export JOB_screen_pairs=`sbatch --account=huybers_lab  -J LME_screen_pairs  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1-165  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;LME_Step_07_SST_step_02_screen_ship_pairs_day_night;quit;">>logs/log_SST_02' | egrep -o -e "\b[0-9]+$"`
% echo JOB_screen_pairs  ID $JOB_screen_pairs

addpath(genpath(pwd));
addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Computation/')
addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Figures/')
addpath('/n/home10/dchan/script/Peter/Hvd_SST/Code_Homo_early_20cent_warming/Function')

yr_num = num;
for yr = 1849+yr_num
    for mon = 1:12
        for do_day = [1 0]
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
                if do_day == 1
                    P.save_app             = [P.save_app,'_day_measurements'];
                else
                    P.save_app             = [P.save_app,'_night_measurements'];
                end
                LME_pair_02_Screen_Pairs_day_night(P,do_day);

            catch
                disp(['Year ',num2str(yr),' Mon',num2str(mon),' Failed...'])
            end
        end  
    end
end
