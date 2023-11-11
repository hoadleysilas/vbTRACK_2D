% untangleZ_Kfav.m
% Matthew J. Martin and G. Holzwarth, 2013
% This program untangles the random numerical assignments of Z for a model 
% with Kfav states, and sorts them. The sorting criterion is different for VT = 'V' and VT = 'T'.  
% Kfav is number of states in the selected model;
% kk is index for a state within a model;
% inputs     = z_hat, Kfav,
% output    = z_hat_untangled
% modified Jan 2019 so z_hat_untangled is determined by time.
fprintf('Step 5.2 Start untangleZ_Kfav\n');

% define length_adj to handle length of input data array 
switch VT
    case 'V'
        length_adj = 0;
    case 'T'
        length_adj = 1;
end

% --- Step 1 find the data points associated with state=kk for model=Kfav
% using current z_hat
indexofZ = cell(1,Kfav);  % cols designate kk
z_hat_value = zeros(1,Kfav);
model = Kfav;     % loop over models
    for kk = 1:Kfav % loop over states within a model
        indexofZ{kk,Kfav}=(find(z_hat{1,model}==kk))';
        z_hat_value(1,kk) = kk;
    end
    
% --- Step 1.1 Compute the standard deviation of FRET data in state 1 and 2
if VT=='T'; 
    ct1=0; ct2=0; ct3=0; ct4=0; ct5=0; ct6=0; ct7=0; ct8=0; 
    clear x1 x2 x3 x4 x5 x6 x7 x8 y1 y2 y3 y4 y5 y6 y7 y8 ; 
    x1(1)=NaN; y1(1)=NaN; 
    x2(1)=NaN; y2(1)=NaN;
    x3(1)=NaN; y3(1)=NaN; 
    x4(1)=NaN; y4(1)=NaN; 
    x5(1)=NaN; y5(1)=NaN; 
    x6(1)=NaN; y6(1)=NaN; 
    x7(1)=NaN; y7(1)=NaN;
    x8(1)=NaN; y8(1)=NaN; 
for i=1:length(z_hat{1,Kfav})
    if(z_hat{1,Kfav}(i)==1)
         x1(ct1+1)= i;
         y1(ct1+1)= FRET{1,1}(i);
         ct1=ct1+1;
    end
    if(z_hat{1,Kfav}(i)==2)
         x2(ct2+1)= i;
         y2(ct2+1)= FRET{1,1}(i);
         ct2=ct2+1;
    end
    if(z_hat{1,Kfav}(i)==3)
         x3(ct3+1)= i;
         y3(ct3+1)= FRET{1,1}(i);
         ct3=ct3+1;
    end
    if(z_hat{1,Kfav}(i)==4)
         x4(ct4+1)= i;
         y4(ct4+1)= FRET{1,1}(i);
         ct4=ct4+1;
   end
   if(z_hat{1,Kfav}(i)==5)
         x5(ct5+1)= i;
         y5(ct5+1)= FRET{1,1}(i);
         ct5=ct5+1;
  end
  if(z_hat{1,Kfav}(i)==6)
         x6(ct6+1)= i;
         y6(ct6+1)= FRET{1,1}(i);
         ct6=ct6+1;
  end
  if(z_hat{1,Kfav}(i)==7)
         x7(ct7+1)= i;
         y7(ct7+1)= FRET{1,1}(i);
         ct7=ct7+1;
  end
      if(z_hat{1,Kfav}(i)==8)
         x8(ct8+1)= i;
         y8(ct8+1)= FRET{1,1}(i);
         ct8=ct8+1;
      end    
end

% evaluate mean and std of data assigned to each state for use as flip metric
    y1_mean = mean(y1);
    y2_mean = mean(y2);
    y3_mean = mean(y3);
    y4_mean = mean(y4);
    y5_mean = mean(y5);
    y6_mean = mean(y6);
    y7_mean = mean(y7);
    y8_mean = mean(y8);
    y_std(1)=std(y1);
    y_std(2)=std(y2);
    y_std(3)=std(y3);
    y_std(4)=std(y4);
    y_std(5)=std(y5);
    y_std(6)=std(y6);
    y_std(7)=std(y7);
    y_std(8)=std(y8);
   end; % ends "if VT = T";
   
% --- Step 2 construct untangleMatrix
untangleMatrix                 = zeros(Kfav,8);
untangleMatrix_sort        = zeros(Kfav,8);
untangleMatrix_sort_flip = zeros(Kfav,8);
kk_old                               = linspace(1,Kfav,Kfav);
kk_new                             = linspace(1,Kfav,Kfav);

