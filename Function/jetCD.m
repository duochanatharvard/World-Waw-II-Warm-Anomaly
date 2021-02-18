% col = jetCD(num,varargin)
% 
% jetCD returns rainbow colormap
% col = colormap_CD([0.45 0.70; 0.25 0.9],[0.7 0.35],[0 0],num);
%
% Can be modified to be other maps, or using argument "name": 
%
% 'season': The two ends are blue (DJF), and middle is orange (JJA)
% col = colormap_CD([0.12 0.68; 0.18 0.63],[0.65 0.45],[0 0],num);
%
% Last update: 2018-08-14

function col = jetCD(num,name)

    % *********************************************************************
    % Parse input arguments
    % ********************************************************************* 
    if ~exist('num','var')  num = 6; end
    if ~exist('name','var') name = 'jet'; end

    % *********************************************************************
    % Generate colormap
    % *********************************************************************
    switch name,
        case 'jet',
            shft = (num - 10)/(20-10) *0.1;
            shft(shft > 0.1) = 0.1;
            shft(shft < 0) = 0;
            col = colormap_CD([0.45-shft 0.70; 0.25+shft 0.9],[0.7 0.35],[0 0],num);
        case 'season',
            num = ceil(num/2);
            col1 = colormap_CD([0.75 0.65; 0.80 0.93],[0.8 0.55],[0 0],num);
            col2 = colormap_CD([0.25 0.00; 0.45 0.63],[0.65 0.45],[0 0],num);
            % colormap(gca,[col2(end,:); col1(1:end,:); col2(1:end-1,:)]);
            colormap(gca,[col1; col2]);
            col = [col1; col2];
    end

end