function Q4singleplot(ax, Sv, Phs, cmap)

xline(0, '-k', 'linewidth',0.7);
yline(0, '-k', 'linewidth',0.7);

quiver(ax, Phs.x,Phs.y,Phs.u,Phs.v,3,'color',[0.9,0.9,0.9],'linewidth',0.75); 
daspect([1,1,1]);

cellfun(@(S,i) plot(ax, S(1,1), S(1,2), '.', 'markersize', 20, 'color', cmap(i,:),  ...
    'linewidth',2), Sv, num2cell(1:length(Sv)));

linestyles = {'-', ':'}; 
linewidths = [3.5,3]; 
cellfun(@(S,i,lstl) plot(ax, S(:,1), S(:,2), '-', 'color', cmap(i,:),  ...
    'linestyle', lstl, 'linewidth', linewidths(i)), ...
    Sv, num2cell(1:length(Sv)), linestyles);

end