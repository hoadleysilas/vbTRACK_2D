%% run_vbTRACK_2D Nov 9 2023
% folderName = D:\vbTRACK_2D_Github
% computer   = Lenovo M94 Olin 300
% current goal: clean up for publication of core 2D machine learning
% Ref: George Holzwarth, Arnav Bhandari, Lucas Tommervik, Jed C. Macosko,
%    David A. Ornelles, and Douglas S. Lyles, "Vesicular stomatitis virus
%    nucleocapsids diffuse through cytoplasm by hopping from trap
%    to trap in random directions", Scientific Reports 10f, 10643(2020).

%% Input 'G:\03 VSV MATLAB input'; % data from VST/vrpn2mat
% --- Clean up workspace
clc
close all
clear all
% input
%    xy track from vrpn2Matlab, 1 particle, cell 20230508-A13, bead7

global pauseTime pauseTimeCode
pauseTime = 5;
pauseTimeCode = 0.1;
pause on;

fprintf('Step 1. Start run_vbTRACK_2D\n');
framerate    = 500;  % frames per second for video.
pix2micron   = 9.23; % PCO camera, 60X on Nikon inverted
real_data    = 1;    % 0=virtual_data; 1= real data; 
savitzky     = 1;    % use a Savitzky-Golay filter on real data?
kmin         = 1;    % minimum number of states to fit to the data
K            = 6;    % maximum number of states to fit to the data                " 
save_data    = 1;    % 0 = don't save; 1 = save
numVes       = 1;    % number of iterations for synthetic data
iterations   = 10;   % number of restarts to address problem of false maxima
Batch_selected = 1; % 0: Everything will be processed 
                    % 1: User input Array to be processed
                    
%% **********************************************************
%% ********************* FIRST LOAD ******************************
%% load dataFile bead7track2D
folder = 'D:\vbTRACK_2D_GitHub\inputData';  
fileNameTrack = 'bead7track2D';

fullMatFileName = fullfile(folder,'bead7track2D.mat')
load(fileNameTrack);
    whos -file bead7track2D.mat;
%% **************************************    
%% returns track2D in pixels, uncentered, for bead7. 2x400 
% allocate array UsefulInfo for output
UsefulInfo = zeros(numVes+3,18);

%% ****************************************************
% %%-- STEP 1 pick file to be processed in folder inputData 
trial = ['20230503-(A)13','_sort.mat']; % 2023_10_19
trial
% % construct fileNames 
fileNameRaw = '20230503-(13)A'; %2023_10_19

M_sort =  track2D; %M_sort is 2x400 pixels uncentered.
numFrames = 400;  
NumberOfBeads = 1;
Batch_selected = 1;  % Force this setting for demo    
if Batch_selected == 1                    
   fprintf('Total of %d Beads\n',NumberOfBeads);
        
    ProcessedArray = [1]; % forced for GitHub code.
    BeadArrayLen = length(ProcessedArray);
end

BeadArrayProc = 0;  % count of selected beads that have been processed
%% *********************************************    **********    ********
%% MAIN LOOP over beadNumber for this cell   **************************
%% *********************************************    **********    ********
for beadNumber = 6:6  % loop is abbreviated for this demo 
    
    rr_array = linspace(1,NumberOfBeads,NumberOfBeads);
    goodDataArray(:,1) = rr_array';
track2DT = (track2D)'; %trackDT is 400x2 in pix, not centered.     
x_pixT = track2DT(:,1);  % x_pixT is 400x1 not scaled
y_pixT = track2DT(:,2);  % y_pixT is 400x1 not scaled  

%% change x,y units to microns and center
x_micronT_imageCoords = x_pixT./pix2micron; % 
y_micronT_imageCoords = y_pixT./pix2micron;
    % x_micron_imageCoords = x_pix./pix2micron; % 
    % y_micron_imageCoords = y_pix./pix2micron;
% center the particle at 0,0
x_micronT_mean = mean(x_micronT_imageCoords);
y_micronT_mean = mean(y_micronT_imageCoords);
x_micronTC = x_micronT_imageCoords - x_micronT_mean; %400 x 1
y_micronTC = y_micronT_imageCoords - y_micronT_mean; %400 x 1

