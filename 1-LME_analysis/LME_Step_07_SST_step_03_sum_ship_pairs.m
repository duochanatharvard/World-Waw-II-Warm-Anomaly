addpath(genpath(pwd));

if ~strcmp(computer,'MACI64')
    addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Computation/')
    addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Figures/')
    addpath('/n/home10/dchan/script/Peter/Hvd_SST/Code_Homo_early_20cent_warming/Function/')
    addpath('/n/home10/dchan/script/Peter/Hvd_SST/DIURNAL_cycles/')
else
    addpath('/Users/zen/Research/Git_Code/DIURNAL_cycles/');
end

P.do_connect   = 1;
P.connect_Kobe = 1;
P.buoy_diurnal = 1;
P.var_list = {'C0_YR','C0_MO','C0_UTC','C0_LON','C0_LAT',...
              'C1_DCK','C0_SST','C0_OI_CLIM','C0_SI_4','C0_CTY_CRT','C98_UID'};
var_list   = [P.var_list, 'DCK', 'Buoy_Diurnal'];
P.yr_list  = [1850:2014];

P.save_app =  'Ship_vs_Ship';
if ~exist('do_day','var')
   P.save_sum = ['Ship_vs_Ship_all_measurements_',num2str(P.yr_list(1)),'_',num2str(P.yr_list(end)),'_Full_SST'];
   P.save_app = [P.save_app,'_all_measurements'];
else
   if do_day == 1
       P.save_sum = ['Ship_vs_Ship_day_measurements_',num2str(P.yr_list(1)),'_',num2str(P.yr_list(end)),'_Full_SST'];
       P.save_app = [P.save_app,'_day_measurements'];
    else
       P.save_sum = ['Ship_vs_Ship_night_measurements_',num2str(P.yr_list(1)),'_',num2str(P.yr_list(end)),'_Full_SST'];
       P.save_app = [P.save_app,'_night_measurements'];
    end
end

dir_save   = LME_OI('bin_pairs');
file_save  = [dir_save,'SUM_pairs_',P.save_sum,'.mat'];

dir_load   = LME_OI('screen_pairs');
% DATA       = [];
for var = 1:numel(var_list)
    eval(['P1.',var_list{var},' = [];']);
    eval(['P2.',var_list{var},' = [];']);
end
disp('==============================================================>')
disp('Load in data ...')
for yr = P.yr_list
    for mon = 1:12

        disp(['Starting year: ',num2str(yr),'  month:', num2str(mon)])
        file_load = [dir_load,'IMMA1_R3.0.0_',num2str(yr),'-',...
            CDF_num2str(mon,2),'_',P.save_app,'.mat'];
        
        try 
            load(file_load,'DATA_save');
            % DATA = [DATA DATA_save];

            PP = P;   PP.yr = yr;  PP.mon = mon;  PP.C98_UID = DATA_save(1,:);
            P1_temp = LME_pair_function_read_data(PP);    clear('PP')
            PP = P;   PP.yr = yr;  PP.mon = mon;  PP.C98_UID = DATA_save(2,:);
            P2_temp = LME_pair_function_read_data(PP);    clear('PP')

            for var = 1:numel(var_list)
                if ~ismember(var_list{var},{'C0_ID','C0_CTY_CRT','DCK'})
                    eval(['P1.',var_list{var},' = [P1.',var_list{var},'  P1_temp.',var_list{var},'];']);
                    eval(['P2.',var_list{var},' = [P2.',var_list{var},'  P2_temp.',var_list{var},'];']);
                else
                    eval(['P1.',var_list{var},' = [P1.',var_list{var},'; P1_temp.',var_list{var},'];']);
                    eval(['P2.',var_list{var},' = [P2.',var_list{var},'; P2_temp.',var_list{var},'];']);
                end
            end
        catch
            disp(['something wrong with data in ',num2str(yr),' Month ',num2str(mon)])
        end
    end
end
clear('P1_temp','P2_temp','var_list_temp','DATA_save','yr','mon');
disp('Load in data completes!')
disp(' ')

dir_save = LME_OI('bin_pairs');
save(file_save,'P1','P2','-v7.3');
