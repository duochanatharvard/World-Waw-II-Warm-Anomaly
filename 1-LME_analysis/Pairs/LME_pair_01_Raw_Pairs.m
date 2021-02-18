% *************************************************************************
% This version pairs all sources of data
% When saved, the following catograies are divided:
% 1. Bucket and Bucket
% 2. ERI and ERI
% 3. Bucket and ERI
% 4. Ships and Ships excluding 1, 2, and 3
% 5. Ships and Buoys
% 6. Buoys and Buoys
% excluding C-MAN ~ 7. Anything containing C-MAN
% *************************************************************************
% 
% Comments from a previous version. Here, we do not use these parameters
% but we save everthing without throwing away any information at this stage
% of analysis.
% 
% 2018-10-19: In the latest version, this part should pick out all pairs without
% throwing away anything. So the following parameters are recommended
% do_NpD = 1;
% do_rmdup = 0;
% do_rmsml = 0;
% dp_other = 0;    % This is to connect Japanese Kobe decks
%
% Last update: 2019-08-05
 
function LME_pair_01_Raw_Pairs(P)

    % *********************************************************************
    % Input and Output 
    % *********************************************************************
    dir_save = LME_OI('all_pairs');

    % *********************************************************************
    % Loading data                   
    % *********************************************************************
    DATA = LME_pair_function_read_data(P);
    disp('Loading data completes!')

    % *********************************************************************
    % File name for the saving data 
    % *********************************************************************
    file_save = [dir_save,'IMMA1_R3.0.0_',num2str(P.yr),'-',CDF_num2str(P.mon,2),'_All_pairs.mat'];

    % *********************************************************************
    % Pickout pairs
    % *********************************************************************
    if ~isempty(DATA),

        clear('Method','Markers')
        Method = DATA.C0_SI_4;
        l = Method > 0.05   & Method <= 0.5;    Method(l) = 13;
        l = Method > 0.5    & Method < 0.95;    Method(l) = 14;
        l = Method >= 0     & Method <= 0.05;   Method(l) = 0;
        l = Method >= 0.95  & Method <= 1;      Method(l) = 1;
        Markers = [double(DATA.C0_CTY_CRT)  DATA.C1_DCK'  Method'];

        in_var  = [DATA.C98_UID; DATA.C0_LON;  DATA.C0_LAT;...
                   DATA.C0_UTC;  DATA.C0_SI_4];
        uid_index  = 1;
        lon_index  = 2;
        lat_index  = 3;
        utc_index  = 4;
        method_index = 5;
        reso_s = 5;
        c_lim  = 300;
        y_lim  = 3;
        t_lim  = 48;
        mode   = 1;
        
        N_data = size(in_var,1);
        
        if isfield(P,'debug'),
            if P.debug == 1, % for debug
                disp('*************')
                disp('in debug mode')
                disp('*************')
                in_var = in_var(:,1:40:end);
                Markers = Markers(1:40:end,:);
            end
        end
        
        disp('Pairing data begins!')
        [Pairs,Meta] = LME_function_get_pairs...
                       (in_var,Markers,lon_index,lat_index,utc_index,...
                        reso_s,[],c_lim,y_lim,t_lim,mode);

        clear('dc','dt','mx','my')
        dc = distance(Pairs(lat_index,:),Pairs(lon_index,:),Pairs(lat_index+N_data,:),Pairs(lon_index+N_data,:));
        dt = abs(Pairs(utc_index,:) - Pairs(utc_index+N_data,:));
        mx = LME_function_mean_period([Pairs(lon_index,:); Pairs(lon_index + N_data,:)],360);
        my = nanmean([Pairs(lat_index,:); Pairs(lat_index + N_data,:)],1);
        Pairs = [Pairs; dc; dt; mx; my];
        disp('Pairing data completes!')
                    
        if ~isempty(Pairs),

            % *************************************************************
            % Pickout pairs by combinations of methods
            % *************************************************************
            clear('m1','m2','l_bb','l_be','l_ee','l_ss','l_sby','l_byby','l_cman')
            m1 = Pairs(method_index,:);
            m2 = Pairs(method_index + size(in_var,1),:);
            vars = [uid_index  uid_index+N_data  N_data*2+[1:4]];
            
            % 1. Bucket vs. Bucket
            l_bb = m1 == 0 & m2 == 0;
            Bucket_vs_Bucket = Pairs(vars,l_bb);
            
            % 2. Bucket vs. ERI + Hull
            l_be = (m1 == 0 & ismember(m2,[1 3])) | (m2 == 0 & ismember(m1,[1 3]));
            Bucket_vs_ERI = Pairs(vars,l_be); 
            
            % 3. ERI + Hull vs. ERI + Hull
            l_ee = ismember(m1,[1 3]) & ismember(m2,[1 3]);
            ERI_vs_ERI = Pairs(vars,l_ee); 
            
            % 4. Ship vs. Ship excluding 1., 2., and 3.
            l_ss = ~ismember(m1,[-2 -3]) & ~ismember(m2,[-2 -3]);
            l_ss = l_ss & ~l_bb & ~l_be & ~l_ee;
            Ship_vs_Ship = Pairs(vars,l_ss); 
            
            % 5. Ship vs. Buoy
            l_sby = (~ismember(m1,[-2 -3]) & m2 == -2) | (~ismember(m2,[-2 -3]) & m1 == -2);
            Ship_vs_Buoy = Pairs(vars,l_sby); 

            % 6. Buoy vs. Buoy
            l_byby = m1 == -2 & m2 == -2;
            Buoy_vs_Buoy = Pairs(vars,l_byby); 
            
            % 7. Anything including C-MAN
            % l_cman = ~l_bb & ~l_be & ~l_ee & ~l_ss & ~l_sby & ~l_byby;
            % CMAN = Pairs(vars,l_cman); 

            % *************************************************************
            % Save Data
            % *************************************************************
            disp('Saving data')
            save(file_save,'Bucket_vs_Bucket','Bucket_vs_ERI','ERI_vs_ERI',...
                'Ship_vs_Ship','Ship_vs_Buoy','Buoy_vs_Buoy','-v7.3');
        end
    end
    
    %% an example of extracting data from UIDs...
    % P.yr = 1995;P.mon = 12; P.C98_UID = CMAN(1,:);
    % P1 = LME_pair_function_read_data(P);
    % P.yr = 1995;P.mon = 12; P.C98_UID = CMAN(2,:);
    % P2 = LME_pair_function_read_data(P);
end