% for use later with vbTRACK_2D
x_micronC = x_micronTC';  %x_micronC is 1 x 400
y_micronC = y_micronTC'   %y_micronC is 1 x 400
x_pixC = x_micronTC'.*pix2micron;  %1 x 400
y_pixC = y_micronTC'.*pix2micron;  %1 x 400
track2DC = [x_pixC; y_pixC]; % 2 x 400
track2D_micronC = [x_micronC; y_micronC]; % 2x400
% set up axis limits for Fig 1  
    offsetx = min(x_micronTC);    
    offsety = min(y_micronTC);  
    rangex = max(x_micronTC) - min(x_micronTC);
    rangey = max(y_micronTC) - min(y_micronTC);
    xxmax0 = max(x_micronTC) + .15*rangex;
    xxmin0 = min(x_micronTC) - .15*rangex;
    yymax0 = max(y_micronTC) + .15*rangey;
    yymin0 = min(y_micronTC) - .15*rangey;
    xxmax = max([xxmax0 yymax0  0.21]);
    xxmin = min([xxmin0 yymin0 -0.2000000000001]);
    yymax = xxmax;
    yymin = xxmin;0
    % add calculation of sigma based on the data
    sig_x=std(x_micronTC);
    sig_y=std(y_micronTC);
    
    datasetName = sprintf('%5s bead %i',trial, beadNumber+1);
    textFig1{1}=sprintf('%6s  bead %i ',trial, beadNumber+1)

% Construct Fig 1 xy plot of input data
pause on
     hfig1 = figure (1)   % **********************Fig 1 display input data in microns 
     clf(hfig1);
     axes1 = axes('Parent',hfig1); 
     % hold(axes1, 'on');
     % axis equal;      
        % construct G_Fig vector to control color according to time.
        colors = 'rgbkmc';  % red [1 0 0],green[0 1 0],blue[0 0 1],black[0 0 0],magenta[1 0 1], cyan[0 1 1]
        G_Fig1 = linspace(1,1,numFrames); % 1x400 double
        numFrames1 = round(numFrames/4);   % 21
        numFrames2 = round(numFrames/2);    %72    
        numFrames3 = round(3*numFrames/4);  % 104 
        G_Fig1(numFrames1+1:numFrames2) = 2;
        G_Fig1(numFrames2+1:numFrames3) = 3;
        G_Fig1(numFrames3+1:end)        = 4;
        
for k=1:4
    idx = ( G_Fig1 == k ); % idx = 1 if frame is in this state, 0 otherwise
    idx  % ARRAY. 1 1 1 1...1 0 0 0 0 0 0 0 
    switch k
       case 1
            plot(x_micronTC(idx),y_micronTC(idx),'Marker','o',...
              'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'MarkerSize',5,...
              'LineStyle','none','DisplayName','t=1:99');
             hold on;
             set(gcf,'Renderer','OpenGL');
       case 2
           plot(x_micronTC(idx),y_micronTC(idx),'Marker','o',...
              'MarkerFaceColor',[0 1 0],'MarkerEdgeColor',[0 1 0],'MarkerSize',5,...
              'LineStyle','none','DisplayName','t=100:199');
             hold on;          
       case 3 
           plot(x_micronTC(idx),y_micronTC(idx),'Marker','o',...
              'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'MarkerSize',5,...
              'LineStyle','none','DisplayName','t=200:299');
             hold on;
       case 4
           plot(x_micronTC(idx),y_micronTC(idx),'Marker','o',...
              'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'MarkerSize',5,...
              'LineStyle','none','DisplayName','t=300:399');
           hold on;
    end;  % end of switch on k
end;      % end of for k=1:Kbest L320 for
 xlabel('x (µm)','FontSize',14);
 ylabel('y (µm)','FontSize',14);
 title('Fig1 x-micron vs y-micron');
 axis equal;
    set(gca,'FontSize',14);
    xlim([-5*sig_x 5*sig_x]);
 grid on;
 box(axes1,'on');
 Ha = gca
 Ha.TickLength = [.05 .05];
 Ha.LineWidth  = 1;
 Ha.GridLineStyle = '--';
 Ha.GridAlpha = .2; % maximum line opacity = 1
 legend1 = legend(axes1,'show');
set(legend1,'Position',[0.695 0.751 0.182 0.162],'FontSize',8);
legend boxoff; 
annotation(hfig1,'textbox',[0.167 0.853 0.191 0.065],...,...
    'String',textFig1,'FitBoxToText','on','EdgeColor','none');
fprintf('finished with Fig1');
pause (1)

