addpath(genpath(pwd));

if ~strcmp(computer,'MACI64')
    addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Computation/')
    addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Figures/')
    addpath('/n/home10/dchan/script/Peter/Hvd_SST/Code_Homo_early_20cent_warming/Function/')
    addpath('/n/home10/dchan/script/Peter/Hvd_SST/DIURNAL_cycles/')  
    addpath('/n/home10/dchan/Matlab_Tool_Box/m_map/')
end

LME_analysis_Step_02_parse_corrected_SSTs_SST_pairs_day_night2;
% LME_analysis_Step_02_parse_corrected_SSTs_SST_pairs_temp2;
