function mvpaPlot(res, gatordiag)

%% Plotting
if strcmp(gatordiag, 'diag')
    decodingPlotDiag(res)
elseif strcmp(gatordiag, 'gat')
    decodingPlotGat(res)
end
        
    %% Plot diagonal
    function decodingPlotDiag(res)    
        % Define plot parameters
        x_ticks = [-.2 0:.4:3.2];
        
        LineWidthLine = 0.5;
        LineWidthLineThick = 4;
        LineWidthMark = 0.5;
        LineCol = [.5 .5 .5];
        
        % Get data
        chance = res.chance;
        data = squeeze(res.all_diagonals);
        times_plot = res.times(1:size(data,2));
        sig_plot = res.p_values_diagonal_fdr<0.05;
        
        % Average data
        data_avg = mean(data,1);
        data_sem = std(data)/sqrt(size(data,1));
        
        % Correct single points
        for i=2:length(sig_plot)-1
            if sig_plot(i) == 1 && (sig_plot(i-1) == 0 && sig_plot(i+1) == 0);
                sig_plot(i+1) = 1;
            else
            end
        end

        % Plot
        xlim(x_lim)
        ylim([round((min(data_avg)-max(data_sem))*100)/100  round((max(data_avg)+max(data_sem))*100)/100])
        
        % Correct tick marks
        set(gca, 'XTick', x_ticks);       
        set(gca, 'YTick', [round((min(data_avg)-max(data_sem))*100)/100  chance round((max(data_avg)+max(data_sem))*100)/100]);    
        set(gca, 'XTickLabel', '');    
        set(gca, 'YTickLabel', [round((min(data_avg)-max(data_sem))*100)/100  chance round((max(data_avg)+max(data_sem))*100)/100]);    

       
        line(xlim,[chance chance], 'Color', [.5 .5 .5], 'LineWidth', LineWidthMark);
        line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
        line([.8 .8], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
        line([1.6 1.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
        line([2.4 2.4], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
        line([3.2 3.2], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
        
        % result
        hold on
        plt = shadedErrorBar(times_plot,data_avg,data_sem, {'color', coloR, 'LineWidth',0.001});
        plot(times_plot,data_avg,'LineWidth',LineWidthLine, 'Color', [.3 .3 .3])
        plt.patch.FaceAlpha = 1;
        
        % Highlight significant time points
        times_plot(~sig_plot) = nan;
        data_avg(~sig_plot) = nan;
        plot(times_plot, data_avg,  'LineWidth',  LineWidthLineThick, 'Color', 'k')       
        area_plot = area(times_plot,data_avg, chance, 'FaceColor', coloR, 'LineStyle', 'none');
        area_plot.FaceAlpha = 0.8;   


    end
        
        

    %%
    function decodingPlotGat(res)

    end






end