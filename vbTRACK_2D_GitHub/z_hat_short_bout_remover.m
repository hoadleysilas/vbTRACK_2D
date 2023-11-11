function [z_clean]= z_hat_clean(z)
% removes 1 or 2-frame bouts embedded within a longer bout
% written by gholzwrth 2014_10.
    
% eliminate bouts of length 1.
for i=2:length(z)-1;
       if (z(i)~=z(i-1))&&(z(i-1)==z(i+1))
           z(i)=z(i-1);
       end
end

% % % eliminate bouts of length 2 
% for i=3:(length(z)-1)
%        if ( (z(i)~=z(i-2))  &&  (z(i-2)==z(i+1)))
%             z(i)      =  z(i-2);
%             z(i-1)  =  z(i-2);
%        end
% end   % end of for loop for bouts of length 2
% 
% % eliminate bouts of length 3 
% for i=4:(length(z)-1)
%        if ( (z(i)~=z(i-3))  &&  (z(i-3)==z(i+1)))
%          %  if (  (z(i)==z(i-1))  &&  (z(i)~=z(i-2))  &&  (z(i-2)==z(i+1)))
%             z(i)      =  z(i-3);
%             z(i-2)   = z(i-3);
%             z(i-2)  =  z(i-3);
%        end
% end   % end of for loop for bouts of length 3

 z_clean = z;
end   % end of function z_hat_clean
