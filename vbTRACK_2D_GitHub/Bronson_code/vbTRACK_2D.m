% vbTRACK_2D    
% 2D variational Bayes, Gaussian Mixture, hidden Markov model
% thie 2D code written by gholzwarth and arnav bhandari 2018
%% Core functions by E.Khan, K.Murphy, I.Nabney,and M.Beal. 
%% This 2D code is based on 1D code written by
%% Bronson et al                                                                                                                                     %
%       https://sourceforge.net/projects/vbtrack2D                                                                                               %           
%       J.Bronson et al (Biophys J 97, 3196-3205 (2009).
%       Posterior parameters are stored in an NxK array called 'bestOut'                                                        
%       Idealized trajectories are stored in an NxK array called 'x_hat'                                                              
%       Hidden state trajectories are stored in an NxK array called 'z_hat'                                                                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Step 4. Start vbTRACK_2D\n');

% make file name to save data to
fil_name = 'file_name'; % name of output file (must be string)
d_t = clock; % time interval betwee frames in the tif stack.
save_name=sprintf('%s_d%02d%02d%02d_t%02d%02d',fil_name,d_t(2),d_t(3),d_t(1)-2000,d_t(4),d_t(5));

%%%%%%%%%%%%%%%%%%%%%
% parameter settings
%%%%%%%%%%%%%%%%%%%%%
I = 10;
N=1 % 2023_10_27
 
% settings for vbTRACK_2D
PriorPar.upi = 1;
PriorPar.mu = .5*ones(dim,1);
PriorPar.beta = 0.25;
PriorPar.W = 50*eye(dim);
PriorPar.v = 5.0;
PriorPar.ua = 1.0;
PriorPar.uad = 0;
%PriorPar.Wa_init = true;


% set the vb_opts for VBEM
% stop after vb_opts iterations if program has not yet converged
vb_opts.maxIter = 1000;     % was 100
vb_opts.threshold = 1e-6;   %was 1e-5
% display graphical analysis
vb_opts.displayFig = 0;
% display nrg after each iteration of forward-back
vb_opts.displayNrg = 0;
% display iteration number after each round of forward-back
vb_opts.displayIter = 0;
% display number of steped needed for convergance
vb_opts.DisplayItersToConverge = 0;


% set up bestOut = cell(N,K);   % Note N = 1 
bestOut=cell(N,K);
outF=-inf*ones(N,K);
best_idx=zeros(N,K);

%%%%%%%%%%%%%%%%%%%%%%%%
%run the VBEM algorithm
%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('L59 vbTRACK_2D');

for n=1:N    % ends at L 164. 
    size(track2D) % 2 x 400 double for 2D. dim = 2
    for k=kmin:K
     % revision 8/23/2018 init_mu changes with D
        ncentres = k;
        if dim==1
            init_mu = (1:ncentres)'/(ncentres+1);
        end
        if dim==2
                % init_mu(1:ncentres,1) = (1:ncentres)/(ncentres+1);
                % init_mu(1:ncentres,2) = (1:ncentres)/(ncentres+1);
                % init_mu(:,1) = (1:ncentres)'/(ncentres+1);
                % init_mu(:,2) = (1:ncentres)'/(ncentres+1);
             % Murphy-Kahn-2012 method
                perm = randperm(numFrames);
                v=var(track2D'); %  v is [1 1.000] x 2
                % v = var(X);
                noise = gaussSample(zeros(1, length(v)), 0.01*diag(v), k);
                    size(noise);  % [.02,.2]
                track2D_trans = track2D'; %track2D_trans is 399 x 2
                    % track2D_trans(perm(1:k),:)
                    % size(track2D_trans(perm(1:k),:));
                    mu_MurphyKahn   = track2D_trans(perm(1:k), :) + noise;
        end
          init_mu = mu_MurphyKahn;
          
        i=1;
        maxLP = -Inf;
        while i<I+1    % loop over i, different init_mu each time
            if k==1 && i > 3
                break
            end
            if i > 1
                if dim==1
                init_mu = randn(ncentres,1); 
                end
                if dim==2
                    % Murphy-Kahn-2012 method for init_mu
                    perm = randperm(numFrames);
                    v=var(track2D'); %  v is 1 x 2
                    noise = gaussSample(zeros(1, length(v)), 0.01*diag(v), k);
                    track2D_trans = track2D'; %track2D_trans is 399 x 2
                    init_mu   = track2D_trans(perm(1:k), :) + noise;
                    % *** end Murphy_Kahn method for init_mu.
                        %   init_mu(:,1) = randn(ncentres,1);  
                        %   init_mu(:,2) = randn(ncentres,1); 
                end
            end
          clear mix out;
            disp(sprintf('Working on inference for restart %d, k%d of trace %d...',i,k,n))
            % Initialize gaussians
            % Note: x and mix can be saved at this point and used for future
            % experiments or for troubleshooting. try-catch needed because
            % sometimes the K-means algorithm doesn't initialze and the program
            % crashes otherwise when this happens.
 
 
 
        
        
% older version        
%         ncentres = k;
%         init_mu = (1:ncentres)'/(ncentres+1);
%         i=1;
%         maxLP = -Inf;
%         while i<I+1    % loop over i, different init_mu each time
%             if k==1 && i > 3
%                 break
%             end
%             if i > 1
%                 init_mu = rand(ncentres,1);  % init_mu given random value
%             end
%             clear mix out;
%             disp(sprintf('Working on inference for restart %d, k%d of trace %d...',i,k,n))
%             % Initialize gaussians
%             % Note: x and mix can be saved at this point and used for future
%             % experiments or for troubleshooting. try-catch needed because
%             % sometimes the K-means algorithm doesn't initialze and the program
%             % crashes otherwise when this happens.
% % insert ********************
%  try
%                 [mix] = get_mix(track2D',init_mu);               
%                 [out] = vbFRET_VBEM(track2D, mix, PriorPar, vb_opts);
%                 catch
%                 disp('There was an error, repeating restart.');
%                 runError=lasterror;
%                 disp(runError.message)
%                 continue
%            end
% % end insert ************************
  try
     [mix] = get_mix(track2D',init_mu);               
     [out] = vbTRACK2D_VBEM(track2D, mix, PriorPar, vb_opts);
         %[out] = vbFRET_VBEM(track2D, mix, PriorPar, vb_opts);
  catch
     disp('There was an error, repeating restart.');
     runError=lasterror;
     disp(runError.message)
     continue
  end
            
            % Only save the iterations with the best out.F
            if out.F(end) > maxLP
                maxLP = out.F(end);
                    % bestMix{n,k} = mix;
                bestOut{n,k} = out;  % n is always 1. Thank you 
                outF(n,k)=out.F(end);
                best_idx(n,k) = i;
            end
            i=i+1;
        %Movie1
        end   % end while loop,rerun vbFRET_VBEM with different init_mu each time
    end  % end of "for k=kmin:K 
   % save results
   %save(save_name);           

end % end of "for n=1:N"

%%%%%%%%%%%%%%%%%%%%%%%% VBHMM postprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%

% analyze accuracy and save analysis
disp('run chmmViterbi algorithm...')

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get idealized data fits for Entire track, using Viterbi
%%%%%%%%%%%%%%%%%%%%%%%%%%
z_hat=cell(N,K);  % Remember N= 1 in Bronson's weird notation. 
x_hat=cell(N,K);  %    "
for n=1:N         %    "
    for k=kmin:K
        [z_hat{n,k} x_hat{n,k} omega bestPriorZ] = chmmViterbi(bestOut{n,k},track2D);
        % or 
        % [z_hat{n,k} x_hat{n,k} omega bestPriorZ] = chmmViterbi(bestOut{n,k},track2D');
    end
end

disp('...done w/ chmmViterbi') 





