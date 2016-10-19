function fp_roierf_depregr(lat,roi,xclus,channel,varargin)

% Example: S
%
% Author: Marco Buiatti, 2015

load('/Volumes/NeuroSpin2T/Calculation_Pedro_2014/scripts/software4valentina/pipeline_tmp/SensorClassification.mat');

% number of levels
nl=length(varargin);

% channel selection and re-label channels to match the neighbour sensors configuration
switch channel
    case 'mag'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',Mag2(roi));
        end
    case 'grad1'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',Grad2_1(roi));
        end
    case 'grad2'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',Grad2_2(roi));
        end
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
% linecolors={[1 0.717647075653076 0],[1 0.470588237047195 0.160784319043159],[0.800000011920929 0.00784313771873713 0.00784313771873713],[0.600000023841858 0.200000002980232 0]};
linecolors=[[189,215,231];[107,174,214];[49,130,189];[8,81,156]]/255;



linewidth=2.5;
for level=1:nl
    plot(varargin{level}.time,mean(varargin{level}.avg,1),'linewidth',linewidth,'color',linecolors(level,:));
end;
% standard
axis tight;
% xlim([0 0.55]);
xlim(lat);


% figure erp animals
% axis([0 0.55 -0.92 2.06]);
% figure erp tools
% axis([0 0.5 -0.3 1.4]);
% axis([0 0.5 2 6]);

set(gca,'ytick',[-1 0 1])
% legend('hab','dev1','dev2','dev3','Location','NorthWest');
% legend(num2str(1:nl))
legend show
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

