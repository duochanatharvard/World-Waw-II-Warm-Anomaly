clear;

dir_data = WWIIWA_IO('data');

% =========================================================================
% Load data
% =========================================================================
load([dir_data,'WWIIWA_statistics_for_CMIP5_piControl_runs.mat']);
load([dir_data,'WWIIWA_statistics_for_CMIP6_piControl_runs.mat']);
load([dir_data,'WWIIWA_statistics_for_CMIP5_historical_runs.mat']);
load([dir_data,'WWIIWA_statistics_for_CMIP6_historical_runs.mat']);

%%

Table_CMIP5 = get_Table(CMIP5_hist,CMIP5_pi);
Table_CMIP6 = get_Table(CMIP6_hist,CMIP6_pi);

[repmat('''''   ',44,1) Table_CMIP5([3:end],:) repmat('&   ',44,1) Table_CMIP6([3:end 1 1 ],:) repmat('\\',44,1)]


%% =========================================================================
% Assemble and Display Table 1
% =========================================================================
clear('Table_1','Table_2','Table_merge')
% Tab_range(Tab_range == 0) = nan;
% Tab(Tab == 0) = nan;
Table_merge = num2str([Tab(:,1) Tab_range(:,1:2) Tab(:,2)  Tab_range(:,3:4)  Tab(:,3)  Tab_range(:,5:6)],...
    '& %7.2f [%4.2f,  %4.2f] & %7.2f [%4.2f,  %4.2f]  & %7.2f [%4.2f,  %4.2f] \\\\');

Table_head = [...
'''''R1: All SSTs (raw)           ';
'''''R2: Bucket (raw)             ';
'''''R3: ERI (raw)                ';
'''''R4: Day \& night (adjusted)  ';
'''''R5: Daytime only (adjusted)  ';
'''''ERSST4                       ';
'''''ERSST5                       ';
'''''HadSST2                      ';
'''''HadSST3                      ';
'''''HadSST4                      ';
'''''Cowtan SST                   ';
'''''CMIP5 historical             ';
'''''CMIP6 historical             ';
'''''CMIP5 control                '];

clear('Table_title')
Table_title(1,:) = '''''     & WWII anomaly &  1936-1950 variance of           &  global mean of 1936-1950 var.                \\';
Table_title(2,:) = '''''     & ($^\circ$C)  &  global-mean SST ($^\circ$C$^2$) & on 5$^\circ$ grids ($^\circ$C$^2$)            \\';
[Table_title; Table_head Table_merge]

%%

function Table_CMIP5 = get_Table(CMIP5_hist,CMIP5_pi)

    CMIP5_hist_uni = unique(CMIP5_hist.name(:,1));
    CMIP5_pi_uni = unique(CMIP5_pi.name(:,1));

    Table_CMIP5_1 = repmat(' ',42,30);
    Table_CMIP5_2 = repmat(' ',42,30);

    for ct = 1:50

        clear('text_CMIP5')
        if ct <= numel(CMIP5_pi_uni)
            if any(ismember(CMIP5_hist.name(:,1),CMIP5_pi_uni{ct}))
                l = ismember(CMIP5_hist.name(:,1),CMIP5_pi_uni{ct});
                text_CMIP5 = [CMIP5_pi_uni{ct}, ' & ', num2str(nnz(l))];
            else
                text_CMIP5 = [CMIP5_pi_uni{ct}, ' & - - '];
            end
            l = ismember(CMIP5_pi.name(:,1),CMIP5_pi_uni{ct});
            text_CMIP5 = [text_CMIP5,' & ', num2str(nansum(CMIP5_pi.number(l)))];
        else
            text_CMIP5 = ' & & ';
        end
        Table_CMIP5_1(ct,1:numel(text_CMIP5)) = text_CMIP5;

        clear('text_CMIP5')
        if ct <= numel(CMIP5_hist_uni)
            l = ismember(CMIP5_hist.name(:,1),CMIP5_hist_uni{ct});
            text_CMIP5 = [CMIP5_hist_uni{ct},' & ', num2str(nnz(l))];
            if any(ismember(CMIP5_pi.name(:,1),CMIP5_hist_uni{ct}))
                l = ismember(CMIP5_pi.name(:,1),CMIP5_hist_uni{ct});
                text_CMIP5 = [text_CMIP5, ' & ', num2str(nansum(CMIP5_pi.number(l)))];
            else
                text_CMIP5 = [text_CMIP5, ' & - - '];
            end
        else
            text_CMIP5 = ' & & ';
        end
        Table_CMIP5_2(ct,1:numel(text_CMIP5)) = text_CMIP5;

    end

    Table_CMIP5 = unique([Table_CMIP5_1;Table_CMIP5_2],'rows');
    

end