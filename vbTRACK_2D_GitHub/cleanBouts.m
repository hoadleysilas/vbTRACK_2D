% cleanBouts.m
% Written by Arnav Bhandari 1/29/2018
% removes bouts shorter than rejectsize
%
% Creates a new datastructure called state and freq to solve this problem 

function [Kbest, state,freq,z_cleaned,percentChanged, stateOrigin, freqOrigin, stateFreq, stateFreqOrigin, numBouts, numBoutsOrigin] = cleanBouts(z_hat_untangle_clean, Kbest, kframe, rejectSize)
    % Runs run_vbTRACK_Excel
    % origin = z_hat_untangle_clean;
   
    %Runs TestScriptForBoutCounter
    origin = z_hat_untangle_clean{1,Kbest};
    stateFreq = zeros(Kbest,1); 
    stateFreqOrigin = zeros(Kbest,1); 
    numBouts = zeros(Kbest,1); 
    numBoutsOrigin = zeros(Kbest,1); 
    
    % inputs
        %     z_hat_untangle_clean, 1 x (numFrames -1) double
        %     Kbest   single number
        %     kframe   change name to numFrames for consistency
        %     rejectSize  This can be changed in line 48 pf run_vbTrack
    % outputs
        %     state:          row vector e.g. 1,2,3,4
        %     freq:           row vector containing duration of state.
                                %  Bad name. Should be renamed as 
                                % boutDuration or totalDuration
        %     cleaned         new cleaned z_hat_untangled_clean, 1 x (numFrames -1)   
        %     percentChanged  Overall % differing states
        %     stateOrigin     value before cleaning 
        %     freqOrigin      value before cleaning 
        %     stateFreq       Duration of each state by state number
        %     stateFreqOrigin Duration of each state by state number before cleaning 
        %     numBouts        Number of bouts per state
       
    state = zeros(1,Kbest);   % row vector
    freq = zeros(1,Kbest);   % row vector  probably incorrectly assigned

    state(1,1) = origin(1,1); 
    freq(1,1) = 1; 

    j = 1; %counter for new data structure Name??? 

    for i = 2:kframe
        if origin(1,i) == state(1,j)
            freq(1,j) = freq(1,j) + 1;
        else
            j = j+1; 
            state(1,j) = origin(1,i); 
            freq(1,j) = 1; 
        
        end
    end
    
    state = state(1:j);
    freq = freq(1:j);
    
    stateOrigin = state;
    freqOrigin = freq;
    
    %state
    %freq
    
    [minfreq,index] = min(freq);
    
    while(minfreq <= rejectSize)
        
        prev = index - 1;
        next = index + 1; 
                
        if index == 1
            freq(1,2) = freq(1,2) + freq(1,1);
            %
            state = state(2:j);
            freq = freq(2:j);
            j = j - 1; 

        elseif index == j
            freq(1,j-1) = freq(1,j-1) + freq(1,j); 
            %
            state = state(1:j-1);
            freq = freq(1:j-1);
            j = j - 1; 

        else 
            switch minfreq
                case 1
                    % Only randomly assigne which happens later 
                case 2
                    freq(1,prev) = freq(1,prev) + 1;
                    freq(1,next) = freq(1,next) + 1;
                    
                case 3
                    freq(1,prev) = freq(1,prev) + 1;
                    freq(1,next) = freq(1,next) + 1;
                    
                case 4
                    freq(1,prev) = freq(1,prev) + 2;
                    freq(1,next) = freq(1,next) + 2;
                    
                case 5
                    freq(1,prev) = freq(1,prev) + 2;
                    freq(1,next) = freq(1,next) + 2;
                    
            end
            
            %if it is odd then 1 freq gets randomly assigned 
            if(rem(minfreq,2) == 1)
                rnum = rand(1,1);
                if rnum < 0.5 
                    freq(1,prev) = freq(1,prev) + 1;
                else 
                    freq(1,next) = freq(1,next) + 1;
                end
            end
            
            %concatenate the required parts i.e. removing the middle bout
            freq = cat(2, freq(1:prev), freq(next:j));
            state = cat(2, state(1:prev), state(next:j));
            
            j = j - 1; 
            
            % if the deleted state has the same state to the left and right 
            if(state(1,prev) == state(1,prev+1))
                
                %output before the states get combined 
                %state
                %freq
                
                %combine states 
                freq(1,prev) = freq(1,prev) + freq(1,prev+1);
            
                freq = cat(2, freq(1:prev), freq(prev+2:j));
                state = cat(2, state(1:prev), state(prev+2:j));
            
                j = j - 1;
            
            end
        end
    
        [minfreq,index] = min(freq);
        
        %output at each iteration for debugging
        %state
        %freq
    end
       
    %Convert back to standard format for output 
    
    z_cleaned = zeros(1,kframe); 
    k = 1; 
    i = 1;
    while (i < kframe)
        
        for j = 1:freq(1,k)
            z_cleaned(1,i) = state(1,k);
            i = i + 1;
        end
        k = k+1;
    end
   
    %Normalize in a bout if a state is cleared

    cleaned = zeros(1, Kbest);
    for i = 1 : Kbest
        if ~ismember(i, z_cleaned)
            cleaned(1, i) = 1;
        end
    end
    
    for i = 1 : nnz(cleaned == 0)
        
        if ~ismember(i, z_cleaned)
            Kbest = Kbest - 1;
            for j = i + 1 : 6
                z_cleaned(z_cleaned == (j)) = j-1;      
            end
        end
    end
    
    
    %Calculate the % change that this code makes to z 
    
    numChanged = 0; 
    
    for i = 1:kframe
        if (origin(1,i) ~= z_cleaned(1,i))
            numChanged = numChanged + 1;
        end
        
        stateFreq(z_cleaned(1,i),1) = stateFreq(z_cleaned(1,i),1) + 1; 
        stateFreqOrigin(origin(1,i),1) = stateFreqOrigin(origin(1,i),1) + 1; 
    end
    
    for j = 1: length(state)
        numBouts(state(1,j),1) = numBouts(state(1,j),1) + 1;
    end
    
    for j = 1: length(stateOrigin)
        numBoutsOrigin(stateOrigin(1,j),1) = numBoutsOrigin(stateOrigin(1,j),1) + 1;
    end
    
    % Assign output variables
     %state
     %freq
     %z_hat_untangle_clean{1,Kbest}
     %z_cleaned
    percentChanged = numChanged*100/kframe;
    
    
    fprintf('z_cleaned by %.2f%%\n', percentChanged);
    
end 

