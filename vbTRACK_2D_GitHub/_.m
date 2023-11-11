% fileName = vrpnToMatlab_sorted_file.m
     % folderName F:\Userdata\Arnav\Matlab\ArnavEdited\ on HP Z4 #1
        % Previous name = vrpnToMatlab_one_bead_script.m
        % Previous folderName = E:\U\M\George\  Olin 213 Lenovo desktop

% uses logical_subscript to pull out data for one bead at a time
% backup 2012_05_31
%       _2012_06_03  Sorting on bead number working. Add DIC_sizing next
% backup 2017_10_18 working with VSV RNP particles
% clc;
% clear all;
% close all;
% 
% 
% pause off ;
% 
% vrpnToMatlab_one_bead_script;  % 2023_10_02
% function [fileNameS,dataFolderName] = vrpnToMatlab_one_bead_script(drive)

fprintf('Select *.vrpn.mat file that contains tracker data')
% ********************************* start paste
fprintf('STEP 1.0  Get fileName, folderName\n');
        % cd(strcat(drive,''));
        % cd(strcat(drive,':\03 VSV Matlab Input'));
        % cd('G:\Lanie VSV Data\Lanie 07302014\CD2');
        % cd('E:\Userdata\Matlab\Pierre_Vidi\realData\170404_7x7_Amanda\');
        %  https://drive.google.com/open?id=0B3y3ukaV0xgBTGtrcXd3UWgxX3c
        % cd('E:\Userdata\Matlab\Pierre_Vidi\realData\Data_7x7\');
    [dataFileName,dataFolderName] = uigetfile('*.mat','Select vrpn.mat file');
    % construct fileNameMat for saving S
    [pathstr, fileName_noExt, ext] = fileparts(dataFileName);    
    fileNameS  = strcat(fileName_noExt,'_sort.mat'); 
    
% STEP 1.2.  load vrpn.mat file
Stest=load ([dataFolderName dataFileName]);
fields(Stest)

    % M100 = S.M100;
    % size(M100)

M100 =Stest.tracking.spot3DSecUsecIndexFramenumXYZRPY;

% STEP 1.2 construct numVesicles, numFrames conputed by DeletingRowsofMsort
        % DeletingRowsofMsort;
numVesicles = max(M100(:,3))+1;
numFrames = max(M100(:,4))+1;
        
numVesicles
numFrames

% STEP 1.3 Sort M2 to collect data by vesicleNum
M_sort = sortrows(M100,3);   % KEY STEP.
fprintf('L43 Array M_sort Cols 3    4    5    6\n') 
fprintf('                    bead frame  x    y\n');
M_sort(1:35,3:6);
M_sort(:,1) = 0.0;    % trash in column
M_sort(:,2) = 0.0;    % trash in column
% *************** start save

S.fileName       = dataFileName;
S.folderName     = dataFolderName;
                            %   S.t_array_sec    = t_array_sec;
                            %   S.pix_per_micron = pix_per_micron;
S.numFrames      = numFrames;
S.numVesicles    = numVesicles;
S.M_sort         = M_sort;
save(fileNameS, 'S');

% STEP 2 pull out data for one bead from M_sort
% Select a bead, subtract x_mean from each x
% construct time array
t = linspace(1,numFrames,numFrames);
for Nbead = 0 : numVesicles-1 % Nbead is bead_number
   clc;
   thisbead_idx = find(M_sort(:,3) == Nbead);
   M_sort_one_bead = M_sort(thisbead_idx,3:6);
   size(M_sort_one_bead)
   
 % Shift (0,0) of track to (x-mean,y-mean)                 
    x_mean = mean(M_sort_one_bead(:,3));
    y_mean = mean(M_sort_one_bead(:,4));
% 
    M_sort_one_bead(:,3) = M_sort_one_bead(:,3) - x_mean;
    M_sort_one_bead(:,4) = M_sort_one_bead(:,4) - y_mean;
%  
   % plot shifted track
%    figureNumber = 5+Nbead;
%    figure(figureNumber);
%     
%     plot(M_sort_one_bead(:,3),M_sort_one_bead(:,4),'-sqk');
%         daspect([1 1 1])
%         title(['x vs y BeadID = ', num2str(Nbead)]);
%         xlabel('x');
%         ylabel('y');
%     end    % end of for loop over Nbead
 
end

