function dir = WWIIWA_IO(name)

if strcmp(name,'home')
    dir = [pwd,'/'];        % Please specify where the data is downloaded
elseif strcmp(name,'data')
    dir = [WWIIWA_IO('home'),'Data/'];
end
