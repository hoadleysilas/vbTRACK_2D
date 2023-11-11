% display_figs script.
global pauseTime pauseTimeCode
pause on;

% --- Set useful parameters
time = t(1:end-1);
colors = 'rgbkmc'; 
x00 = min(x_micronC);% C added
xrange = max(x_micronC)-min(x_micronC);
y00 = min(y_micronC);
yrange = max(y_micronC)-min(y_micronC);
maxrange = max(xrange,yrange);

% Figure 3 plot z_hat vs frameNumber
    hfig3 = figure (3);
    clf(hfig3);
    textFig3{1}=sprintf('%5s bead %i',trial, beadNumber+1)
    axes3 = axes('Parent',hfig3);
    box(axes3,'on');
    
    plot(z_cleaned_a,'-k','LineWidth',2);
    ylim([0, (Kbest+1)]);
    title('Fig3, State vs Frame', 'FontSize', 14);
    xlabel('Frame','FontSize',24,'FontName','Arial');
    ylabel('State','FontSize',24,'FontName','Arial');
    set(axes3,'FontSize',24,'YTick',[0 2 4 6],...
        'TickLength',[0.05 0.05],'LineWidth',1.5);
    annotation(hfig3,'textbox',[0.173 0.835 0.26 0.057],...,...
       'String',textFig3,'FitBoxToText','on','EdgeColor','none',...
       'FontSize',14,'FitBoxToText','off');
    % end of Fig3
    pause (1);


% --- Fig4. Convergence of L during iteration.
hfig4 = figure(4); %    **********************************************      Fig 4 L vs iterations
clf(hfig4);
axes4 = axes('Parent', hfig4,'XTickLabel',{'0','20','40','60','80','100'},...
    'XTick',[0 20 40 60 80 100],...
    'FontSize',14,...
    'FontName','Arial');
xlim([0 20]); %2023_09_12
hold(axes4,'all');

xlabel('iterations','FontSize',14,'FontName','Arial');
ylabel('log L ','FontSize',14,'FontName','Script MT Bold');
title ('Fig4. L vs iterations', 'FontSize', 14, 'FontName', 'Arial');
% plot each state separately 
if (K>=1)
    plot(bestOut{1,1}.F,'Marker','*','LineStyle', 'none','Color',[0 0 0]); hold on;
end
if (K>=2)
    plot(bestOut{1,2}.F,'Marker','none','LineStyle', '-','LineWidth',5,'Color',[0 0 0]); hold on;   
end
if(K>=3)
    plot(bestOut{1,3}.F,'Marker','none','LineStyle','--','LineWidth',2,'Color',[0 0 0]); hold on;
end
if(K>=4)
    plot(bestOut{1,4}.F,'Marker','none','LineStyle','-.','LineWidth',2,'Color',[0 0 0]); hold on;
end
if(K>=5)
    plot(bestOut{1,5}.F,'Marker','none','LineStyle', ':','LineWidth',2,'Color',[0 0 0]); hold on;
end
if(K>=6)
    plot(bestOut{1,6}.F,'Marker','none','LineStyle', '-','LineWidth',2,'Color',[0 0 0]); hold on;
end
legend (axes4,'K = 1','K = 2', 'K = 3','K = 4','K = 5','K = 6');
legend('Location', 'SouthEast');
hold on
pause(1)

% ******************     Fig 5  L vs state     *****************    
hfig5 = figure(5);
clf(hfig5);
axes5 = axes('Parent', hfig5, 'XTickLabel',{'1','2','3','4','5','6'}, 'XTick',[1 2 3 4 5 6],...
    'Position',[0.27 0.232 0.589 0.691],...
    'FontSize',22,'FontName','Arial','TickLength',[0.06 0.1]);
%'YTickLabel',{'-800','-600','-400','-200','000','200'},...
xlim(axes5,[0.8 6.2]);
ylim(axes5,[-1200 -1000]);
box(axes5,'on');
hold(axes5,'all');
xlabel('Number of states','FontSize',22,'FontName','Arial');
ylabel('log \itL','FontSize',32,'FontName','Script MT Bold', 'FontAngle','italic');
title('Fig5, L vs numStates', 'FontSize', 14);
xxxx = linspace(1,length(outF),length(outF))
plot(xxxx,outF,'Marker','o','MarkerSize',12,'MarkerFaceColor',[0 0 0], 'LineStyle','-','LineWidth',2,'Color',[0 0 0]);
hold on;
pause (1);


% ---Find index of frames assigned to states = 1 to:7 
                    idx1=find(z_hat{1,Kfav}(1,:)==1);
                    idx2=find(z_hat{1,Kfav}(1,:)==2);
                    idx3=find(z_hat{1,Kfav}(1,:)==3);
                    idx4=find(z_hat{1,Kfav}(1,:)==4);
                    idx5=find(z_hat{1,Kfav}(1,:)==5);
                    idx6=find(z_hat{1,Kfav}(1,:)==6);
                    idx7=find(z_hat{1,Kfav}(1,:)==7);

    X = track2D_micronC' % 2 x 400
    G = z_cleaned_a;
    % set up axis limits for Figs 1 and 6  
    offsetx = min(X(:,1));    
    offsety = min(X(:,2));  
    rangex = max(X(:,1)) - min(X(:,1));
    rangey = max(X(:,2)) - min(X(:,2));
    Kbest = max(G);
    

