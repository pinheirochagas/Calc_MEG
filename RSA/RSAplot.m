function RSAplot(RSAres, coloR)

%% Plot
% figureDim = [0 0 .3 .3];
% figure('units','normalized','outerposition',figureDim)
% Select data from -2 to 3.2
timeStart = find(RSAres.timevect > .2); timeStart = timeStart(1);
timeStop = find(RSAres.timevect > 3.2); timeStop = timeStop(1);

data_rsa = RSAres.ds_stacked_RSA.samples(:,timeStart:timeStop);
time_rsa = RSAres.timevect(timeStart:timeStop);
sig_tp_RSA = RSAres.sig_tp_RSA(timeStart:timeStop);  

LineWidthMark = 1;

% Plot chance line
line(xlim,[0 0], 'Color', 'k', 'LineWidth', 2 ,'LineStyle', ':');
line([0 0], ylim, 'Color', 'k', 'LineWidth', LineWidthMark);
line([.8 .8], ylim, 'Color', 'k', 'LineWidth', LineWidthMark);
line([1.6 1.6], ylim, 'Color', 'k', 'LineWidth', LineWidthMark);
line([2.4 2.4], ylim, 'Color', 'k', 'LineWidth', LineWidthMark);
line([3.2 3.2], ylim, 'Color', 'k', 'LineWidth', LineWidthMark);

ylim
hold on
% result
plt = shadedErrorBar(time_rsa,mean(data_rsa),std(data_rsa)/sqrt(size(data_rsa,1)), ... 
    {'color', coloR});
ylim([-0.05, .1])
hold on
plt.patch.FaceAlpha = 0.30;
% Significant time points
plot(time_rsa(sig_tp_RSA),0*time_rsa(sig_tp_RSA)-0.130,'.','MarkerSize',3,'Color', coloR)
set(gca, 'FontSize', 18)


end
