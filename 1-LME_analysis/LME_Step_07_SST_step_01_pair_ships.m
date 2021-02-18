addpath(genpath(pwd));
addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Computation/')
addpath('/n/home10/dchan/Matlab_Tool_Box/CD_Figures/')
addpath('/n/home10/dchan/script/Peter/Hvd_SST/Code_Homo_early_20cent_warming/Function')

[yr_num,mon_num] = ind2sub([165,12],num);
% [mon_num, yr_num] = ind2sub([12,162],num);
% for yr = (1994+yr_num):-20:1850
for yr = 1849+yr_num
    for mon = mon_num
        try,
            P.yr = yr;
            P.mon = mon;
            LME_pair_01_Raw_Pairs_no_buoy(P);
        catch
            disp('Year ',num2str(yr),' Mon',num2str(mon),' Failed...')
        end
    end
end
