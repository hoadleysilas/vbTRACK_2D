%   interpreter_real_data_3
%   v_amp, xprime,cos_theta, and theta from real data.
%    MMartin March 2012, gholz Jan 2013
% _2012_12_08 as interpreter_t prior to applying sign to v_amp for ALL
%       bouts (gh)
% _2013_05_02
% _2013_05_04 before using vx and vy in 2D vbTrack analysis
% _2013_05_19 before converting uniform theta to Gaussian theta_prime
% _2013_05_23 removing NaN's from theta_prime code next.
% _2013_05_25 before redefining theta using atan2(Y,X)
% _2013_06_19 renamed to interpreter_real_data_3 while working on paper to
% explain erfinv

fprintf('interpreter_real_data_3   L12 \n');
pause ()
movielength = length(x_micron);
allpath(:,1) = x_micron_SG;   
allpath(:,2) = y_micron_SG;

% --- evaluate v_amp values from x_micron_SG and y_micron_SG
xy_array   = allpath;
v_array    = diff(xy_array).*framerate;
v_array_SG = v_array;   % SG NOT applied
    % v_array_SG = sgolayfilt(v_array,9,41);
v_amp      = sqrt(v_array(:,1).^2 + v_array(:,2).^2);  % always positive!!
v_norm(:,1)  = v_array(:,1)./v_amp;  % normalize v for each frame
v_norm(:,2)  = v_array(:,2)./v_amp;
lengthv      = length(v_norm);
            % fprintf('interpreter L27\n');

% fix v_amp so v_bar = 0 in Brownian bouts by including sign(v_x);
% apply same algorithm to all data, not just Brownian (2012_12_08 gh)
v_amp_signed = sign(v_array(:,1)).*v_amp(:);      % added _signed 2013_05_26
v_amp_signed_SG = v_amp_signed;                    %     "       
    % v_amp_signed_SG = sgolayfilt(v_amp_signed,9,41); %     "       
       
% *********************   std of v_amp in driven and Brownian bouts  ****   
    %fprintf('interpreter L35 std_v_D and std_v_B\n')
    % min(v_amp(4:49))
    % max(v_amp(52:99))
    % min(v_amp(52:99))
v_bar_D = mean(v_amp(4:49));
std_v_D = std(v_amp(4:49)); % std of x component of driven part of allpath
v_bar_B = mean(v_amp(52:99));
std_v_B = std(v_amp(52:99));
        % fprintf('interpreter L43\n');        
        % v_amp = v_amp.*(framerate(1:end-1))';
        % v_norm(:,1)  = v_array(:,1)./v_amp;  
        % v_norm(:,2)  = v_array(:,2)./v_amp;
        % lengthv      = length(v_norm);

% % autocorrelation of v_amp
% [r,lags]=xcorr(v_amp,'coeff');  
% figure (20)
% plot(r)
%     title('Fig 20 r for v_amp')
%     pause ();
% figure (21)
% plot(lags)
%     title('Fig 21 lags');
%     pause ()
    
% --- compute cos_theta
% cos_theta = cos of the angle between consecutive steps in path
% theta = the angle between consecutive steps
cos_theta   = zeros(movielength, 1);
theta       = zeros(lengthv-1,1);
theta_prime = zeros(lengthv-1,1);
t_array     = linspace(0,lengthv-2,lengthv-1);
t_array_long= linspace(0,lengthv-1,lengthv);
            % fprintf('interpreter L68\n');

for i=1:lengthv-1
    cos_theta(i) = dot(v_norm(i,:),v_norm(i+1,:));
      % theta(i) = asin(v_norm(i,1)*v_norm(i+1,2)-v_norm(i,2)*v_norm(i+1,1));
      % % theta_prime(i)=sign(theta(i))*(1/sqrt(2*pi))*exp(-((theta(i)^2)/2));
      % theta_prime(i) = erfinv(theta(i)/pi);
end

% --- compute theta and theta_prime using subroutine theta_atan2
theta_atan2;  % function with input=v_norm; output = theta.
theta_prime = erfinv(theta./pi);   % erfinv expects uniform dist [-1,1]

% replace NaN's   XXX  Why are there NaN's in the first place? gh
iNaN_t = find(isnan(theta) == 1);
theta(iNaN_t) = 0;

theta_prime(iNaN_t) = 0;   % XXX added 05_23_2013
iNaN_c = find(isnan(cos_theta) == 1);
cos_theta(iNaN_c) = 0;

% figure(4); plot(t(1:end-2),cos_theta);
tt = linspace(0, 0.01*length(theta)-1,length(theta)); 

figure (1)      % ******************************    Fig1 theta vs t
plot(tt,theta,'ok');  
    title('Fig1. theta');
    ylim([-3.4  3.4]);
    xlabel('t');
    ylabel('theta');
    pause ()
    
figure (2)   % ***************************************  Fig2 Hist Uniform
bins = -3.2:0.1:3.2;  % numBins = 64
hist(theta,bins)
    title('Fig2, hist(theta)')
    xlabel('theta');
    ylabel('p(theta)');
    pause  ()
    
