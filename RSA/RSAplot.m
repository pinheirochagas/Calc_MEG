function RSAplot(data_rsa,time_rsa,sig_tp_RSA)

%% Plot
figureDim = [0 0 .3 .3];
figure('units','normalized','outerposition',figureDim)

% Plot chance line
plot(data_rsa.a.fdim.values{1},mean(data_rsa.samples)*0,'k--')
hold on
% result
plt = shadedErrorBar(time_rsa,mean(data_rsa.samples),std(data_rsa.samples)/sqrt(size(data_rsa.samples,1)), 'g');
ylim([-0.14, .1])
hold on
plt.patch.FaceAlpha = 0.15;
% Significant time points
plot(time_rsa(sig_tp_RSA),0*time_rsa(sig_tp_RSA)-0.130,'.','MarkerSize',3,'Color', 'g')

end
