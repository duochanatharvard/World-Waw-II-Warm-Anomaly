function group_season = LME_lme_effect_seasonal(my,mon)

    lat_abs = abs(my);
    lat_list = [-90 -60 -40 -20 20 40 60 90];
    for ct = 1:numel(lat_list) - 1
        l = my >= lat_list(ct) & my < lat_list(ct+1);
        lat_abs(l) = ct;
    end
    lat_abs = abs(lat_abs - 4) + 1;
    
    if 0,
        lat_abs(lat_abs>20 & lat_abs<=40) = 2;
        lat_abs(lat_abs>40 & lat_abs<=60) = 3;
        lat_abs(lat_abs>60 & lat_abs<=90) = 4;
    end

    season_cmp = mon;
    season_cmp(ismember(mon,[12 1 2]))  = 1;
    season_cmp(ismember(mon,[3 4 5]))   = 2;
    season_cmp(ismember(mon,[6 7 8]))   = 3;
    season_cmp(ismember(mon,[9 10 11])) = 4;

    group_season = (lat_abs-1)*4 + season_cmp;
    group_season(my<0) = (lat_abs(my<0)-1)*4 + ...
                          rem(season_cmp(my<0)+2-0.5,4)+0.5;
                      
    % 1-4,   tropical      (winter, spring, summer, fall)
    % 5-8,   subtropical   (winter, spring, summer, fall)
    % 9-12,  extratropical (winter, spring, summer, fall)
    % 13-16, polar         (winter, spring, summer, fall)
end
