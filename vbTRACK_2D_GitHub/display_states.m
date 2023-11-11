function [hfig3] = display_states(states, Kbest, trial, beadNumber, pauseTime,hfig3)
    textFig3{1}=sprintf('%5s bead %i',trial, beadNumber+1)
    hfig3 = figure(3);
    axes3 = axes('Parent',hfig3);
   
    Ha = gca
        properties(Ha)
        Ha.TickLength = [.05 .05];
        Ha.LineWidth  = 1;
    plot(states,'-k');
    hold(axes3,'on');
    ylim([0, (Kbest+1)]);
        %title('Fig3, State vs Frame', 'FontSize', 14);
    xlabel('Frame','FontSize',24,'FontName','Arial');
    ylabel('State','FontSize',24,'FontName','Arial');
    set(axes3,'FontSize',24,'YTick',[0 1 2 3 4 5]);
    box(axes3,'on');
    annotation(hfig3,'textbox',[0.173 0.835 0.177 0.057],...,...
       'String',textFig3,'FitBoxToText','on','EdgeColor','none',...
       'FontSize',14,'FitBoxToText','off');
        pause (pauseTime);
end


