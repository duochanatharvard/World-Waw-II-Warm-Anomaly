% output = CDF_pcolor(X,Y,Z)
%  
% CDF_pcolor is based on pcolor, but correct for the last col and last raw,
% also it removes the outer line of the boxes.
% 
% Last update: 2018-08-11

function h = CDF_pcolor(X,Y,Z)

    if nargin == 1,
        Z = X;
        X = 1:size(Z,1);
        Y = 1:size(Z,2);
    end
    
    pic_z = [Z Z(:,end); Z(end,:) nan];
    
    if min(size(X)) == 1,
        
        X = X(:)';
        Y = Y(:)';
        
        if numel(X) ~= size(pic_z,1),
            
            pic_x = [1.5*X(1)-0.5*X(2), (X(2:end)+ X(1:end-1))/2,...
                1.5*X(end)-0.5*X(end-1)];
            
            pic_y = [1.5*Y(1)-0.5*Y(2), (Y(2:end)+ Y(1:end-1))/2,...
                1.5*Y(end)-0.5*Y(end-1)];
            
        else
            pic_x = X;
            pic_y = Y;
        end

        h = pcolor(pic_x,pic_y,pic_z');
        
    else
        
        if size(X,1) ~= size(pic_z,1),
            
            X = [1.5*X(1,:)-0.5*X(2,:); (X(2:end,:)+ X(1:end-1,:))/2;...
                1.5*X(end,:)-0.5*X(end-1,:)];
            
            Y = [1.5*Y(1,:)-0.5*Y(2,:); (Y(2:end,:)+ Y(1:end-1,:))/2;...
                1.5*Y(end,:)-0.5*Y(end-1,:)];
            
            pic_x = [1.5*X(:,1)-0.5*X(:,2), (X(:,2:end)+ X(:,1:end-1))/2,...
                1.5*X(:,end)-0.5*X(:,end-1)];
            
            pic_y = [1.5*Y(:,1)-0.5*Y(:,2), (Y(:,2:end)+ Y(:,1:end-1))/2,...
                1.5*Y(:,end)-0.5*Y(:,end-1)];
        else
            pic_x = X;
            pic_y = Y;
        end

        h = pcolor(pic_x,pic_y,pic_z);
    end
    
    set(h,'linest','none');
end