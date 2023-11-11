% display_fig6 script.
% generates Fig6, xy data with ellipses
pause off;
fprintf('L14 display_fig6 in vbTRACK_2D_V5');
X(:,1) = x_micronC(:);  % x_micronC is 1 x 400

X(:,2) = y_micronC(:);
G = z_cleaned_a; % G = states.
    % set axis limits for Figs 1 and 6  
    offsetx = min(x_micronC);    
    offsety = min(y_micronC);  
    rangex = max(x_micronC) - min(x_micronC);
    rangey = max(y_micronC) - min(y_micronC);
        
    Kbest = max(G);
    
hfig6 = figure (6)   % *******  xy data with ellipses   *********** Fig6
clf(hfig6) % "clear" needed to prevent overwriting of figure
           % during batch prosessing
axes6 = axes('Parent', hfig6); % 
hold(axes6, 'on');
axis equal
title('Fig 6 xy plot after Machine Learning')
    textFig6{1}=sprintf('%6s  bead %i ',trial, beadNumber+1)
        %textFig6{1}=sprintf('Trial %i bead %i ',trial, beadNumber+1)
    sig = zeros(2,2,Kbest);  % stdev of ellipses for output.
    kcenter = zeros(Kbest,2)
for k=1:Kbest
    fprintf('k = ?? at L39 in display_fig60');
    k
    idx = ( G == k ); % idx = 1 if frame is in this state, 0 otherwise
    % INSERT FOR ELLIPSES
            % substract mean_x and mean_y for this state
            Mu(1) = mean( x_micronC(idx));  % 1 x 2
            Mu(2) = mean( y_micronC(idx));
            kcenter(k,1) = Mu(1);
            kcenter(k,2) = Mu(2);
            X0((idx),1) = x_micronC(idx) - Mu(1); % 
            X0((idx),2) = y_micronC(idx) - Mu(2); % 
            % eigenvalue decomposition of X0 
            [V D] = eig( X0'*X0 ./ (sum(idx)-1) ); % D=eigenvalues, V=eigenvectors of X0
            [D order] = sort(diag(D), 'descend');  %      
            D = diag(D);  % 2 x 2  D11 and D22 are the variances
            sig(:,:,k) = D.^(1/2); % sig is the standard deviation
            sig;
            V = V(:, order);
            theta_dir = linspace(0,2*pi,100);     % theta_dir was t until 11/28/18
            e = [cos(theta_dir) ; sin(theta_dir)];        % unit circle
            VV = 2*V*sqrt(D);             % scale eigenvectors by 2*sigma = 2*sqrt(variance)
            VV*e;                         % ellipse centered at 0,0
            e = bsxfun(@plus, VV*e, Mu'); % translate ellipse back to orig space
                                          % by adding Mu' to VV*e 

    switch k
       case 1
           plot(x_micronC(idx),y_micronC(idx),'Marker','o',...
              'MarkerFaceColor',colors(k),'MarkerEdgeColor',colors(k),'MarkerSize',5,...
              'LineStyle','none','DisplayName','State 1');
             hold on;
             set(gcf,'Renderer','OpenGL');
             
            plot(Mu(1),Mu(2),'-squarek','linewidth',6,'MarkerSize',15, 'Color',colors(k),'Handlevisibility','off');
            plot(e(1,:), e(2,:), 'Color',colors(k),'linewidth',2,'Handlevisibility','off');
            hold on;
       case 2
              plot(x_micronC(idx),y_micronC(idx),'Marker','o',...
                 'MarkerFaceColor',colors(k),'MarkerEdgeColor',colors(k),'MarkerSize',5,...
                 'LineStyle','none','DisplayName','State 2');
              hold on; 
              plot(Mu(1),Mu(2),'-squarek','linewidth',6,'MarkerSize',15, 'Color',colors(k),'Handlevisibility','off');
              plot(e(1,:), e(2,:), 'Color',colors(k),'linewidth',2,'Handlevisibility','off');
              hold on;
       case 3
          plot(x_micronC(idx),y_micronC(idx),'Marker','o',...
              'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'MarkerSize',5,...
              'LineStyle','none','DisplayName','State 3');
          hold on;
          plot(Mu(1),Mu(2),'-squarek','linewidth',6,'MarkerSize',15, 'Color','b','Handlevisibility','off');
          plot(e(1,:), e(2,:), 'Color','b','linewidth',2,'Handlevisibility','off');
          hold on;
       case 4
           plot(x_micronC(idx),y_micronC(idx),'Marker','o',...
              'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'MarkerSize',5,...
              'LineStyle','none','DisplayName','State 4');
            hold on;
            plot(Mu(1),Mu(2),'-squarek','linewidth',6,'MarkerSize',15, 'Color','k','Handlevisibility','off');
            plot(e(1,:), e(2,:), 'Color','k','linewidth',2,'Handlevisibility','off');
            hold on;
       case 5
            plot(x_micronC(idx),y_micronC(idx),'Marker','o',...
               'MarkerFaceColor', 'none','MarkerEdgeColor','m','MarkerSize',5,...
               'LineStyle','-', 'LineWidth',2, 'DisplayName','State 5');
            hold on;
            plot(Mu(1),Mu(2),'-squarek','linewidth',4,'MarkerSize',10, 'Color','m','Handlevisibility','off');
            plot(e(1,:), e(2,:), 'Color','m','LineWidth',2,'Handlevisibility','off');
            hold on;
       case 6
           plot(x_micronC(idx),y_micronC(idx),'Marker','o',...
              'MarkerFaceColor','c','MarkerEdgeColor','c','MarkerSize',5,...
              'LineStyle','-','DisplayName','State 6');
            hold on;
            plot(Mu(1),Mu(2),'-squarek','linewidth',6,'MarkerSize',15, 'Color','c','Handlevisibility','off');
            plot(e(1,:), e(2,:), 'Color','c','linewidth',2,'Handlevisibility','off');
            hold on;
       end;  % end of switch on k
        hold on;
       clear X0;
end;      % end of for k=1:Kbest
 xlabel('x (µm)','FontSize',14);
 ylabel('y (µm)','FontSize',14);
  set(gca,'FontSize',14);
        % xlim([xxmin xxmax]); % xxmin evaluated in run_vbTRACK_Batch
        % ylim([xxmin xxmax]); % xxmax evaluated in        "
 xlim([-5*sig_x 5*sig_x]);   % sig_x taken from workspace    
 box(axes6,'on');
 
 Hb = gca;
 Hb.TickLength = [.05 .05];
 Hb.LineWidth  = 1;
 set(axes6,'FontSize',14,'LineWidth',1,...
           'TickLength', [0.05 0.05]);
 legend6 = legend(axes6,'show');
set(legend6,'Position',[0.695 0.720 0.183 0.162],'FontSize',12);
grid on;
legend boxoff;
annotation(hfig6,'textbox',[0.174 0.853 0.191 0.065],...
   'String',textFig6,'FitBoxToText','on','EdgeColor','none');
pause (1); 
hold off;    
% % ********************************************************************************end of Fig6 
