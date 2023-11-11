% vrpnToMatlab_one_bead_script.m
    % vrpnToMatlab_one_bead_script('G') 

fprintf('Select *.vrpn.mat file that contains tracker data')
% ********************************* start paste
fprintf('STEP 1.0  Get fileName, folderName\n');
    [dataFileName,dataFolderName] = uigetfile('*.mat','Select vrpn.mat file');
    dataFileName = '20230503-(13)A.vrpn.mat';
    dataFolderName 
    % construct fileNameMat for saving S
    [pathstr, fileName_noExt, ext] = fileparts(dataFileName);    
    dataFileNameFullnoExt = fullfile(dataFolderName,fileName_noExt)
    fileNameS  = strcat(fileName_noExt,'_sort.mat'); 
    
% STEP 1.2.  load vrpn.mat file
load ([dataFolderName dataFileName]);
whos('-file', '20230503-(13)A.vrpn.mat');
% returns tracking 1x1 416i728 bytes struct.
Stest=load ([dataFolderName dataFileName]);
fields(Stest)

    % 1x1 cell array 
    % {'ttacking'}
    
M100 =Stest.tracking.spot3DSecUsecIndexFramenumXYZRPY;
size(M100)
% STEP 1.2 construct numVesicles, numFrames conputed by DeletingRowsofMsort
        % DeletingRowsofMsort;
numVesicles = max(M100(:,3))+1
numFrames = max(M100(:,4))+1

%% ***************************************************** SORT M100  ******
% STEP 1.3 Sort M100 by vesicleNum
%% ***************************************************** SORT M100  ******

M_sort = sortrows(M100,3);   % KEY STEP. Sorts M100 on beadNum ccl3
fprintf('L43 Array M_sort Cols 3    4    5    6\n') 
fprintf('                    bead frame  x    y\n');
M_sort(1:35,3:6);
M_sort(:,1) = 0.0;    % trash in column
M_sort(:,2) = 0.0;    % trash in column
% *************** start save

%% define a new structure S ********************************************
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

