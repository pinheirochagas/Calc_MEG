function ns_roierf_depregr(roi,xclus,av1,av2,av3,av4,channel)

load('C:\Users\marco.buiatti\Documents\software\pipeline_tmp\SensorClassification.mat');

switch channel
    case 'mag'
        av1 = ft_selectdata(av1,'channel',Mag2(roi));
        av2 = ft_selectdata(av2,'channel',Mag2(roi));
        av3 = ft_selectdata(av3,'channel',Mag2(roi));
        av4 = ft_selectdata(av4,'channel',Mag2(roi));
    case 'grad1'
        av1 = ft_selectdata(av1,'channel',Grad2_1(roi));
        av2 = ft_selectdata(av2,'channel',Grad2_1(roi));
        av3 = ft_selectdata(av3,'channel',Grad2_1(roi));
        av4 = ft_selectdata(av4,'channel',Grad2_1(roi));
    case 'grad2'
        av1 = ft_selectdata(av1,'channel',Grad2_2(roi));
        av2 = ft_selectdata(av2,'channel',Grad2_2(roi));
        av3 = ft_selectdata(av3,'channel',Grad2_2(roi));
        av4 = ft_selectdata(av4,'channel',Grad2_2(roi));
    otherwise
        disp('Error: Incorrect channel selection!');
end;

figure;
set(gca,'Fontsize',16);
hold on;
% linecolors={'b','c','g','r'};
% linecolors={[0 0 255]/255,[0 255 255]/255,[255 0 255]/255,'r'};
% linecolors={[255 255 0]/255,[255 153 51]/255,'r',[216 41 0]/255};
% linecolors={[1 1 0],[1 0.8 0],[1 0.4 0],[1 0 0]};
linecolors={[1 0.717647075653076 0],[1 0.470588237047195 0.160784319043159],[0.800000011920929 0.00784313771873713 0.00784313771873713],[0.600000023841858 0.200000002980232 0]};

linewidth=2.5;
plot(av1.time,mean(av1.avg,1),'color',linecolors{1},'linewidth',linewidth); 
plot(av1.time,mean(av2.avg,1),'color',linecolors{2},'linewidth',linewidth); 
plot(av1.time,mean(av3.avg,1),'color',linecolors{3},'linewidth',linewidth); 
plot(av1.time,mean(av4.avg,1),'color',linecolors{4},'linewidth',linewidth); 

% standard
axis tight;
% xlim([0 0.55]);
xlim([0 0.7]);

% figure erp animals
% axis([0 0.55 -0.92 2.06]);
% figure erp tools
% axis([0 0.5 -0.3 1.4]);
% axis([0 0.5 2 6]);

set(gca,'ytick',[-1 0 1])
legend('hab','dev1','dev2','dev3','Location','NorthWest');
legend boxoff;
% legend('close','medium','far','across','Location','NorthWest');

% figure erp tools
% legend('close','medium','far','across','Location',[0.89 0.75 0.1 0.1]);
% legend boxoff;
xlabel('s');
ylabel('T');

axis manual;

x1=xclus(1);
x2=xclus(2);
y1=-3;
y2=3;
edgecolor=0.8;
h=fill([x1 x2 x2 x1],[y1 y1 y2 y2],edgecolor*[1 1 1]);
transparency=0.5;
set(h,'EdgeColor',[1 1 1],'FaceAlpha',transparency,'EdgeAlpha',transparency);
uistack(h,'bottom');

