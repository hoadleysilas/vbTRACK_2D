function [ x_center_pix , y_center_pix ] = getCenterIMG(trial,x_pix_bar, y_pix_bar)
% ab 2018. June 26, 2020 reverted to 3/21/2020 backup.
% x_center_pix and y_center_pix define center of trial image.
% Coordinate Origin (1,1) is upper left corner

oldWorkingFolder = cd('G:\01 VSV ImageJ Output'); % check on (0,0) location in these ImageJ ROI's

dataFileName = trial + ".tif";
dataFileName = convertStringsToChars(dataFileName)
trialIMG = imread(dataFileName, 1);
[ yyy , xxx ] = size(trialIMG);  % x,y in pixels 349,295 for 8-37
Imax = max(max(max(trialIMG)));
x_center_pix = round(xxx/2);         % center column 175        
y_center_pix = round(yyy/2);         % center row    148

% mark 1,1
    trialIMG(1:10,1:50)= 0.0;
% mark Xc, Yc as placeholder for center of nucleus
    trialIMG((y_center_pix-4):(y_center_pix +4),(x_center_pix-4):(x_center_pix +4)) = Imax;
% show particle inside box centered on x_pix_bar, y_pix_bar
    trialIMG((y_pix_bar-5):(y_pix_bar+5), (x_pix_bar+5):(x_pix_bar+6)) = Imax; % Right vertical
    trialIMG((y_pix_bar-5):(y_pix_bar+5), (x_pix_bar-6):(x_pix_bar-5)) = Imax; % Left vertical
    trialIMG((y_pix_bar+5):(y_pix_bar+6), (x_pix_bar-5):(x_pix_bar+5)) = Imax; % top horizontal
    trialIMG((y_pix_bar-6):(y_pix_bar-5), (x_pix_bar-5):(x_pix_bar+5)) = Imax; % bottom horizont
%    figure
%    imshow(trialIMG,[])
%        title([dataFileName, ' in getCenterIMG']);
%        pause (10)
cd(oldWorkingFolder); % changed 2019_04_14
    % cd('F:\Userdata\Arnav\Matlab\ArnavEdited\vbTRACK_SF'); 
end