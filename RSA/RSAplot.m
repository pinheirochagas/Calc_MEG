function RSAplot(RSAres, coloR, varargin)

%% Plot
% figureDim = [0 0 .3 .3];
% figure('units','normalized','outerposition',figureDim)
% Select data from -2 to 3.2
%% Parse args
[x_lim, y_lim] = parseArgs(varargin);

if isempty(x_lim); x_lim = [-0.2 4]; else end
if isempty(y_lim); x_lim = [-0.15 2]; else end

timeStart = find(RSAres.timevect > x_lim(1)); timeStart = timeStart(1);
timeStop = find(RSAres.timevect > x_lim(2)); timeStop = timeStop(1);

%% Get data
data_rsa = RSAres.ds_stacked_RSA.samples(:,timeStart:timeStop);
time_rsa = RSAres.timevect(timeStart:timeStop);
sig_tp_RSA = RSAres.sig_tp_RSA(timeStart:timeStop);  

data_avg = mean(data_rsa,1);
data_sem = std(data_rsa)/sqrt(size(data_rsa,1));

LineWidthLine = 1.5;
LineWidthLineThick = 3;
LineWidthMark = 0.5;
LineCol = [.5 .5 .5];

%% Plot
xlim(x_lim)
ylim(y_lim)
line(xlim,[0 0], 'Color', [.5 .5 .5], 'LineWidth', LineWidthMark);
line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([.8 .8], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([1.6 1.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([2.4 2.4], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([3.2 3.2], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);

% result
hold on
plt = shadedErrorBar(time_rsa,data_avg,data_sem, {'color', coloR, 'LineWidth',LineWidthLine});
plt.patch.FaceAlpha = .5;
% Significant time points
plot(time_rsa(sig_tp_RSA),data_avg(sig_tp_RSA),'.','MarkerSize',30,'Color', coloR)

time_rsa(~sig_tp_RSA) = nan; 
data_avg(~sig_tp_RSA) = nan;
area(time_rsa,data_avg, 'FaceColor', coloR, 'LineStyle', 'none')

set(gca, 'FontSize', 18)
box on

%% Parse args
    function [x_lim, y_lim] = parseArgs(args)
        % Prelocate args
        x_lim = [];
        y_lim = [];
        args = stripArgs(args);
        while ~isempty(args)
            switch(lower(args{1}))
                case 'x_lim'
                    x_lim = args{2};
                    args = args(2:end);
                case 'y_lim'
                    y_lim = args{2};
                    args = args(2:end);  
                otherwise
                    error('Unsupported argument "%s"!', args{1});
            end
            args = stripArgs(args(2:end));
        end 
    end


end