x_pix = track2D(1,:);  % x_pix is 1x400 not centered or scaled
y_pix = track2D(2,:);  % y_pix is 1x400 not centered or scaled
x_micronTC = x_micronT_imageCoords - x_micronT_mean; %400 x 1
y_micronTC = y_micronT_imageCoords - y_micronT_mean; %400x1
center = repmat(mean(track2D,2),1,size(track2D,2)); % 2x400
fileName = 'bead7fret_NoScaling.mat'; % 2023_10_20
std_track2DC = std(track2DC,[],2); %.5676  .3333
%% ***********************************************
%% scale the data while saving offset and scale factors for later unscaling
scale = repmat(std(track2DC,[],2),1,size(track2DC,2));
    scale % 2x400. row1 = .5676  row2 = .3333      
    track2D = track2DC./scale; % 2 x 400 
    [dim N] = size(track2D);  % track2D 2 x 399
    numFrames = N;  % Use numFrames, not N, when appropriate. N is problematic.
  
t = (1:numFrames).*(framerate.^-1);
                    % --- save variables that are in danger of being renamed
                     xusc = x_micronTC;
                     yusc = y_micronTC;
                     tusc = t;
                     k1 = kmin;
                     k2 = K;
                           
%  ****************************************************************************    
%  *******                          
                               vbTRACK_2D   
%                        Machine Learning script                                                    
%  *******                                                                                             *******
%  ****************************************************************************
% output: bestOUT and x_hat use unscaled input.
% store the scaled output 
    x_hat_scaled    =  x_hat;
    bestOutScaled =  bestOut;
 
% UNSCALE THE OUTPUT from Bayes analysis of 2D DATA. Results are in bestOut. 
% bestOut is a cell array of structures.
% Each column of bestOut{ } applies to a particular value of K. 
% K is the number of states in the model 
% Scaling (L93-98) is done by offsetting data using "center",
% then scaling the data with "scale". 
   centerX = center(1,1);   % not a function of K
   centerY = center(2,1);   %    "
   scaleX  = scale(1,1);    %    "
   scaleY  = scale(2,1);    %    "
for col = k1:k2   % col is the column index of cellarray bestOut
  % x_hat{1,col} = x_hat{1,col}.*sc_s + sc_m;
   bestOut{1,col}.m(1,:) = bestOut{1,col}.m(1,:).*scaleX + centerX;
   bestOut{1,col}.m(2,:) = bestOut{1,col}.m(2,:).*scaleY + centerY;
   bestOut{1,col}.unscaledVar(1,:) = bestOut{1,col}.scaledVar(1,1,:).*(scaleX*scaleX);  
   bestOut{1,col}.unscaledVar(2,:) = bestOut{1,col}.scaledVar(2,2,:).*(scaleY*scaleY);
   bestOut{1,col}.unscaledSigma(1,:) = sqrt(bestOut{1,col}.unscaledVar(1,:));   
   bestOut{1,col}.unscaledSigma(2,:) = sqrt(bestOut{1,col}.unscaledVar(2,:)); 
end % end for col =k1:k2 

%  Process output from vbTRACK2D  *************************************
[outFmax Kbest] = max(outF);
Kfav = Kbest;

%% --- Untangle Z. Needed because vbTRACK2D assigns Z in random order. We prefer rank order
untangleZ_t; 
untangleZ_by_time; % revised Jan 07 2019 for 2D Bayes
   
%--- Remove short bouts          ***********************
rejectSize = 5;
z_hat_untangle_clean = z_hat_untangled;
[Kbest, state_a, freq_a, z_cleaned_a, cleaned_percent_a, stateOrigin_a, freqOrigin_a, stateDuration_a, stateDurationOrigin_a, numBouts_a, numBoutsOrigin_a] = cleanBouts(z_hat_untangle_clean, Kbest,kframe,rejectSize);

stateDuration_a = stateDuration_a(1:Kbest);


Kfav = Kbest;
z_hat_untangled{1,Kfav}(1,:) = z_cleaned_a;
% compute numFrames for each state 
numFrames1 = []; numFrames2 = []; numFrames3 = []; numFrames4 = [];
numFrames5 = []; numFrames6 = [];
for k =1:Kfav
    switch k
        case 1
            numFrames1 = length(find(z_cleaned_a(1,:)==1));       
        case 2
            numFrames2 = length(find(z_cleaned_a(1,:)==2));
        case 3
            numFrames3 = length(find(z_cleaned_a(1,:)==3));
        case 4
            numFrames4 = length(find(z_cleaned_a(1,:)==4));
        case 5
            numFrames5 = length(find(z_cleaned_a(1,:)==5));
        case 6
            numFrames6 = length(find(z_cleaned_a(1,:)==6));
    end     %  end switch k
end      %  end for k=1:Kfav
% %--- Display graphs            ******************************************************
fprintf('display_figs 3,4,5');
display_figs; 
fprintf('display_fig 6');
display_fig6; pause(1);
    
end % ends loop over beadNumber 
fprintf('finished run_vbTRACK_2D\n');
