function mvpaPlot(res, gatordiagrsa, coloR, )

%%
LineWidthLine = 1;
LineWidthLineThick = 3;
LineWidthMark = 0.5;
LineCol = [.5 .5 .5];


%% Plotting
if strcmp(gatordiag, 'diag')
    decodingPlotDiag(res)
elseif strcmp(gatordiag, 'gat')
    decodingPlotGat(res)
elseif strcmp(gatordiag, 'RSA')
    RSAplot(res)
end


    function decodingPlotDiag(res)
        %% Prepare data
        data_avg = squeeze(mean(data.all_diagonals,2))';
        data_sem = std(squeeze(data.all_diagonals),1)/sqrt(size(data.all_diagonals,2));
        times = data.train_times.start:1/double(data.sfreq):data.train_times.stop;
        if length(times) < length(data_avg)
            times = data.train_times.start:1/double(data.sfreq):data.train_times.stop+1/double(data.sfreq);
        end
        
        
        plt = shadedErrorBar(times,data_avg,data_sem, {'color', coloR, 'LineWidth',LineWidthLine});
        hold on
        plot(times,data_avg,'k','LineWidth',1.5)
        
        
    end




    function decodingPlotGat(res)
        a = 1
    end


    function RSAplot(res)
        a = 1
    end



end