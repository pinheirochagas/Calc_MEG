function ns_roierf(roi,xclus,av1,av2,channel)
% function ns_roierf(roi,xclus,av1,av2,channel)
% plots ERFs of av1, av2 in cluster specified by roi
% xclus=temporal window of the cluster
%
% Author: Marco Buiatti, 2015.

switch channel
    case 'mag'
        av1 = ft_selectdata(av1,'channel',av1.typelabel.Mag2(roi));
        av2 = ft_selectdata(av2,'channel',av1.typelabel.Mag2(roi));
    case 'grad1'
        av1 = ft_selectdata(av1,'channel',av1.typelabel.Grad2_1(roi));
        av2 = ft_selectdata(av2,'channel',av1.typelabel.Grad2_1(roi));
    case 'grad2'
        av1 = ft_selectdata(av1,'channel',av1.typelabel.Grad2_2(roi));
        av2 = ft_selectdata(av2,'channel',av1.typelabel.Grad2_2(roi));
    otherwise
        disp('Error: Incorrect channel selection!');
end;

figure;
set(gca,'Fontsize',14);
hold on;
linecolors={'b','r'};
% linecolors={[0 0 255]/255,[0 255 255]/255,[255 0 255]/255,'r'};
% linecolors={[255 255 0]/255,[255 153 51]/255,'r',[216 41 0]/255};
% linecolors={[1 1 0],[1 0.8 0],[1 0.4 0],[1 0 0]};
linewidth=2.8;
plot(av1.time,mean(av1.avg,1),'color',linecolors{1},'linewidth',linewidth); 
plot(av1.time,mean(av2.avg,1),'color',linecolors{2},'linewidth',linewidth); 

% standard
axis tight;
% xlim([0 0.5]);
xlim([0 0.7]);

% set(gca,'ytick',[-1 0 1])
% legend('hab','dev1','dev2','dev3','Location','NorthWest');
% legend boxoff;
xlabel('s');
ylabel('Tm');

axis manual;

% gray shading along the cluster
x1=xclus(1);
x2=xclus(2);
y1=-5;
y2=5;
edgecolor=0.8;
h=fill([x1 x2 x2 x1],[y1 y1 y2 y2],edgecolor*[1 1 1]);
transparency=0.5;
uistack(h,'bottom');
set(h,'EdgeColor',[1 1 1],'FaceAlpha',transparency,'EdgeAlpha',transparency);

