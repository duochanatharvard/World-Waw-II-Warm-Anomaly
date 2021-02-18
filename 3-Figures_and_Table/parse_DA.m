function [amp,phs,amp_std,phs_std] = parse_DA(fit_out_grp,fit_out_std_grp)


    % Construct diurnal signals ---------------------------------------
    C0_LCL_hr = [1:24];
    omega = 2*pi/24;
    base_x2 = [ones(numel(C0_LCL_hr),1) sin(C0_LCL_hr'*omega) cos(C0_LCL_hr'*omega)  sin(C0_LCL_hr'*omega*2) cos(C0_LCL_hr'*omega*2)];

    % Prepare for data to be plotted: diurnal -------------------------
    clear('aa')
    aa = zeros([size(fit_out_grp),10000]);
    for i = 1:10000
        aa(:,i) = normrnd(fit_out_grp,fit_out_std_grp);
    end

    clear('amp','amp_rnd','amp_std')
    clear('phs','phs_rnd','phs_std')

    [phs,amp]  = cart2pol(fit_out_grp(6,:,:),fit_out_grp(5,:,:));
    phs(phs<0) = (phs(phs<0) + 2*pi);
    phs        = phs / pi * 12;

    [phs_rnd,amp_rnd]  = cart2pol(aa(6,:,:,:),aa(5,:,:,:));
    phs_rnd(phs_rnd<0) = (phs_rnd(phs_rnd<0) + 2*pi);
    phs_rnd    = phs_rnd / pi * 12;

    amp_std = CDC_std(amp_rnd,3);
    phs_std = CDC_std(phs_rnd,3);

    amp = squeeze(amp)';
    phs = squeeze(phs)';
    amp_std = squeeze(amp_std)';
    phs_std = squeeze(phs_std)';
end