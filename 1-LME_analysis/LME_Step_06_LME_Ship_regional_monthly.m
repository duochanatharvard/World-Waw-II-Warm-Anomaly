% clear;
% sbatch --account=huybers_lab  -J LME_ERI  -t 10080 -p huce_bigmem -n 1  --mem-per-cpu=400000  --array=1-12  -o err --wrap='matlab -nosplash -nodesktop -nodisplay -r "num=\$SLURM_ARRAY_TASK_ID;LME_Step_06_LME_Ship_regional_monthly;quit;">>log_ACDC_03' 
% *************************************************************************
% Set Directries
% *************************************************************************
addpath(genpath(pwd));
if ~strcmp(computer,'MACI64'),
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
% [yr_id, lme_id] = ind2sub([141,1],num);
% yr_id = num;

lme_id   = 1;
yr_start = 1850;
yr_end   = 2014;
% if yr_end > 2007, yr_end = 2007; end

use_kent_tracks     = 0;
use_diurnal_points  = 0;
use_fundemental_SST = 0;
P.relative          = 'mean_SST';

% *************************************************************************
% Set Parameters
% *************************************************************************

% parameters for controling the run ---------------------------------------
P.varname   = 'SST';         % Variable to be analyzed
P.method    = 'Ship';      % Subset of data according to meansurement method
P.yr_list   = yr_start:yr_end;     % Length of the analysis                          % TODO
li = [num-1 num num+1];  li(li<1) = li(li<1) + 12;  li(li>12) = li(li>12) - 12;
mon_abb = 'JFMAMJJASOND';
P.mon_list  = li;    % Seasonal coverage of the analysis
P.select_region = 1:17;       % To confine the analysis in certain regions?          
%  1. Sub-NA   2. Sub-WNP   3. Sub-EMP  4. Ex-NA   5. Ex-NP
%  6. Medt     7. TA        8. WTP      9. CTP     10.ETP
% 11. Indian  12. Sub-SA   13. SIO     14. SP      15. SO
% 16. SPole   17. NPole
P.mute_read   = 1;             % Whether to turn off the output for debugging?
P.restart     = 0;           % Whether to restart the summing of bins?
    
% parameters for the LME model (binning) ----------------------------------
P.use_kent_tracks = use_kent_tracks;         % Only use data from tracked ships in the LME?  % TODO
P.use_diurnal_points = use_diurnal_points;   % only use data that computed diurnal cycles.   % TODO 
P.use_fundemental_SST = use_fundemental_SST; % use fundemental SST in the LME analysis.      % TODO
% Possible combinations are:
% =========================================================================
%                           I       II      III     IV
% -------------------------------------------------------------------------
% use_kent_tracks           0       1       0       0
% use_diurnal_points        0       0       1       1
% use_fundemental_SST       0       0       0       1
% =========================================================================   
P.do_connect      = 1;        % Connect decks that have the same discreptions?
P.connect_Kobe    = 1;        % Treat deck 119 and 762 as 118?
P.do_simple       = 0;        % Whether to use the simple model?
P.do_region       = 1;        % whether turn on the regional effect?
P.do_season       = 0;        % whether turn on the seasonal effect?
P.do_decade       = 1;        % whether turn on the decadal effect?
P.yr_start        = yr_start; % when decadal is on, which is the first year?            % TODO
P.yr_interval     = 5;       % when decadal is on, length of the yearly bins
if ~exist('do_day','var')
    P.key         = 5000;
else
    P.key         = 2500;
end    
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
if strcmp(P.method,'Ship')                  % This part should not be touched
    P.type      = 'Ship_vs_Ship';                      % Which type of pairs to read from step 1 in paring
    P.save_app  = 'Ship_vs_Ship';         % file name for screened pairs for step 2 in paring

    P.all_ERI_in_one_group = 0;                  % collapse all ERIs into one group              % TODO
    P.all_BCK_in_one_group = 0;
   
    if P.use_kent_tracks == 0 && P.use_diurnal_points == 0,
        if ~exist('do_day','var')
            P.save_app       = [P.save_app,'_all_measurements'];
        else
            if do_day == 1
               P.save_app       = [P.save_app,'_day_measurements'];
            else
               P.save_app       = [P.save_app,'_night_measurements'];
            end
        end
    end
    
    if P.use_kent_tracks == 1 && P.use_diurnal_points == 0,
        P.save_app       = [P.save_app,'_kent_tracked'];
    end
    
    if P.use_kent_tracks == 0 && P.use_diurnal_points == 1,
        P.save_app       = [P.save_app,'_diurnal_points_',P.relative];
    end
end

% parameters for diurnal cycle analyses -----------------------------------
P.diurnal_QC      = 0;             % use different QCs for the diurnal cycles
% P.refit_diurnal = 1;             % average diurnal signals and refit diurnal cycles?   % TODO      


% *************************************************************************
% Set output filenames
% *************************************************************************
% file name for screened pairs --------------------------------------------
P.save_sum  = [P.save_app,'_',num2str(P.yr_list(1)),'_',num2str(P.yr_list(end))];  
if P.use_fundemental_SST == 0,
    P.save_sum  = [P.save_sum,'_Full_SST'];
else
    P.save_sum  = [P.save_sum,'_Fund_SST'];  
end

% file name for bined pairs -----------------------------------------------
P.save_bin  = [P.save_sum,'_mon_',mon_abb(P.mon_list)];  
P.save_lme  = P.save_bin;                                                  % file name for LME
clear('temp','ct','c_temp')


% *************************************************************************
% Bin pairs before fitting the LME model 
% *************************************************************************
if 1,    [BINNED,W_X] = LME_lme_bin(P);                   end

% *************************************************************************
% Fitting the LME model
% *************************************************************************
if 1,      LME_lme_fit_hierarchy(P);                      end
if 0,      LME_lme_fit(P);                                end

