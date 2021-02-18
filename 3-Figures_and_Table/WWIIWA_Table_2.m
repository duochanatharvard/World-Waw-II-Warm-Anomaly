clear;

dir_data  = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
Stats_all = load([dir_data,'Stats_All_ships_groupwise_global_analysis.mat'],'Stats_glb','unique_grp');
DA_all    = load([dir_data,'DATA_Plot_DA&LME_1935_1949_Global.mat']);
Stats_day = load([dir_data,'Stats_All_ships_groupwise_global_analysis_day.mat'],'Stats_glb','unique_grp');
DA_day    = load([dir_data,'DATA_Plot_DA&LME_1935_1949_Global_day.mat']);

group   = [DA_all.DATA_pic.group;        DA_all.DATA_pic.group_only];
LME     = [DA_all.DATA_pic.LME(:,1);     DA_all.DATA_pic.LME_only(:,1)];
LME_std = [DA_all.DATA_pic.LME_std(:,1); DA_all.DATA_pic.LME_only_std(:,1)];

% =========================================================================
% Generate Table that has diurnal amplitudes
% =========================================================================
group   = DA_all.DATA_pic.group;          group0  = group;
LME     = DA_all.DATA_pic.LME(:,1);       LME_std       = DA_all.DATA_pic.LME_std(:,1);
ll      = ismember(DA_day.DATA_pic.group,DA_all.DATA_pic.group,'rows');
LME_day = DA_day.DATA_pic.LME(ll,2);      LME_day_std   = DA_day.DATA_pic.LME_std(:,2);
DA_A    = DA_all.DATA_pic.DA_amp(:,1) - DA_all.DATA_pic.DA_amp_clim(:,1);    
DA_std  = sqrt(DA_all.DATA_pic.DA_amp_std(:,1).^2 + DA_all.DATA_pic.DA_amp_clim_std(:,1).^2); 
[~,pst] = ismember(group0,Stats_all.unique_grp,'rows');
N       = squeeze(nansum(nansum(Stats_all.Stats_glb([1935:1949]-1849,:,pst),2),1));

a = group(:,1:2); a(a>100) = 32;  group(:,1:2) = a;
N_grp = size(group,1);

clear('Table_1')
Table_1 = [repmat('''''',N_grp,1), char(group(:,1:2)), repmat('  DCK ',N_grp,1), num2str(group(:,3)) ...
     repmat(' & ',N_grp,1) return_country(group(:,1:2)) ...
     repmat(' & ',N_grp,1) return_deck(group(:,3)) ...
     repmat(' & ',N_grp,1) return_method(group(:,4)) ...
     repmat(' & ',N_grp,1) return_num(N) repmat('K ',N_grp,1) ...
     repmat(' & ',N_grp,1) num2str(LME,'%5.2f') return_sig(LME,LME_std,66) ...
     repmat(' & ',N_grp,1) num2str(LME_day,'%5.2f') return_sig(LME_day,LME_day_std,66) ...
     repmat(' & ',N_grp,1) num2str(DA_A,'%5.2f')  return_sig(DA_A,DA_std,N_grp) ...
     repmat(' & ',N_grp,1) return_app(group)   repmat(' \\',N_grp,1)];

% ========================================================================= 
% Generate Table that has no diurnal amplitudes
% =========================================================================
group   = DA_all.DATA_pic.group_only;          group0      = group;
LME     = DA_all.DATA_pic.LME_only(:,1);       LME_std     = DA_all.DATA_pic.LME_only_std(:,1);
[~,pst] = ismember(DA_all.DATA_pic.group_only, [DA_day.DATA_pic.group; DA_day.DATA_pic.group_only], 'rows');
tem_day = [DA_day.DATA_pic.LME; DA_day.DATA_pic.LME_only];
tem_std = [DA_day.DATA_pic.LME_std; DA_day.DATA_pic.LME_only_std];
LME_day = tem_day(pst,2);      LME_day_std = tem_std(pst,2);
[~,pst] = ismember(group0,Stats_all.unique_grp,'rows');
N       = squeeze(nansum(nansum(Stats_all.Stats_glb([1935:1949]-1849,:,pst),2),1));

a = group(:,1:2); a(a>100) = 32;  group(:,1:2) = a;
N_grp = size(group,1);

clear('Table_2')
Table_2 = [repmat('''''',N_grp,1), char(group(:,1:2)), repmat('  DCK ',N_grp,1), num2str(group(:,3)) ...
     repmat(' & ',N_grp,1) return_country(group(:,1:2)) ...
     repmat(' & ',N_grp,1) return_deck(group(:,3)) ...
     repmat(' & ',N_grp,1) return_method(group(:,4)) ...
     repmat(' & ',N_grp,1) return_num(N) repmat('K ',N_grp,1) ...
     repmat(' & ',N_grp,1) num2str(LME,'%5.2f') return_sig(LME,LME_std,66) ...
     repmat(' & ',N_grp,1) num2str(LME_day,'%5.2f') return_sig(LME_day,LME_day_std,66) ...
     repmat(' & ',N_grp,1) repmat(' ---       ',N_grp,1) ...
     repmat(' & ',N_grp,1) return_app(group)   repmat(' \\',N_grp,1)];

% =========================================================================
% Display the Table
% =========================================================================
[Table_1; Table_2 repmat(' ',size(Table_2,1),size(Table_1,2)-size(Table_2,2))]


