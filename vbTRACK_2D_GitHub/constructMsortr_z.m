function [M_sort_r, idx_struct]  = constructMsortr_z( x,y,z_cleaned_a,Kfav,frame_rate,numFrames1,numFrames2,numFrames3,numFrames4,numFrames5,numFrames6,pauseTimeCode)
% prepare matrix of track data for 1 bead separated into Kfav states
% folder: F:\Userdata\Arnav\Matlab\Arnav_edited\vbTRACK_SF
% inputs: x,y,beadNum,z_hat
% This version computes M for each state separately, then catenates
% This version adds col 12=z_hat (state).
% deleted 1e6 on x, y for M1, M2,...M6 cols 5,6 2013_04_17
 
% cols in M_sort_r_z
%  1   2     3      4  5  6  7      8   9  10         11
%  t beadID  frame  x  y  r  state  dx dy  cumsum_dx  cumsum_dy
%  dx = increment in x for that frame 
fprintf('Step 9. Start constructMsortr\n');
size(x)
diffx = diff(x);
size(diffx)
diffy = diff(y);
size(diffy)
for state=1:Kfav
    switch state
        case  1  % compute M1 for state 1  *******************************************   M1
beadID = 0;   % Why is beadID hardcoded to 0 here? 
numRowsM1 = numFrames1 %
numColsM1 = 11
M1 = zeros(numRowsM1,numColsM1);
idx_struct(1).Kfav = [Kfav ]
idx_struct(1).state =[state]
idx_struct(1).data = find(z_cleaned_a(1,:)==1)   % indices, not data
idx_struct(1).diffdata = find(z_cleaned_a(1,1:(end-1))==1) % index, not diffdata
M1(:,1) = transpose(linspace(0,(numFrames1-1)/frame_rate,numFrames1));% TIME
M1(:,2) = transpose(linspace(1,numFrames1,numFrames1));               % FRAME
M1(:,3) = beadID % beadID
LL1 = length(idx_struct(1).data)
M1(1:LL1,4) = (x(idx_struct(1).data))' %  transpose(linspace(1,numRowsM1,numRowsM1)); %x ERROR
M1(1:LL1,5) = (y(idx_struct(1).data))' %  transpose(linspace(1,numRowsM1,numRowsM1)); %y 
    % debugging checks
