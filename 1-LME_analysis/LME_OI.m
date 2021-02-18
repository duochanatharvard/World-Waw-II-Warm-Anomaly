% Output / Input managements

function output = LME_OI(input)

    if strcmp(input,'home')
        % home directory for LME intercomparison
        load('LME_directories.mat','dir_home_LME')
        output = dir_home_LME;
        % output = '/Users/duochan/Data/LME_intercomparison/';

    elseif strcmp(input,'read_raw')
        % home directory for ICOADS3
        load('LME_directories.mat','dir_home_ICOADS3')
        output = dir_home_ICOADS3;
        % output = '/Users/duochan/Data/ICOADS3/';

    elseif strcmp(input,'diurnal')
        % home directory for diurnal signals
        load('LME_directories.mat','dir_home_diurnal')
        output = dir_home_diurnal;
        % output = '/Users/duochan/Data/DIURNAL_2019/';

    elseif strcmp(input,'ICOADS3')
        output = [LME_OI('read_raw'),'ICOADS_QCed/'];

    elseif strcmp(input,'kent_track')
        output = [LME_OI('read_raw'),'ICOADS_Tracks_Kent/'];

    elseif strcmp(input,'ship_diurnal')
        output = [LME_OI('diurnal'),'Step_04_Ship_Signal/'];

    elseif strcmp(input,'all_pairs')
        output = [LME_OI('home'),'Step_01_All_Pairs/'];

    elseif strcmp(input,'screen_pairs')
        output = [LME_OI('home'),'Step_02_Screen_Pairs/'];

    elseif strcmp(input,'bin_pairs')
        output = [LME_OI('home'),'Step_03_Binned_Pairs/'];

    elseif strcmp(input,'LME_output')
        output = [LME_OI('home'),'Step_04_LME_output/'];

    elseif strcmp(input,'idv_corr')
        output = [LME_OI('home'),'Step_05_Idv_Corr/'];

    elseif strcmp(input,'rnd_corr')
        output = [LME_OI('home'),'Step_06_Rnd_Corr/'];

    elseif strcmp(input,'Mis')
        output = [LME_OI('home'),'Miscellaneous/'];

    elseif strcmp(input,'save_figure')
        output = [LME_OI('home'),'Figures/'];

    elseif strcmp(input,'data4figure')
        output = [LME_OI('home'),'DATA_for_figures/'];

    end
end