% =========================================================================
% Functions and lookup tables to generate Table 2
% =========================================================================
function Num_out = return_num(N)

    Num_out = repmat(' ',size(N,1),6);
    for ct = 1:size(N,1)
        if N(ct)>1000
            temp = num2str(N(ct)/1000,'%10.0f');
        else
            temp = '<1';
        end
        Num_out(ct,end-numel(temp)+1:end) = temp;
    end
    
end


function App_out = return_app(grp)
    App_out = repmat(' ',size(grp,1),15);
    for ct = 1:size(grp,1)
        if grp(ct,4) == -1 && ismember(grp(ct,1:2),'US','rows')
            temp = '$\checkmark$';
            App_out(ct,1:numel(temp)) = temp;
        end
    end
end

function S_out = return_sig(V_in,std_in,N_grp)

    S_out = repmat(' ',size(V_in,1),7);
    for ct = 1:size(V_in,1)
        if abs(V_in(ct)./std_in(ct)) > 1.96
            if abs(V_in(ct)./std_in(ct)) > tinv(1-0.025/N_grp,1000000)
                %S_out(ct,1:7) = '$^{**}$';
                S_out(ct,1:2) = '**';
            else
                %S_out(ct,1:6) = '$^{*}$';
                S_out(ct,1:1) = '*';
            end
        end
    end
end

function M_out = return_method(M_in)

    M_out = repmat(' ',size(M_in,1),10);
    for ct = 1:size(M_in,1)
        switch M_in(ct)
            case 0
                temp = 'Bucket';
            case 1
                temp = 'ERI';
            case 3
                temp = 'Hull sensor';
            case -1
                temp = 'Unknown';
        end
        M_out(ct,1:numel(temp)) = temp;
    end
end

function DCK_out = return_deck(DCK_in)

    DCK_out = repmat(' ',size(DCK_in,1),45);
    
    for ct = 1:size(DCK_in,1)
        switch DCK_in(ct)
            case 110
                temp = 'US Navy Marine';
            case 116
                temp = 'US Merchant Marine';
            case 118
                temp = 'Kobe Collection data';
            case 150
                temp = 'Pacific HUSST Netherlands Receipts';
            case 151
                temp = 'Pacific HUSST German Receipts';
            case 152
                temp = 'Pacific HUSST UK Receipts';
            case 155   
                temp = 'Indian HSST';
            case 156   
                temp = 'Atlantic HSST';
            case 184   
                temp = 'Great Britain Marine';
            case 187   
                temp = 'Japanese Whaling Fleet';
            case 192   
                temp = 'Deutsche Seewarte Marine';
            case 193   
                temp = 'Netherlands Marine';
            case 195   
                temp = 'US Navy Ships Logs';
            case 197   
                temp = 'Danish Marine (Polar)';
            case 202
                temp = 'All Ships (UK MetO MDB)';
            case 203   
                temp = 'Selected UK Ships';
            case 204   
                temp = 'British Navy (HM) Ships';
            case 205
                temp = 'Scottish Fishery Cruisers';
            case 215   
                temp = 'German Marine';
            case 216   
                temp = 'UK Merchant Ship logbooks';
            case 245   
                temp = 'Royal Navy Ship''s Logs';
            case 255
                temp = 'Undocumented TDF-11 Decks or MDB Series';
            case 281  
                temp = 'US Navy Monthly Aerological Record';
            case 703   
                temp = 'US Lightship Collections';
            case 705  
                temp = 'US merchant Marine Collection (series 500)';
            case 706  
                temp = 'US merchant Marine Collection (series 600)';
            case 707  
                temp = 'US merchant Marine Collection (series 700)';
            case 710  
                temp = 'US Arctic Logbooks';
            case 720   
                temp = 'Deutscher Wetterdienst Marine Met. Archive';
            case 732   
                temp = 'Russian Marine Met Data Set';
            case 735   
                temp = 'Russian Research Vessel';
            case 780
                temp = 'NOAA World Ocean Database';
            case 899   
                temp = 'South Africa Whaling';
            case 927   
                temp = 'International Marine';
            otherwise
                disp('No deck information')
                temp = 'No deck information';
        end
        DCK_out(ct,1:numel(temp)) = temp;
    end
end


function C0_out = return_country(C0_in)

    C0_out = repmat(' ',size(C0_in,1),15);
    
    for ct = 1:size(C0_in,1)
        if strcmp(char(C0_in(ct,:)),'DE')
            temp = 'Germany';
        elseif strcmp(char(C0_in(ct,:)),'GB')
            temp = 'Great Britain';
        elseif strcmp(char(C0_in(ct,:)),'JP')
            temp  = 'Japan';
        elseif strcmp(char(C0_in(ct,:)),'NL')
            temp = 'Netherland';
        elseif strcmp(char(C0_in(ct,:)),'US')
            temp = 'United States';
        elseif strcmp(char(C0_in(ct,:)),'RU')
            temp  = 'Russian';
        elseif strcmp(char(C0_in(ct,:)),'CN')
            temp  = 'China';
        elseif strcmp(char(C0_in(ct,:)),'FR')
            temp   = 'France';
        elseif strcmp(char(C0_in(ct,:)),'NO')
            temp  = 'Norway';
        elseif strcmp(char(C0_in(ct,:)),'ZA')
            temp = 'South Africa';
        else
            temp = '---';
        end
        C0_out(ct,1:numel(temp)) = temp;
    end
end