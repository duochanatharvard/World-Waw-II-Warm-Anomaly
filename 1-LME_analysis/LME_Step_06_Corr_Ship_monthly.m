% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1-540  --mem-per-cpu=10000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 1;LME_Step_06_Corr_Ship;quit;">>log_ACDC_01'

% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1-1000  --mem-per-cpu=10000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 0;LME_Step_06_Corr_Ship;quit;">>log_ACDC_03'

% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 1; LME_Step_06_Corr_Ship_monthly;quit;">>logs/log_CORR_01'

% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 1;P.only_correct = 0; LME_Step_06_Corr_Ship_monthly;quit;">>logs/log_CORR_02'

% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 1;P.only_correct = 1; LME_Step_06_Corr_Ship_monthly;quit;">>logs/log_CORR_03'

% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 1;P.only_correct = 3; LME_Step_06_Corr_Ship_monthly;quit;">>logs/log_CORR_04'

% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 1;P.only_correct = -1; LME_Step_06_Corr_Ship_monthly;quit;">>logs/log_CORR_05'

% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 1;P.only_correct = 13; LME_Step_06_Corr_Ship_monthly;quit;">>logs/log_CORR_06'

% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_intel -n 1  --mem-per-cpu=20000  --array=1  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;P.do_individual = 1;P.only_correct = 14;LME_Step_06_Corr_Ship_monthly;quit;">>logs/log_CORR_07'


% *************************************************************************
% Set Directries
% *************************************************************************
addpath(genpath(pwd));
if ~strcmp(computer,'MACI64')
    addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Computation/')
    addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Figures/')
    addpath('/n/home10/dchan/script/Peter/Hvd_SST/Code_Homo_early_20cent_warming/Function/')
    addpath('/n/home10/dchan/script/Peter/Hvd_SST/DIURNAL_cycles/')
else
    addpath('/Users/zen/Research/Git_Code/DIURNAL_cycles/');
end

% *************************************************************************
% Parsing Parameters
% *************************************************************************
if P.do_individual == 1
    P.en = num - 1;
else
    P.en = num;
end
P.reso_x   = 5;
P.reso_y   = 5;
yr_start = 1850;
yr_end   = 2014;

% *************************************************************************
% Set Parameters
% *************************************************************************
P.varname   = 'SST';         % Variable to be analyzed
P.method    = 'Ship';      % Subset of data according to meansurement method
P.yr_list   = yr_start:yr_end;     % Length of the analysis                          % TODO
% To apply corrections for individual seasons
P.mon_list            = [12 1 2];    % Seasonal coverage of the analysis
P.select_region       = 1:17;    % To confine the analysis in certain regions?
P.use_kent_tracks     = 0;       % Only use data from tracked ships in the LME?  % TODO
P.use_diurnal_points  = 0;       % only use data that computed diurnal cycles.   % TODO
P.use_fundemental_SST = 0;       % use fundemental SST in the LME analysis.      % TODO

% parameters for the LME model (binning) ----------------------------------
P.do_connect      = 1;        % Connect decks that have the same discreptions?
P.connect_Kobe    = 1;        % Treat deck 119 and 762 as 118?
P.do_simple       = 0;        % Whether to use the simple model?
P.do_region       = 1;        % whether turn on the regional effect?
P.do_season       = 0;        % whether turn on the seasonal effect?
P.do_decade       = 1;        % whether turn on the decadal effect?
P.yr_start        = yr_start; % when decadal is on, which is the first year?            % TODO
P.yr_interval     = 5;       % when decadal is on, length of the yearly bins
P.key             = 5000;
P.buoy_diurnal    = 1;        % Use diurnal cycle estimated from buoy measurements.
P.nation_id       = [1 2 4];  % which part of ID is regarded as nation - method

% parameters for the LME model (running) ----------------------------------
P.do_sampling         = 1000;
P.target              = 0;
P.do_hierarchy        = 1;
P.do_hierarchy_random = 1;
P.var_list = {'C0_YR','C0_MO','C0_UTC','C0_LON','C0_LAT',...
    'C1_DCK','C0_SST','C0_OI_CLIM','C0_SI_4','C0_CTY_CRT','C98_UID'};

% parameters for input and output -----------------------------------------
if strcmp(P.method,'Ship')                % This part should not be touched
    P.type      = 'Ship_vs_Ship';                      % Which type of pairs to read from step 1 in paring
    P.save_app  = 'Ship_vs_Ship';         % file name for screened pairs for step 2 in paring

    P.all_ERI_in_one_group = 0;                  % collapse all ERIs into one group              % TODO
    P.all_BCK_in_one_group = 0;

    if P.use_kent_tracks == 0 && P.use_diurnal_points == 0
        P.save_app       = [P.save_app,'_all_measurements'];
    end
end
P.diurnal_QC      = 0;             % use different QCs for the diurnal cycles

% *************************************************************************
% Set output filenames
% *************************************************************************
% file name for screened pairs --------------------------------------------
P.save_sum  = [P.save_app,'_',num2str(P.yr_list(1)),'_',num2str(P.yr_list(end))];
if P.use_fundemental_SST == 0
    P.save_sum  = [P.save_sum,'_Full_SST'];
else
    P.save_sum  = [P.save_sum,'_Fund_SST'];
end

% file name for bined pairs -----------------------------------------------
P.save_bin  = [P.save_sum,'_Merge_Season'];
P.save_lme  = P.save_bin;                                                  % file name for LME
clear('temp','ct','c_temp')

[WM,ST,NUM] = LME_correct(P);
if ~isfield(P,'only_correct')
    if P.do_individual == 1
        % dir_save  = LME_OI('idv_corr');
        dir_save = '/n/home10/dchan/holy_kuang/LME_intercomparison/Step_05_Idv_Corr_v17/';
        file_save = [dir_save,'Corr_idv_ship_en_',num2str(P.en),'_',P.save_lme,'.mat'];
    else
        % dir_save  = LME_OI('rnd_corr');
        dir_save = '/n/home10/dchan/holy_kuang/LME_intercomparison/Step_06_Rnd_Corr_v17/';
        file_save = [dir_save,'Corr_rnd_ship_en_',num2str(P.en),'_',P.save_lme,'.mat'];
    end
else
    if P.do_individual == 1
        % dir_save  = LME_OI('idv_corr');
        dir_save = '/n/home10/dchan/holy_kuang/LME_intercomparison/Step_05_Idv_Corr_v17/';
        file_save = [dir_save,'Corr_idv_method_',num2str(P.only_correct),'_en_',num2str(P.en),'_',P.save_lme,'.mat'];
    else
        % dir_save  = LME_OI('rnd_corr');
        dir_save = '/n/home10/dchan/holy_kuang/LME_intercomparison/Step_06_Rnd_Corr_v17/';
        file_save = [dir_save,'Corr_rnd_method_',num2str(P.only_correct),'_en_',num2str(P.en),'_',P.save_lme,'.mat'];
    end
end
    
save(file_save,'WM','ST','NUM');
