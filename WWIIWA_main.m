clear;

addpath(genpath(pwd));

tic;

disp('Generating Figures and Table 1 in the main text')
disp('')
disp('Generating Figure 1 ...')
WWIIWA_Fig_1_time_series_other_datasets_final_20201105;

disp('Generating Figure 2 ...')
WWIIWA_Fig_2_statistics_of_groups;

disp('Figure 3 is not generated using Matlab, skipped.')

disp('Generating Figure 4 ...')
WWIIWA_Fig_4_LME_offset_versus_diurnal_amplitude;

disp('Generating Figure 5 ...')
WWIIWA_Fig_5_time_series_our_correction;

disp('Generating Figure 6 ...')
WWIIWA_Fig_6_day_night_time_series;

disp('Generating Figure 7 ...')
WWIIWA_Fig_7_compare_corrections_with_other_datasets;

disp('Generating Figure 8 ...')
WWIIWA_Fig_8_maps_of_jumps;

disp('Generating Table 1 ...')
WWIIWA_Table_1;

disp('')
disp('Generating Figures in the appendix')
disp('')

disp('Generating Figure A1 ...')
WWIIWA_Fig_A1_ERI_Bucket_difference;

disp('Generating Figure A2 ...')
WWIIWA_Fig_A2_diurnal_cycle_for_deck_195;

disp('')
disp('Generating Figures in the supplement')
disp('')

disp('Generating Figure S1 ...')
WWIIWA_Fig_S1_day_night_coverage_and_common_minimum_masks;

disp('Generating Figure S2 ...')
WWIIWA_Fig_S2_time_series_our_correction_daytime_only;

disp('')
disp(['Reproducing figures takes ', num2str(toc,'%6.2f'),' seconds!'])