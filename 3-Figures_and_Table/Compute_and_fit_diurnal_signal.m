% out = Compute_and_fit_diurnal_signal(LCL,DA)

function [diurnal,diurnal_quantile,num,fit_out,fit_out_std,diurnal_std] = Compute_and_fit_diurnal_signal(LCL,DA)

    diurnal          = nan(size(DA,1),24);
    diurnal_quantile = nan(size(DA,1),2,24);
    num              = nan(1,24);
    for ct = 1:24
        l             = LCL == ct;
        diurnal(:,ct) = nanmean(DA(:,l),2);
        diurnal_quantile(:,:,ct) = quantile(DA(:,l),[0.25 0.75],2);
        diurnal_std(:,ct)        = CDC_std(DA(:,l),2);
        num(ct)       = nnz(l);
    end
    
    clear('fit_1','fit_1_std','fit_2','fit_2_std','omega','base_x','base_x2')
    C0_LCL_hr = [1:24];
    omega   = 2*pi/24;
    base_x  = [ones(numel(C0_LCL_hr),1) sin(C0_LCL_hr'*omega) cos(C0_LCL_hr'*omega)];
    base_x2 = [ones(numel(C0_LCL_hr),1) sin(C0_LCL_hr'*omega) cos(C0_LCL_hr'*omega) sin(C0_LCL_hr'*omega*2) cos(C0_LCL_hr'*omega*2)];
    base_x3 = [ones(numel(C0_LCL_hr),1) sin(C0_LCL_hr'*omega) cos(C0_LCL_hr'*omega) sin(C0_LCL_hr'*omega*2) cos(C0_LCL_hr'*omega*2)  sin(C0_LCL_hr'*omega*3) cos(C0_LCL_hr'*omega*3)];


    l = num > 0;
    
    fit_1 = nan(3,size(DA,1));
    fit_1_std = nan(3,size(DA,1));
    fit_2 = nan(5,size(DA,1));
    fit_2_std = nan(5,size(DA,1));
    fit_3 = nan(7,size(DA,1));
    fit_3_std = nan(7,size(DA,1));
    for ct = 1:size(diurnal,1)
        [fit_1(:,ct),fit_1_std(:,ct)] = lscov(base_x(l,:),diurnal(ct,l)',num(l)'); 
        [fit_2(:,ct),fit_2_std(:,ct)] = lscov(base_x2(l,:),diurnal(ct,l)',num(l)'); 
        [fit_3(:,ct),fit_3_std(:,ct)] = lscov(base_x3(l,:),diurnal(ct,l)',num(l)'); 
    end
    
    fit_out = [fit_1; fit_2; fit_3];
    fit_out_std = [fit_1_std; fit_2_std; fit_3_std];

end