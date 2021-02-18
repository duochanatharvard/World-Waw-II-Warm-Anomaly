% CDF_bar(x,y,ref,col,varargin)
% 'barwi':  default 1

function CDF_bar(x,y,ref,col,varargin)

    if numel(varargin) == 1
        varargin = varargin{1};
    end
    para = reshape(varargin(:),2,numel(varargin)/2)';
    for ct = 1 : size(para,1)
        temp = para{ct,1};
        temp = lower(temp);
        temp(temp == '_') = [];
        para{ct,1} = temp;
    end

    if nnz(ismember(para(:,1),'barwi')) == 0
        barwi = 1;
    else
        barwi = para{ismember(para(:,1),'barwi'),2};
    end

    if nnz(ismember(para(:,1),'facealpha')) == 0
        facealpha = 1;
    else
        facealpha = para{ismember(para(:,1),'facealpha'),2};
    end

    d = mode(x(2:end)-x(1:end-1));
    
    if ~exist('ref','var')
        ref = 0;
    end
    
    if ~exist('col','var')
        col = flipud(lines(2));
    end

    hold on;
    for ct = 1:numel(x)
        if y(ct)>0
            patch([0 1 1 0]*d*barwi+x(ct)-d/2,...
                [0 0 1 1]*y(ct)+ref,col(1,:),'linest','none','facealpha',facealpha);
        else
            patch([0 1 1 0]*d*barwi+x(ct)-d/2,...
                [0 0 1 1]*y(ct)+ref,col(2,:),'linest','none','facealpha',facealpha);
        end
    end

    plot(x,zeros(1,numel(y))+ref,'k-','linewi',1)

end