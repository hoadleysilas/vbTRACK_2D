function [ BB ] = zToBouts(z)
% Based on function [B]= bout_length(z)
% Edited by Arnav 10/3/2018
% gholzwarth 2014, 2017
% extracts bouts from z, putss them into correct column of BB
% inputs:  z , ColumnInBB  (zCol has been deleted from list. Not used)
% start copy/paste *******************************************************
% inputs: z, zCol(not used), and ColumnInBB
ColumnInBB = [1,2,3,4,5,6];
pause on; pauseTime = 0.01; 

BB = cell(20,7);  % row = index of bouts for a given value of z (e.g. 1,2,3,...7)
    % col = references binned value by m(z).
    % LUT is col    1    2    3    4    5    6    7
    %           z   7    6    5    4    3    2    1
    %       m(z) -300  -200  -100  0   100  200  300
  
% initialize counters ctr1:ctr7 which count the number of the bout for each column.     
ctr1 = 0; % initialize counter for BB(:,1)
ctr2 = 0; % initialize counter for BB{:,2}
ctr3 = 0; % initialize counter for BB(:,3)
ctr4 = 0; % initialize counter for BB(:,4)
ctr5 = 0; % initialize counter for BB{:,5}
ctr6 = 0; % initialize counter for BB{:,6}
ctr7 = 0; % initialize counter for BB{:,7}

% special steps for first frame
    r = 1; i = 1; % figure (8)
    % cellplot(BB, 'legend');
  fprintf('zToBouts L27. z(1) = \n'); z(1)  
  switch z(1)
      case 1   % goes in col 7
         BB{r,ColumnInBB(z(1))}=[1];
         ctr7 = 1;
         % cellplot(BB, 'legend');
      case 2  % goes in col 6
         BB{r,ColumnInBB(z(i))}(1) =[1];
         ctr6 = 1;
      case 3  % goes in col 5
         BB{r,ColumnInBB(z(i))}(1) =[1];
         ctr5 = 1;
      case 4  % goes in col 4
         BB{r,ColumnInBB(z(i))}(1) =[1];
         ctr4 = 1;
      case 5  % goes in col 3
         BB{r,ColumnInBB(z(i))}(1) =[1];
         ctr3 = 1;
      case 6  % goes in col 2
         BB{r,ColumnInBB(z(i))}(1) =[1];
         ctr2 = 1;
      case 7  % goes in col 1
         BB{r,ColumnInBB(z(i))}(1) =[1];
         ctr1 = 1;
      otherwise
         fprintf('problem initializing BB\n');
  end         
    fprintf('This completes first frame issue. Check BB');
    % cellplot(BB, 'legend');
    % title('first frame section completed');
    % pause (1);

    
  %   start PRIMARY LOOP constructing BB array for rest of the frames
   for i=2:length(z); %  Ends at L109
       if (z(i)==1) % frame goes into col 7
%            % **********************************
%             BB{r,ColumnInBB(z(1))}=[1];
%          ctr7 = 1;
%            % *********************************
          if (z(i-1)~=1)  % need to start new bout
              ctr7 = ctr7 +1   
              BB{ctr7,ColumnInBB(z(i))}=[0]; % was z(1)
          end
  
          % STEP 1 read cell of BB
            activeBout = BB{ctr7,ColumnInBB(z(i))}(1); % error here. index exceeds matrix dimensions
          % STEP 2 change value of cell
            activeBout = activeBout + 1;
          % STEP 3 load new value back into BB
            BB{ctr7,ColumnInBB(z(i))}(1) = activeBout;  
          % cellplot(BB, 'legend');
          % pause (.01);
       end   % end of if(z(i)==1
        
      if (z(i)==2) % frame goes into col 6
          if(z(i-1)~=2) % need to start new bout
             ctr6 = ctr6 + 1;   
             BB{ctr6,ColumnInBB(2)}=[0];
          end
         % STEP 1 read cell of BB
             activeBout = BB{ctr6,ColumnInBB(z(i))}(1);
         % STEP 2 change value of cell
             activeBout = activeBout + 1;
         % STEP 3 load new value back into BB
                 BB{ctr6,ColumnInBB(z(i))}(1) = activeBout;
                 % cellplot(BB, 'legend');
                 % pause (.01)     
      end
       
      if (z(i)==3) % goes in col 5
          if(z(i-1)~=3)  % need to start a new bout
              ctr5 = ctr5 + 1;   
              BB{ctr5,ColumnInBB(z(i))} = [0];
          end
         % STEP 1 read cell of BB
             activeBout = BB{ctr5,ColumnInBB(z(i))};
         % STEP 2 change value of cell
             activeBout = activeBout + 1;
         % STEP 3 load new value back into BB
                 BB{ctr5,ColumnInBB(z(i))} = activeBout;
                 % cellplot(BB, 'legend');
                 % pause (.01)     
       end
        
       if (z(i)==4 ) % goes in col 4
          if(z(i-1)~=4)  % need to start a new bout
              ctr4 = ctr4 + 1;   
              BB{ctr4,ColumnInBB(z(i))} = [0];
          end
         % STEP 1 read cell of BB
             activeBout = BB{ctr4,ColumnInBB(z(i))};
         % STEP 2 change value of cell
             activeBout = activeBout + 1;
         % STEP 3 load new value back into BB
                 BB{ctr4,ColumnInBB(z(i))} = activeBout;
%                 cellplot(BB, 'legend');
%                pause (.01)     
       end
           
       if (z(i)==5)   % goes in col 3
           if(z(i-1)~=5)  % need to start a new bout
              ctr3 = ctr3 + 1;   
              BB{ctr3,ColumnInBB(z(i))} = [0];
          end
         % STEP 1 read cell of BB
             activeBout = BB{ctr3,ColumnInBB(z(i))};
         % STEP 2 change value of cell
             activeBout = activeBout + 1;
         % STEP 3 load new value back into BB
             BB{ctr3,ColumnInBB(z(i))} = activeBout;
%              cellplot(BB, 'legend');
%             pause (0.01)     
       end
              
       if (z(i)==6)  % goes in col 2
          if(z(i-1)~=6)  % need to start a new bout
              ctr2 = ctr2 + 1;   
              BB{ctr2,ColumnInBB(z(i))} = [0];
          end
         % STEP 1 read cell of BB
             activeBout = BB{ctr2,ColumnInBB(z(i))};
         % STEP 2 change value of cell
             activeBout = activeBout + 1;
         % STEP 3 load new value back into BB
                 BB{ctr2,ColumnInBB(z(i))} = activeBout;
%             cellplot(BB, 'legend');
%             pause (.01)     
       end
            
       if (z(i)==7)  % goes in col 1
          if(z(i-1)~=7)  % need to start a new bout
              ctr1 = ctr1 + 1;   
              BB{ctr1,ColumnInBB(z(i))} = [0];
          end
         % STEP 1 read cell of BB
             activeBout = BB{ctr1,ColumnInBB(z(i))};
         % STEP 2 change value of cell
             activeBout = activeBout + 1;
         % STEP 3 load new value back into BB
                 BB{ctr1,ColumnInBB(z(i))} = activeBout;
%                 cellplot(BB, 'legend');
%                 pause (.01)     
       end
end   % end of for loop


end   % end of function