LL1diff = length(diffx(idx_struct(1).diffdata)')
M1(1:LL1diff,8) = diffx(idx_struct(1).diffdata)'
M1(1:LL1diff,9) = diffy(idx_struct(1).diffdata)'

L8          = length(cumsum(M1(:,8),1));
M1(1:L8,10) = cumsum(M1(:,8),1);
L9         = length(cumsum(M1(:,9),1));
M1(1:L9,11)= cumsum(M1(:,9),1);
M1(:,6) = 0.5e-6;
M1(:,7) = state;
M1

        case 2  % compute M2 for state 2  *******************************************   M2
beadID = 0;
numRowsM2 = numFrames2; 
numColsM2 = 11;
idx_struct(2).Kfav = [Kfav ];
idx_struct(2).state =[2];
idx_struct(2).data = find(z_cleaned_a(1,:)==2); %returns index, not data
idx_struct(2).diffdata = find(z_cleaned_a(1,1:(end-1))==2) % returns index, not diffdata

M2     = zeros(numRowsM2,numColsM2);
M2(:,1)= linspace(0,(numFrames2-1)/frame_rate,numFrames2); % time
M2(:,2)= linspace(1,numFrames2,numFrames2);                % frame 
M2(:,3) = beadID;
M2(:,4) = x(idx_struct(2).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %x
M2(:,5) = y(idx_struct(2).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %y 

%debugging checks
LL2 = length((diffx(idx_struct(2).diffdata))') % L66
M2(1:LL2,8) = (diffx(idx_struct(2).diffdata))'; % ERROR
M2(1:LL2,9) = (diffy(idx_struct(2).diffdata))';
    L9             = length(cumsum(M2(:,9)));
M2(1:L9,10)  = cumsum(M2(:,9));
    L10           = length(cumsum(M2(:,10)));
M2(1:L10,11) = cumsum(M2(:,10));
M2(:,6)     = 0.5e-6;
M2(:,7)     = state;

        case 3      % compute M3 for state 3  **************************************  M3
% ***********insert
beadID = 0;
numRowsM3 = numFrames3; 
numColsM3 = 11;
idx_struct(3).Kfav = [Kfav ];
idx_struct(3).state =[2];
idx_struct(3).data = find(z_cleaned_a(1,:)==3); %returns index, not data
idx_struct(3).diffdata = find(z_cleaned_a(1,1:(end-1))==3) % returns index, not diffdata

M3     = zeros(numRowsM3,numColsM3);
M3(:,1)= linspace(0,(numFrames3-1)/frame_rate,numFrames3);  % time (s)
M3(:,2)= linspace(1,numFrames3,numFrames3);
M3(:,3) = beadID;
M3(:,4) = x(idx_struct(3).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %x
M3(:,5) = y(idx_struct(3).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %y 

%debugging checks
LL3 = length((diffx(idx_struct(3).diffdata))') % L66
M3(1:LL3,8) = (diffx(idx_struct(3).diffdata))'; % ERROR
M3(1:LL3,9) = (diffy(idx_struct(3).diffdata))';
    L9             = length(cumsum(M3(:,9)));
M3(1:L9,10)  = cumsum(M3(:,9));
    L10           = length(cumsum(M3(:,10)));
M3(1:L10,11) = cumsum(M3(:,10));
M3(:,6)     = 0.5e-6;
M3(:,7)     = state;

        case 4   % compute M4 for state 4  ***************************  M4 
            %  ************ insert
            beadID = 0;
numRowsM4 = numFrames4; 
numColsM4 = 11;
idx_struct(4).Kfav = [Kfav ];
idx_struct(4).state =[4];
idx_struct(4).data = find(z_cleaned_a(1,:)==4); %returns index, not data
idx_struct(4).diffdata = find(z_cleaned_a(1,1:(end-1))==4) % returns index, not diffdata

M4     = zeros(numRowsM4,numColsM4);
M4(:,1)= linspace(0,(numFrames4-1)/frame_rate,numFrames4);
M4(:,2)= linspace(1,numFrames4,numFrames4);
M4(:,3) = beadID;
M4(:,4) = x(idx_struct(4).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %x
M4(:,5) = y(idx_struct(4).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %y 

%debugging checks
LL4 = length((diffx(idx_struct(4).diffdata))') % L66
M4(1:LL4,8) = (diffx(idx_struct(4).diffdata))'; % ERROR
M4(1:LL4,9) = (diffy(idx_struct(4).diffdata))';
    L9             = length(cumsum(M4(:,9)));
M4(1:L9,10)  = cumsum(M4(:,9));
    L10           = length(cumsum(M4(:,10)));
M4(1:L10,11) = cumsum(M4(:,10));
M4(:,6)     = 0.5e-6;
M4(:,7)     = state;

        case 5
            beadID = 0;
numRowsM5 = numFrames5; 
numColsM5 = 11;
idx_struct(5).Kfav = [Kfav ];
idx_struct(5).state =[5];
idx_struct(5).data = find(z_cleaned_a(1,:)==5); %returns index, not data
idx_struct(5).diffdata = find(z_cleaned_a(1,1:(end-1))==5) % returns index, not diffdata

M5     = zeros(numRowsM5,numColsM5);
M5(:,1)= linspace(0,(numFrames5-1)/frame_rate,numFrames5);
M5(:,2)= linspace(1,numFrames5,numFrames5);
M5(:,3) = beadID;
M5(:,4) = x(idx_struct(5).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %x
M5(:,5) = y(idx_struct(5).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %y 

%debugging checks
LL5 = length((diffx(idx_struct(5).diffdata))') % L66
M5(1:LL5,8) = (diffx(idx_struct(5).diffdata))'; % ERROR
M5(1:LL5,9) = (diffy(idx_struct(5).diffdata))';
    L9             = length(cumsum(M5(:,9)));
M5(1:L9,10)  = cumsum(M5(:,9));
    L10           = length(cumsum(M5(:,10)));
M5(1:L10,11) = cumsum(M5(:,10));
M5(:,6)     = 0.5e-6;
M5(:,7)     = state;

        case 6
            beadID = 0;
numRowsM6 = numFrames6; 
numColsM6 = 11;
idx_struct(6).Kfav = [Kfav ];
idx_struct(6).state =[6];
idx_struct(6).data = find(z_cleaned_a(1,:)==6); %returns index, not data
idx_struct(6).diffdata = find(z_cleaned_a(1,1:(end-1))==6) % returns index, not diffdata

M6     = zeros(numRowsM6,numColsM6);
M6(:,1)= linspace(0,(numFrames6-1)/frame_rate,numFrames6);
M6(:,2)= linspace(1,numFrames6,numFrames6);
M6(:,3) = beadID;
M6(:,4) = x(idx_struct(6).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %x
M6(:,5) = y(idx_struct(6).data)' %  transpose(linspace(1,numRowsM1,numRowsM1)); %y 

%debugging checks
LL6 = length((diffx(idx_struct(6).diffdata))') % L66
M6(1:LL6,8) = (diffx(idx_struct(6).diffdata))'; % ERROR
M6(1:LL6,9) = (diffy(idx_struct(6).diffdata))';
    L9             = length(cumsum(M6(:,9)));
M6(1:L9,10)  = cumsum(M6(:,9));
    L10           = length(cumsum(M6(:,10)));
M6(1:L10,11) = cumsum(M6(:,10));
M6(:,6)     = 0.5e-6;
M6(:,7)     = state;

end % end of switch Kfav L37
end  % end for state L36

% Construct Msort_r by catenating M1, M2, M3,.... Note that frame and t will no
% longer go smoothly from 1 to numFrames in Msort_r
for K=1:Kfav
    switch K
        case 1
            M_sort_r = M1(1:numFrames1,1:8);
        case 2
            M_sort_r = vertcat(M_sort_r, M2(1:numFrames2,1:8));  
        case 3
            M_sort_r = vertcat(M_sort_r, M3(1:numFrames3,1:8));  
        case 4
            M_sort_r = vertcat(M_sort_r, M4(1:numFrames4,1:8)); 
        case 5
            M_sort_r = vertcat(M_sort_r, M5(1:numFrames5,1:8));
        case 6
            M_sort_r = vertcat(M_sort_r, M6(1:numFrames6,1:8));
     end      % end switch  Kfav L137
end        % end of for K=1:Kfav
end % end of FUNCTION