%    ************************************************************************** start FIG 7A  v vs t for synthetic data
if (real_data==0 && VT == 'V');  %if L436 ends L 534
    % Assume K=2, so 4 possibililties
    % initialize counters
    ct1=0; ct2=0; ct3=0; ct4=0;
    clear x1 x2 x3 x4 y1 y2 y3 y4 y1_micron y2_micron y3_micron y4_micron; 
    x1(1)=NaN; y1(1)=NaN; y1_micron(1)=NaN;
    x2(1)=NaN; y2(1)=NaN; y2_micron(1)=NaN;
    x3(1)=NaN; y3(1)=NaN; y3_micron(1)=NaN;
    x4(1)=NaN; y4(1)=NaN; y4_micron(1)=NaN;
  
% Assign datapoints to categories by score
accum_score1 = 0;
accum_score2 = 0;
accum_numseg1 = 0;
accum_numseg2 = 0;
for i=1:(length(i_hat)-1-length_adj)
    if((i_hat(i) == 1) && (z_hat_untangle_clean{1,2}(i)==1))
         x1(ct1+1)= time(i);
         y1(ct1+1)= v_amp_signed(i);
         y1_micron(ct1+1)= v_amp_signed(i)*1e6;
         ct1=ct1+1;
    end
    if((i_hat(i) == 1) && (z_hat_untangle_clean{1,2}(i)==2))
         x2(ct2+1)= time(i);
         y2(ct2+1)= v_amp_signed(i);
         y2_micron(ct2+1)= v_amp_signed(i)*1e6;
         ct2=ct2+1;
    end
    
    if((i_hat(i) == 2) && (z_hat_untangle_clean{1,2}(i)==1))
         x3(ct3+1)= time(i);
         y3(ct3+1)= v_amp_signed(i);
         y3_micron(ct3+1)= v_amp_signed(i)*1e6;
         ct3=ct3+1;
    end
    if((i_hat(i) == 2) && (z_hat_untangle_clean{1,2}(i)==2))
         x4(ct4+1)= time(i);
         y4(ct4+1)= v_amp_signed(i);
         y4_micron(ct4+1)= v_amp_signed(i)*1e6;
         ct4=ct4+1;
    end
end

% evaluate score(1) and score(2)
    score(1) = accum_score1/accum_numseg1;
    score(2) = accum_score2/accum_numseg2;
    
    frameNum=linspace(1,length(i_hat),length(i_hat)); 
    % convert m/s to um/s
    for i=kmin:K
        x_hat_micron{1,i} = x_hat{1,i}*1e6;
    end% 
    
hfig7 = figure (7);   % ********************   v vs t      ********       Fig7A synth data not cleaned
  axes7 = axes('Parent',hfig7,'FontSize',20,'FontName','Arial',...
     'XTickLabel',{'0','','1','','2','','3','','4'},'XTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5]);
  box(axes7,'on');
  hold(axes7,'all');
         plot(x1,y1,'or',...
                        'MarkerFaceColor','r',...     
                        'MarkerSize',5); hold on;
         plot(x2,y2,'or',...
                        'MarkerFaceColor','r',...
                        'MarkerSize',15); hold on;
         plot(x3,y3,'squareb',...
                        'MarkerFaceColor','b',...
                        'MarkerSize',15);hold on;
         plot(x4,y4,'squareb',...
                        'MarkerFaceColor','b',...
                        'MarkerSize',5); hold on;
         xlim([-0.2 5.2]);
         ylim([-1.5 1.5]);

         title('Fig 7 velocity vs time, scored');
         xlabel('t (s)');
         ylabel('v (µm/s)');
         str7{1}= sprintf('DurD = %2u',DurD);
         str7{2}= sprintf('DurB = %2u',DurB);
         str7{3}= sprintf('k-noise = %5.2f',kNoise);
         str7{4}= sprintf('sig-v  = %5.1e',sigma_v);
         
         str7_score{1}= sprintf('    score');
         str7_score{2}= sprintf('(1,1) =%4.0f',score_g(1,1));
         str7_score{3}= sprintf('(1,2) =%4.0f',score_g(1,2));
         str7_score{4}= sprintf('(2,1) =%4.0f',score_g(2,1));
         str7_score{5}= sprintf('(2,2) =%4.0f',score_g(2,2));
         annotation(hfig7,'textbox',[0.173 0.145 0.1866 0.1905],...
                                'String',str7,...
                                'FitBoxToText','off',...
                                'EdgeColor','none');
         annotation(hfig7,'textbox',[0.765 0.182 0.14 0.1905],...
                                'String',str7_score,...
                                'FitBoxToText','off',...
                                'EdgeColor','none');    
         pause (pauseTime)
end %         end of Fig7A for synthetic data

if ((real_data == 1)) 
    % if ((real_data == 1)&&(VT=='V'))   %   **************************************        Start Fig7B  for real data
     length_adj = 2;
  % --- pick out times when system is State 1, State 2, etc 
                    idx1=find(z_hat_untangled{1,Kfav}(1,:)==1);
                    idx2=find(z_hat_untangled{1,Kfav}(1,:)==2);
                    idx3=find(z_hat_untangled{1,Kfav}(1,:)==3);
                    idx4=find(z_hat_untangled{1,Kfav}(1,:)==4);
                    idx5=find(z_hat_untangled{1,Kfav}(1,:)==5);
                    idx6=find(z_hat_untangled{1,Kfav}(1,:)==6);
                    idx7=find(z_hat_untangled{1,Kfav}(1,:)==7);
% **************
     clear x1 x2 x3 x4 y1 y2 y3 y4 y1_micron y2_micron y3_micron y4_micron; 
     x1(1)=NaN; y1(1)=NaN; y1_micron(1)=NaN;
     x2(1)=NaN; y2(1)=NaN; y2_micron(1)=NaN;
     x3(1)=NaN; y3(1)=NaN; y3_micron(1)=NaN;
     x4(1)=NaN; y4(1)=NaN; y4_micron(1)=NaN;
    

%    
end  % ends real_data ==1 and VT == T