untangleMatrix(:,1) = bestOut{1,model}.m(1,:);% vector of m's for this model
untangleMatrix(:,2) = bestOut{1,model}.v(:,1);
untangleMatrix(:,3) = z_hat_value(1,:);       % original z_hat values
untangleMatrix(:,4) = kk_old(:);
untangleMatrix(:,5) = bestOut{1,model}.unscaledSigma(1,:);   % added 2013_12_13 gh
    
    if (VT == 'V')
        untangleMatrix_sort = sortrows(untangleMatrix,1);
        untangleMatrix_sort_flip = flipud(untangleMatrix_sort);
    end
    if (VT == 'T')
        untangleMatrix(1:Kfav,8) = y_std(1:Kfav);
        untangleMatrix_sort = sortrows(untangleMatrix,8);
        untangleMatrix_sort_flip = untangleMatrix_sort;  % flip not needed
    end
  
    untangleMatrix_sort_flip(:,8)=kk_new(:);
    kk_new_cell{1,1}    = kk_new;
       
mean_v=zeros(8,8);

model = Kfav;     % Select model

% ---Step 3. compute z_hat_untangled
for kk = 1:model  % kk is state within this model
  for kframe = 1:length(z_hat{1,model}(1,:))
     switch z_hat{1,model}(1,kframe)  % this evaluates to kk_old for kframe
        case 1
            clear idx;
            idx = find(untangleMatrix_sort_flip(:,3)==1);
            z_hat_untangled{1,model}(1,kframe) = idx; 
        case 2
            clear idx;
            idx = find(untangleMatrix_sort_flip(:,3)==2);
            z_hat_untangled{1,model}(1,kframe) = idx;
        case 3
            clear idx;
            idx = find(untangleMatrix_sort_flip(:,3)==3);
            z_hat_untangled{1,model}(1,kframe) = idx;
        case 4
            clear idx;
            idx = find(untangleMatrix_sort_flip(:,3)==4);
            z_hat_untangled{1,model}(1,kframe) = idx;
        case 5
            clear idx;
            idx = find(untangleMatrix_sort_flip(:,3)==5);
            z_hat_untangled{1,model}(1,kframe) = idx;
        case 6
            clear idx;
            idx = find(untangleMatrix_sort_flip(:,3)==6);
            z_hat_untangled{1,model}(1,kframe) = idx;
        case 7
            clear idx;
            idx = find(untangleMatrix_sort_flip(:,3)==7);
            z_hat_untangled{1,model}(1,kframe) = idx;
        case 8
            clear idx;
            idx = find(untangleMatrix_sort_flip(:,3)==8);
            z_hat_untangled{1,model}(1,kframe) = idx;
         end  % end switch
   end   % end for kframe

% ---Step 4. Define mean_v(kk) = m(kk) from bestOut
    %        and the number of frames for which Gaussian kk is responsible. 
   switch kk
      case 1
                mean_v(model,kk)= untangleMatrix_sort_flip(kk,1);
                bestOut_untangled{1,model}.v(kk,1)=untangleMatrix_sort_flip(kk,2);
      case 2 
                mean_v(model,kk)= untangleMatrix_sort_flip(kk,1);
                bestOut_untangled{1,model}.v(kk,1)=untangleMatrix_sort_flip(kk,2);
      case 3
                mean_v(model,kk)= untangleMatrix_sort_flip(kk,1);
                bestOut_untangled{1,model}.v(kk,1)=untangleMatrix_sort_flip(kk,2);
      case 4
                mean_v(model,kk)= untangleMatrix_sort_flip(kk,1);
                bestOut_untangled{1,model}.v(kk,1)=untangleMatrix_sort_flip(kk,2);
      case 5
                mean_v(model,kk)= untangleMatrix_sort_flip(kk,1);
                bestOut_untangled{1,model}.v(kk,1)=untangleMatrix_sort_flip(kk,2);
      case 6
                mean_v(model,kk)= untangleMatrix_sort_flip(kk,1);
                bestOut_untangled{1,model}.v(kk,1)=untangleMatrix_sort_flip(kk,2);
      case 7
                mean_v(model,kk)= untangleMatrix_sort_flip(kk,1);
                bestOut_untangled{1,model}.v(kk,1)=untangleMatrix_sort_flip(kk,2);
     end  % end of switch kk
    end   % end of "for kk = 1:model"
