function [roipos,roineg]=ns_statinfo(varargin)
% ns_statinfo displays spatial and temporal extension of significant
% clusters with p<probthr
% Use: [roipos,roineg]=ns_statinfo(stat,probthr)
% If probthr is not specified, probthr=0.3.
%
% Author: Marco Buiatti, INSERM Cognitive Neuroimaging Unit (France), 2013.

stat=varargin{1};

if length(varargin)==1 
    probthr=0.3; % threshold of max P-value of displayed cluster
else
    probthr=varargin{2};
end;

% disp(['CRA latency: ' num2str(stat.time(1)) '-' num2str(stat.time(end)) ' s']);
% disp([' ']);
% disp(['List of clusters with P-value < ' num2str(probthr) ':']);

roipos=[];
roineg=[];
if isfield(stat,'posclusterslabelmat')
    nposclusters=max(stat.posclusterslabelmat(:));
    if nposclusters>0
        if stat.posclusters(1).prob>probthr
            disp([' ']);
            disp(['No positive clusters with P-value < ' num2str(probthr)]);
        else
            for i=1:nposclusters
                if stat.posclusters(i).prob<=probthr
                    disp([' ']);
                    disp(['Positive cluster ' num2str(i) ': P-value ' num2str([stat.posclusters(i).prob])]);
                    clus=sum(stat.posclusterslabelmat==i);
                    a=stat.time(clus>0);
                    tp=mean((stat.posclusterslabelmat==i).*stat.stat,1);
                    [mx,tmx]=max(tp);
                    roipos{i}=find(stat.posclusterslabelmat(:,tmx)==i);
                    disp(['Latency: ' num2str(a(1)) ' - ' num2str(a(end)) '. Max stat: ' num2str(mx) ' at time point ' num2str(tmx) ' (' num2str(stat.time(tmx)) ' s). ' 'Max size: ' num2str(max(clus(clus>0)))]);
                end
            end;
        end;
    else disp('No positive clusters found');
    end
else disp('No positive clusters found');
end;

if isfield(stat,'negclusterslabelmat')
    nnegclusters=max(stat.negclusterslabelmat(:));
    if nnegclusters>0
        if stat.negclusters(1).prob>probthr
            disp([' ']);
            disp(['No negative clusters with P-value < ' num2str(probthr)]);
        else
            for i=1:nnegclusters
                if stat.negclusters(i).prob<=probthr
                    disp([' ']);
                    disp(['Negative cluster ' num2str(i) ': P-value ' num2str([stat.negclusters(i).prob])]);
                    clus=sum(stat.negclusterslabelmat==i);
                    a=stat.time(clus>0);
                    tp=mean((stat.negclusterslabelmat==i).*stat.stat,1);
                    [mx,tmx]=min(tp);
                    roineg{i}=find(stat.negclusterslabelmat(:,tmx)==i);
                    disp(['Latency: ' num2str(a(1)) ' - ' num2str(a(end)) '. Min stat: ' num2str(mx) ' at time point ' num2str(tmx) ' (' num2str(stat.time(tmx)) ' s). ' 'Max size: ' num2str(max(clus(clus>0)))]);
                end;
            end
        end
    else disp('No negative clusters found');
    end
else disp('No negative clusters found');
end;