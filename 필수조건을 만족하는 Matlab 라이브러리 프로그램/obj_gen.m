function [dist,speed]=obj_gen(N,N_weibull)

speed_tmp=-210+420*rand(1,N); 
dist_tmp=243*rand(1,N); 

% dist = [243*rand(1,empty_N) dist_tmp]; % distance in meters
% r = abs(randn(1, 1000));
% dist = [243*normalize(r, 'range') dist_tmp];



pd = makedist('Weibull',1,1);
r = random(pd,1,N_weibull);
r = r*6;
dist = [r dist_tmp];
 
speed = [zeros(1,N_weibull) speed_tmp]; % moving speed in km/h

% 
% pd = makedist('Weibull',20,1);
% r = random(pd,1,N_weibull);

% figure(1)
% histogram(dist)
% legend('a=1, b=1')
% figure(4)
% histogram(r)
% legend('a=1, b=1')