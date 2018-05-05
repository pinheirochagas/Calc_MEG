function plotLinesCalc(t)
LineCol = [.5 .5 .5];
LineWidthMark = 1;
line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([t.sign t.sign], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([t.B t.B], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([t.equal t.equal], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([t.C t.C], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([t.Cd t.Cd], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
end