figure (3)
plot(tt,theta_prime,'ok');     % ***********************    Fig3 theta-prime
    title('Fig3. theta-prime');
    ylim([-3.4  3.4]);
    xlabel('t');
    ylabel('theta-prime');
    pause ()
    
figure (4)   % ***************************************       Fig4 Hist theta-prime
bins = -3.2:0.1:3.2;  % numBins = 64
hist(theta_prime,bins)
    title('Fig4, hist(theta-prime)')
    xlabel('theta-prime');
    ylabel('p(theta-prime)');
    pause  ()

% --- Get xprime values at time t
%Perform Coordinate Transformation to get xprime data (from segment_fit_realData_stdev lines 42-213)
L = length(allpath);
N  = L-1;
t = 1:L ;

xx_long = allpath(:,1);
y_long = allpath(:,2);
% Adjust so first point is at (0,0);
xx_zero = (xx_long(1:L) - xx_long(1));
yy_zero = ( y_long(1:L) -  y_long(1));

% figure(1)
% subplot(1,2,1)
% plot(t,xx_zero);
% xlabel('t (frames)');
% ylabel('xx-zero(pixels)');
% title('Input x vs t');
% 
% subplot(1,2,2)
% plot(t, yy_zero);
% xlabel('t(framess)')
% ylabel('yy-zero')
% title('Input y vs t')

%    Choose xx and yy axes so movement is largely along the +x axis
% %    and y movement is also positive.
% if (xx_zero(N)>=0 && yy_zero(N)>=0 && xx_zero(N)/yy_zero(N)>=1)
   xx = xx_zero;
   yy = yy_zero;
% end;
% if (xx_zero(N)>=0 && yy_zero(N)>=0 && xx_zero(N)/yy_zero(N)<1)
%     xx = yy_zero;
%     yy = xx_zero;
% end;
% if (xx_zero(N)>=0 && yy_zero(N)<0 && -xx_zero(N)/yy_zero(N)>1)
%     xx = xx_zero;
%     yy = -yy_zero;
% end
% if (xx_zero(N)>=0 && yy_zero(N)<0 && -xx_zero(N)/yy_zero(N)<1)
%     yy = xx_zero;
%     xx = -yy_zero;
% end
% if (xx_zero(N)<0 && yy_zero(N)>=0 && -xx_zero(N)/yy_zero(N)>=1)
%     xx = -xx_zero;
%     yy =  yy_zero;
% end;
% if (xx_zero(N)<0 && yy_zero(N)>=0 && -xx_zero(N)/yy_zero(N)<1)
%     xx =  yy_zero;
%     yy = -xx_zero;
% end;
% if (xx_zero(N)<0 && yy_zero(N)<0 && xx_zero(N)/yy_zero(N)>=1)
%     xx = -xx_zero;
%     yy = -yy_zero;
% end
% if (xx_zero(N)<0 && yy_zero(N)<0 && xx_zero(N)/yy_zero(N)<1)
%     yy = -xx_zero;
%     xx = -yy_zero;
% end
N  = L-1;
DN = 10;   % half-width of zone for polynomial fit to do transformation

% plot to check input procedure
figure(6)
subplot(1,2,1)
plot(t,xx);
xlabel('t (frames)');
ylabel('xx');
title('Input data with axis choice vs t');

subplot(1,2,2)
plot(t,yy);
xlabel('t')
ylabel('yy')
title('Input data with axis choice vs t')
pause ()

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
%    figure(3)
%    plot(xx,slope,'o')
%                 xlabel('xx');
%                 ylabel('slope');
%                 title('Slope of polynomial');
%                 pause(0.3);
        
% transform (xx,yy) to (x',y')
    theta2 = atan(slope);


%theta2=linspace(0,0,length(t));     % fixup for short fake data input
% figure(4)
% plot(t,theta2, 'o');
%             xlabel('t');
%             ylabel('theta2');
%         %pause();

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

% figure(5)
% subplot(1,2,1)
% plot(t,XY(:,1))
% xlabel('t')
% ylabel('x')
% title('Original data, x');
% 
% subplot(1,2,2)
% plot(t,XY_prime(:,1))
% xlabel('t')
% ylabel('x-prime')
% title('transformed x');
% 
% 
% figure(6)
% subplot(1,2,1)
% plot(t,XY(:,2))
% xlabel('t')
% ylabel('y')
% title('Original data, y');
% 
% subplot(1,2,2)
% plot(t,XY_prime(:,2))
% xlabel('t')
% ylabel('y-prime')
% title('transformed y');

% Convert to seconds and microns, store in matrix form
y=XY_prime(:,1)/9.36;          % y in micrometers.
t = (t-t(1))/8.3;              % t is in seconds
tX=zeros(L,2);
tX(:,1)=t;
tX(:,2)=y;
tX(1:5,:);
xprime = y;                
fprintf('leaving Interpreter_real_data_3 L 268\n')
pause ()
