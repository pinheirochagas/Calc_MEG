function ns_statinfo_all(varargin)
stat=varargin{1};

if length(varargin)==1 
    probthr=0.3; % threshold of max P-value of displayed cluster
else
    probthr=varargin{2};
end;

if length(stat)>1
    disp(['CRA latency: ' num2str(stat{1}.time(1)) '-' num2str(stat{1}.time(end)) ' s']);
    disp([' ']);
    disp(['List of clusters with P-value < ' num2str(probthr) ':']);

    %% visualize results for each sensor type %%
    disp(' ');
    disp('%%%% stats for MAG sensors %%%%')
    ns_statinfo(stat{1},probthr);
    disp(' ');
    disp('%%%% stats for GRAD1 sensors %%%%')
    ns_statinfo(stat{2},probthr);
    disp(' ');
    disp('%%%% stats for GRAD2 sensors %%%%')
    ns_statinfo(stat{3},probthr);
else
    disp(['CRA latency: ' num2str(stat.time(1)) '-' num2str(stat.time(end)) ' s']);
    disp([' ']);
    disp(['List of clusters with P-value < ' num2str(probthr) ':']);
    ns_statinfo(stat,probthr);
end;