%   interpreter
%   evaluate v_amp,  theta, and theta-prime from {x,y,t} tracking data 
% Matthew J. Martin, G. Holzwarth, 2012-2014
fprintf('Step 3. Start interpreter\n');

movielength = length(x_micron);
allpath(:,1) = x_micron_SG;   
allpath(:,2) = y_micron_SG;

% --- evaluate v_amp values from x_micron_SG and y_micron_SG
xy_array   = allpath;
v_array    = diff(xy_array).*framerate;
v_array_SG = v_array;   % SG NOT applied
v_amp      = sqrt(v_array(:,1).^2 + v_array(:,2).^2);  % always positive!!
v_norm(:,1)  = v_array(:,1)./v_amp;  % normalize v for each frame
v_norm(:,2)  = v_array(:,2)./v_amp;
lengthv      = length(v_norm);

% fix v_amp so v_bar = 0 by including sign(v_x);
v_amp_signed         =  sign(v_array(:,1)).*v_amp(:);
v_amp_signed_SG =  v_amp_signed; % Savitzky-Golay smoothing NOT employed                  
    % v_amp_signed_SG = sgolayfilt(v_amp_signed,9,41);   % SG smoothing IS employed       
       
% *********************   std of v_amp in driven and Brownian bouts  ****   
 v_bar_D = mean(v_amp(4:49));
std_v_D = std(v_amp(4:49)); % std of x component of driven part of allpath
v_bar_B = mean(v_amp(52:99));
std_v_B = std(v_amp(52:99));
    
% --- compute cos_theta, theta, theta_prime
cos_theta   = zeros(movielength, 1);
theta       = zeros(lengthv-1,1);
theta_prime = zeros(lengthv-1,1);
t_array     = linspace(0,lengthv-2,lengthv-1);
t_array_long= linspace(0,lengthv-1,lengthv);
 
for i=1:lengthv-1
    cos_theta(i) = dot(v_norm(i,:),v_norm(i+1,:));
end

% --- compute theta and theta_prime using subroutine theta_atan2
theta_atan2;                                 % function with input=v_norm; output = theta.
theta_prime = erfinv(theta./pi);   % erfinv expects uniform dist [-1,1]

% replace NaN's 
iNaN_t = find(isnan(theta) == 1);
theta(iNaN_t) = 0;

theta_prime(iNaN_t) = 0; 
iNaN_c = find(isnan(cos_theta) == 1);
cos_theta(iNaN_c) = 0;


tt = linspace(0, 0.01*length(theta)-1,length(theta)); 

% --- Set  initial xx and yy to 0.
L = length(allpath);
N  = L-1;
t = 1:L ;

xx_long = allpath(:,1);
y_long = allpath(:,2);
xx_zero = (xx_long(1:L) - xx_long(1));
yy_zero = ( y_long(1:L) -  y_long(1));
   xx = xx_zero;
   yy = yy_zero;
N  = L-1;
DN = 10;   % half-width of zone for polynomial fit to do transformation

% Fit 2DN+1 data points to a polynomial of order 1
   n=1;                 % order of polynomial so y = p1x + p2
   p=zeros(N+1,n+1);    %preallocate matrix of polynomial coefficients
   for nn=DN+1:N+1-DN
        p(nn,:) = polyfit(xx(nn-DN:nn+DN),yy(nn-DN:nn+DN),n);
   end;
   for nn=2:DN
       p(nn,:) = polyfit(xx(1:2*nn-1),yy(1:2*nn-1),n);
   end
   for nn=2:DN
       mid=N+2-nn;
       p(mid,:) = polyfit(xx(N+3-2*nn:N+1),yy(N+3-2*nn:N+1),n);
   end
   p(1,:)  = polyfit(xx(1:5),yy(1:5),n);
   p(N+1,:)= polyfit(xx(N-4:N+1),yy(N-4:N+1),n);     
      
   slope = 0:0:length(t);  
   slope = p(:,1);
        
% transform (xx,yy) to (x',y')
    theta2 = atan(slope);


% Construct transformation matrices by horsepower
M=zeros(2,2,N+1);
for i=1:N+1
    M(1,1,i) =   cos(theta2(i));
    M(1,2,i) =   sin(theta2(i));
    M(2,1,i) = - sin(theta2(i));
    M(2,2,i) =   cos(theta2(i));
end
% carry out transformation
XY(:,1)=xx-xx(1);
XY(:,2)=yy-yy(1);

i=1;
XY_prime(i,1)=0;
XY_prime(i,2)=0;
i=2;
XY_prime(i,1)=M(1,1,i)*XY(i,1) + M(1,2,i)*XY(i,2);
XY_prime(i,2)=M(2,1,i)*XY(i,1) + M(2,2,i)*XY(i,2);
for i=3:N+1
    XY_prime(i,1)=M(1,1,i)*(XY(i,1)-XY(i-1,1)) + M(1,2,i)*(XY(i,2)-XY(i-1,2))+XY_prime(i-1,1);
    XY_prime(i,2)=M(2,1,i)*(XY(i,1)-XY(i-1,1)) + M(2,2,i)*(XY(i,2)-XY(i-1,2));
end

% Convert to seconds and microns, store in matrix form
y=XY_prime(:,1)/9.36;          % y in micrometers.  Your conversion pixels/micron may differ!
t = (t-t(1))/8.3;                        % t is in seconds. Your frame rate may differ!
tX=zeros(L,2);
tX(:,1)=t;
tX(:,2)=y;
tX(1:5,:);
xprime = y;                
